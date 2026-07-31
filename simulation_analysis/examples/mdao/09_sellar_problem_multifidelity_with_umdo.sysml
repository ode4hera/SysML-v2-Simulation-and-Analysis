package MDAO_SellarProblem_Multifidelity_Example_with_UMDO {
    doc /* An example of multifidelity derived from the MDAO Sellar test problem for UMDO.
    For the source code: https://gemseo.gitlab.io/dev/gemseo-multi-fidelity/0.0.1/generated/examples/multifidelity_with_uncertainties/plot_sellar_mf_umdo/
    
    Copyright 2026 Deutsches Zentrum für Luft- und Raumfahrt eV (DLR), Siemens Industry Software NV, Siemens AG, Siemens Industry Software SAS, IRT Saint Exupéry, EnginSoft SpA, Airbus Defence and Space SA, Airbus Defence and Space GmbH, Leonardo SpA
    */
    
    private import ArchitectureDesign::*;
    private import MultidisciplinaryDesignAnalysisOptimization::*;
    private import MultidisciplinaryDesignAnalysisOptimization::Uncertainty::*;
    private import MultidisciplinaryDesignAnalysisOptimization::MultifidelityAttributes::*;
    private import ScalarValues::*;
    private import ProbabilityAndSampling::*;
   

    #umdaoProcessArchitecture part SellarMultifidelityArchitecture {

        SellarMultifidelityModel:>> multifidelityModel = MultiFidelityManagement::Refinement {
            n_levels = 2;
        }

        part multifidelitySellarProblem :>> umdaoProblem {

            
            :>> deterministicVariables[3] = (x, z1, z2);
            
            #contX attribute x : Real default 1.0 {
                redefines lowerBound = 0.0;
                redefines upperBound = 10.0;
            }

            #contX attribute z1 : Real default 4.0 {
                redefines lowerBound = -10.0;
                redefines upperBound = 10.0;
            }

            #contX attribute z2 : Real default 3.0 {
                redefines lowerBound = 0.0;
                redefines upperBound = 10.0;
            }

            :>> uncertainVariables[1] = (a);

            #uncertainVariable attribute a {
                :>> distribution :> TriangularDistribution {
                    :>> min  = 0.1;
                    :>> mode = 0.2;
                    :>> max  = 0.3;
                }
            }

            :>> objectives[1] = sellarObjectiveFunction;

            #minObj attribute sellarObjectiveFunction;

            :>> constraints[2] = (c1, c2);

            #umdaoConstraint attribute c1 : Real {

                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 3.0;

                assert constraint { that <= 0.0 }
            }

            #umdaoConstraint attribute c2 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 3.0;

                assert constraint { that <= 0.0 }
            }
            
        }

        part umdaoSellarStrategy_samplingA :> umdaoStrategy {

            :>> disciplines[3] = (SellarDiscipline1, SellarDiscipline2, SellarSystem);

            #discipline part SellarDiscipline1{
                in x : Real;
                in y2 : Real;
                in z1 : Real;
                in z2 : Real;
                in a : Real;
                out y1 : Real;
                #mdaoModel part analyticalModel:MDAOAnalyticalModel{
                    doc
                    /*
                    * y1 = (z1**2 + z2 + x - a*y2)**0.5
                    */
                }
            }
            
            #discipline part SellarDiscipline2{
                in y1: Real;
                in z1 : Real;
                in z2 : Real;
                out y2 : Real;
                #mdaoModel part analyticalModel:MDAOAnalyticalModel{
                    doc
                    /*
                    *  y2 = abs(y1) + z1 + z2
                    */
                }
            }
            #discipline part SellarSystem{ 
                in x : Real;
                in z2 : Real;
                in y1 : Real;
                in y2 : Real;
                out c1;
                out c2;
                out obj;
                #mdaoModel part analyticalModel:MDAOAnalyticalModel{
                    doc/*
                        * """Objective function."""
                        *    obj = x**2 + z2 + y1**2 + exp(-y2)
                        *    c1 = 3.16 - y1**2
                        *    c2 = y2 - 24.0
                        */
                }
            }

            bind SellarDiscipline1.y1 = SellarDiscipline2.y1;
            bind SellarDiscipline2.y2 = SellarDiscipline1.y2;
            
            :>> mdoFormulation = MDOFormulation::Mdf;

            part sellarOptimizer :>> optimizer {
                perform action sellarOptimizationAlgorithm :>> optimizationAlgorithm {
                    :>> method:OptimizationMethod = OptimizationMethod::GradientFree;
                    :>> algorithmName:OptimizationAlgorithmType = OptimizationAlgorithmType::Cobyla;
                    :>> maxIter = 30;
                }
            }

            part MDAGaussSeidelConverger :>> converger {
                :>> convergenceMethod:ConvergenceMethod = ConvergenceMethod::GaussSeidel;
            }

            perform action sellarStatistics :>> statistics {
                doc /* The UMDO scenario uses "Mean" as statistic_name
                     * for the objective, i.e. E[f(x,z2,y1,y2)]. */

                :>> statisticType = StatisticType::Mean;

                :>> estimationSettings : SamplingEstimationSettings {
                    :>> sampleSize = 20; 
                }
            }

            perform action sellarSampling :>> sampling {
                  doc /* Crude Monte Carlo sampling with 100 samples per
                     * optimization iteration, as in the UMDO sampling
                     * Sellar example. */

                :>> method      = SamplingMethod::MonteCarlo;
                :>> nSamples    = 20;
                :>> isSequential = false;
            }

        }

        part umdaoSellarStrategy_samplingB :> umdaoStrategy {

            :>> disciplines[3] = (SellarDiscipline1, SellarDiscipline2, SellarSystem);

            #discipline part SellarDiscipline1{
                in x : Real;
                in y2 : Real;
                in z1 : Real;
                in z2 : Real;
                in a : Real;
                out y1 : Real;
                #mdaoModel part analyticalModel:MDAOAnalyticalModel{
                    doc
                    /*
                    * y1 = (z1**2 + z2 + x - a*y2)**0.5
                    */
                }
            }
            
            #discipline part SellarDiscipline2{
                in y1: Real;
                in z1 : Real;
                in z2 : Real;
                out y2 : Real;
                #mdaoModel part analyticalModel:MDAOAnalyticalModel{
                    doc
                    /*
                    *  y2 = abs(y1) + z1 + z2
                    */
                }
            }
            #discipline part SellarSystem{ 
                in x : Real;
                in z2 : Real;
                in y1 : Real;
                in y2 : Real;
                out c1;
                out c2;
                out obj;
                #mdaoModel part analyticalModel:MDAOAnalyticalModel{
                    doc/*
                        * """Objective function."""
                        *    obj = x**2 + z2 + y1**2 + exp(-y2)
                        *    c1 = 3.16 - y1**2
                        *    c2 = y2 - 24.0
                        */
                }
            }

            bind SellarDiscipline1.y1 = SellarDiscipline2.y1;
            bind SellarDiscipline2.y2 = SellarDiscipline1.y2;
            
            :>> mdoFormulation = MDOFormulation::Mdf;

            part sellarOptimizer :>> optimizer {
                perform action sellarOptimizationAlgorithm :>> optimizationAlgorithm {
                    :>> method:OptimizationMethod = OptimizationMethod::GradientFree;
                    :>> algorithmName:OptimizationAlgorithmType = OptimizationAlgorithmType::Cobyla;
                    :>> maxIter = 30;
                }
            }

            part MDAGaussSeidelConverger :>> converger {
                :>> convergenceMethod:ConvergenceMethod = ConvergenceMethod::GaussSeidel;
            }

            perform action sellarStatistics :>> statistics {
                doc /* The UMDO scenario uses "Mean" as statistic_name
                     * for the objective, i.e. E[f(x,z2,y1,y2)]. */

                :>> statisticType = StatisticType::Mean;

                :>> estimationSettings : SamplingEstimationSettings {
                    :>> sampleSize = 7; 
                }
            }

            perform action sellarSampling :>> sampling {
                  doc /* Crude Monte Carlo sampling with 100 samples per
                     * optimization iteration, as in the UMDO sampling
                     * Sellar example. */

                :>> method      = SamplingMethod::MonteCarlo;
                :>> nSamples    = 7;
                :>> isSequential = false;
            }

        }

        part umdaoSellarSolutionCV :> mdaoSolution, multifidelitySellarProblem {

            :>> designVariablesSolution[3] = (x, z1, z2);
            :>> x : Real;
            :>> z1 : Real;
            :>> z2 : Real;

            :>> objectiveFunctionSolution[1] = sellarObjectiveFunction;
            :>> sellarObjectiveFunction;

            :>> constraintsSolution[2] = (c1, c2);
            :>> c1;
            :>> c2;
        }
    }

}