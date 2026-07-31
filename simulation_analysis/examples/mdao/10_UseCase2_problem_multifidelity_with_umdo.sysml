package MDAO_UC2_problem_multifidelity_with_umdo {
  doc /* An implementation of mutlifidelity with umdo for the use-case 2
    
    Copyright 2026 Deutsches Zentrum für Luft- und Raumfahrt eV (DLR), Siemens Industry Software NV, Siemens AG, Siemens Industry Software SAS, IRT Saint Exupéry, EnginSoft SpA, Airbus Defence and Space SA, Airbus Defence and Space GmbH, Leonardo SpA
    */
    private import ArchitectureDesign::*;
    private import MultidisciplinaryDesignAnalysisOptimization::*;
    private import MultidisciplinaryDesignAnalysisOptimization::Uncertainty::*;
    private import ScalarValues::*;
    private import ProbabilityAndSampling::*;
    private import MultifidelityAttributes::*;

    #umdaoProcessArchitecture part UC2_Process_Mutlifidelity_Architecture {

        HybridAircraft_MultifidelityModel :>>multifidelityModel = MultiFidelityManagement::Refinement{
            n_levels = 3;
        }

        part HybridAircraft_Problem :> umdaoProblem {
            :>> deterministicVariables[10] = (x01,x02,x03,x04,x05,x06,x07,x08,x09,x10);
            
            #contX attribute x01 {
                redefines lowerBound = 2.0;
                redefines upperBound = 10.0;
            }
            #contX attribute x02 {
                redefines lowerBound = -5.0;
                redefines upperBound = 5.0;
            }
            #contX attribute x03 {
                redefines lowerBound = 0;
                redefines upperBound = 2.0;
            }
            #contX attribute x04 {
                redefines lowerBound = 0.5;
                redefines upperBound = 1.5;
            }
            #contX attribute x05 {
                redefines lowerBound = 0.00005;
                redefines upperBound = 0.02;
            }
            #contX attribute x06 {
                redefines lowerBound = 0.00005;
                redefines upperBound = 0.02;
            }
            #contX attribute x07 {
                redefines lowerBound = 0.4;
                redefines upperBound = 0.8;
            }
            #contX attribute x08 {
                redefines lowerBound = 0.2;
                redefines upperBound = 0.5;
            }
            #contX attribute x09 {
                redefines lowerBound = 30;
                redefines upperBound = 500;
            }
            #contX attribute x10 {
                redefines lowerBound = 10.0;
                redefines upperBound = 20.0;
            }
            
            

            #uncertainVariable attribute u_x01 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.4;
                    :>> mode = 0;
                    :>> max  = 0.4;
                }
            }
            #uncertainVariable attribute u_x02 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.5;
                    :>> mode = 0;
                    :>> max  = 0.5;
                }
            }
            #uncertainVariable attribute u_x03 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.1;
                    :>> mode = 0;
                    :>> max  = 0.1;
                }
            }
            #uncertainVariable attribute u_x04 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.05;
                    :>> mode = 0;
                    :>> max  = 0.05;
                }
            }
            #uncertainVariable attribute u_x05 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.0001;
                    :>> mode = 0;
                    :>> max  = 0.0001;
                }
            }
            #uncertainVariable attribute u_x06 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.0001;
                    :>> mode = 0;
                    :>> max  = 0.0001;
                }
            }
            #uncertainVariable attribute u_x07 {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.02;
                    :>> mode = 0;
                    :>> max  = 0.02;
                }
            }
            ref #uncertainVariable attribute u_x08 :> UncertainVariable {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.015;
                    :>> mode = 0;
                    :>> max  = 0.015;
                }
            }
            ref #uncertainVariable attribute u_x09 :> UncertainVariable {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -23.5;
                    :>> mode = 0;
                    :>> max  = 23.5;
                }
            }
            ref #uncertainVariable attribute u_x10 :> UncertainVariable {
                :>> distribution :> TriangularDistribution {
                    :>> min  = -0.5;
                    :>> mode = 0;
                    :>> max  = 0.5;
                }
            }

            :>> uncertainVariables[10] = (u_x01, u_x02, u_x03, u_x04, u_x05, u_x06, u_x07, u_x08, u_x09, u_x10);
        
            ref #maxObj attribute f ;
            :>> objectives[1] = f;

            #umdaoConstraint attribute c1 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c2 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c3 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c4 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c5 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c6 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c7 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c8 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }
            #umdaoConstraint attribute c9 : Real {
             
                :>> uqConstraintType = UQConstraintType::Margin;
                :>> statisticType    = StatisticType::StandardDeviation;
                :>> marginFactor     = 2.0;

                assert constraint { that <= 0.0 }
            }

            :>> constraints[9] = (c1, c2, c3, c4, c5, c6, c7, c8, c9);

        }

        part HybridAircraft_LowFidelityStrategy :> HybridAircraft_GenericStrategy{

            perform action UC2_Statistics :>> statistics {
                doc /* The UMDO scenario uses "Mean" as statistic_name
                        * for the objective, i.e. E[f(x,z2,y1,y2)]. */

                :>> statisticType = StatisticType::Mean;

                :>> estimationSettings : SamplingEstimationSettings {
                    :>> sampleSize = 10; 
                }
            }

            perform action SamplingStrategy :>> sampling {
                    doc /* Crude Monte Carlo sampling with n samples per
                        * optimization iteration, as in the UMDO sampling */

                :>> method = SamplingMethod::MonteCarlo;
                :>> nSamples = 10;
                :>> isSequential = false;
            }
        }

        part HybridAircraft_IntermediateFidelityStrategy :> HybridAircraft_LowFidelityStrategy {
            :>> UC2_Statistics.statisticType = StatisticType::Mean;
            :>> UC2_Statistics.estimationSettings.sampleSize = 26;           
            :>> SamplingStrategy.nSamples = 26;
        }

        part HybridAircraft_HighFidelityStrategy :> HybridAircraft_LowFidelityStrategy {
            :>> UC2_Statistics.statisticType = StatisticType::Mean;
            :>> UC2_Statistics.estimationSettings.sampleSize = 100;           
            :>> SamplingStrategy.nSamples = 100;
        }
                
        abstract part HybridAircraft_GenericStrategy :> umdaoStrategy {
        
            ref disciplines :>> disciplines[12] = (
                RBF_f, 
                RBF_c1, 
                RBF_c2, 
                RBF_c3, 
                RBF_c4, 
                RBF_c5, 
                RBF_c6, 
                RBF_c7, 
                RBF_c8, 
                RBF_c9,
                analytic_c6,
                analytic_c9
            );

            #discipline part RBF_f{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out f;
                #mdaoModel part surrogate : SurrogateModel;
            }
            #discipline part RBF_c1{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c1;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c2{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c2;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c3 {
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c3;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c4{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c4;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c5{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c5;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c6{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                in c7 : Real;
                out c6_;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c7{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c7;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c8{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                out c8;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part RBF_c9{
                in x01 : Real ;
                in x02 : Real ;
                in x03 : Real ;
                in x04 : Real ;
                in x05 : Real ;
                in x06 : Real ;
                in x07 : Real ;
                in x08 : Real ;
                in x09 : Real ;
                in x10 : Real ;
                in u_x01 : Real ;
                in u_x02 : Real ;
                in u_x03 : Real ;
                in u_x04 : Real ;
                in u_x05 : Real ;
                in u_x06 : Real ;
                in u_x07 : Real ;
                in u_x08 : Real ;
                in u_x09 : Real ;
                in u_x10 : Real ;
                in c7 : Real;
                out c9_;
                #mdaoModel part surrogate : SurrogateModel;
            }

            #discipline part analytic_c6{
                in c6_;
                out c6;

                #mdaoModel part analyticalModel : MDAOAnalyticalModel {
                    doc
                    /*
                     * c6 = -1 / (c6_ + 3.8) + 0.4
                     *
                     */
                }
            }
            #discipline part analytic_c9{
                in c9_;
                out c9;

                 #mdaoModel part analyticalModel : MDAOAnalyticalModel {
                    doc
                    /*
                     * c9 = 1 / (c9_ + 3.8) - 1.2
                     */
                }
            }
          
            mdoFormulation :>> mdoFormulation = MDOFormulation::Mdf;

            part UC2Optimizer :>> optimizer {
                perform action UC2OptimizationAlgorithm :>> optimizationAlgorithm {
                        :>> method:OptimizationMethod = OptimizationMethod::GradientFree;
                        :>> algorithmName:OptimizationAlgorithmType = OptimizationAlgorithmType::Cobyla;
                        :>> maxIter = 1000;
                    }
            }

            part MDAGaussSeidelConverger :>> converger {
                    :>> convergenceMethod:ConvergenceMethod = ConvergenceMethod::GaussSeidel;
            }
        }

        part HybridAircraft_multifidelitySolution :> mdaoSolution, HybridAircraft_Problem {
            :>> designVariablesSolution[10] = (x01, x02, x03, x04, x05, x06, x07, x08, x09, x10);
            x01 :>> x01 : Real;
            x02 :>> x02 : Real;
            x03 :>> x03 : Real;
            x04 :>> x04 : Real;
            x05 :>> x05 : Real;
            x06 :>> x06 : Real;
            x07 :>> x07 : Real;
            x08 :>> x08 : Real;
            x09 :>> x09 : Real;
            x10 :>> x10 : Real;
        
            :>> objectiveFunctionSolution[1] = f;
            f :>> f;

            :>> constraintsSolution[7] = (c1, c2, c3, c4, c5, c6, c7, c8, c9);
            :>> c1;
            :>> c2;
            c3 :>> c3;
            c4 :>> c4;
            c5 :>> c5;
            c6 :>> c6;
            c7 :>> c7;
            c8 :>> c8;
            c9 :>> c9;

        }
    }

}