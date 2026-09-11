//
// Model-Based Design library
//
// Library for modeling model-based design concepts.
//
// This library has been developed as part of the ODE4HERA project: https://www.ode4hera.eu/
//
// Version: v2.0
// License: MIT
// Maintainer: DLR Institute of System Architectures in Aeronautics
// Contact: digital.engineering@dlr.de
// Topics: MBD, Model-Based Design
//
// MIT License
//
// Copyright: (c) 2026, The Contributors to the ODE4HERA SysML v2 Libraries.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

library package ModelBasedDesign {
    doc
    /*
     * Domain-specific library implementing Model-Based Design Capabilities:
     * - Meta-Information specific to MBD (for generic provenance meta-information see ODE4HERA library)
     * - Behavioral Model (linked but possibly different from System Model Architecture)
     * - Behavioral Model execution information (modelled as actions)
     * - Simulation information including execution and results
     *
     * Copyright: (c) 2026, The Contributors to the ODE4HERA SysML v2 Libraries.
     */
    private import RequirementsManagement::ProvenanceAttributes;
    private import RequirementsManagement::Stakeholder;
    private import ArchitectureDesign::Architecture;
    private import SequenceFunctions::*;

    public import MBDSemanticMetadata::*;
    public import 'FMIv2.0.5'::*;

    // Meta-Information

    metadata def ExecutableModelMetadata specializes ProvenanceAttributes {  // shorten removing "Model", same for other metadata
        doc /*Container for meta-info related to executable models for MBD (and MDAO?)*/
        attribute authoringTool : ScalarValues::String [0..1] {
            doc /*Tool used to create the executable model,
            this is relevant since it might give constraints
            for the integration of the model in the execution platform*/
        }
        attribute domain : ScalarValues::String [0..1] {
            doc /*Engineering domain associated with the executable model.
            Example of engineering domains are Aerodynamic, Structure,
            Mechatronics, Thermodynamic, etc.*/
        }
        attribute externalModelLink : ScalarValues::String [0..1] {  // add details on type of link:library path, directory path: any std/ext lib support?
            doc /*Path to the actual executable model. Note
            that this is not necessarily an executable file, it could be an FMU or
            a specific file format to be run on a specific execution platform*/
        }
        part executor : Executor {  // make sense only for simulation architecture, not for simulation components 
            doc /*Engineer in charge of model execution (might be different from the
            engineer responsible for execution of entire/master workflow which is composed
            by several executable models)*/
        }
        :> annotatedElement: SysML::PartDefinition;
        :> annotatedElement: SysML::PartUsage;
        :> annotatedElement: SysML::PortDefinition;
        :> annotatedElement: SysML::PortUsage;
    }
    part def Executor :> Stakeholder {
        :>> risk[0];
        :>> effort[0];
    }

    metadata def BehavioralModelMetadata :> ExecutableModelMetadata {
        doc /*Container for meta-info specific to the behavioral model*/
        attribute timeBehavior:TimeBehavior;
        attribute dynamicType:DynamicType;
        attribute linearity:Linearity;
        attribute nonLinearityType:NonLinearityType;
        attribute timeDomainSolver:TimeDomainSolver; // used only for embedded time domain
        attribute embeddedTimeDomainSolver : ScalarValues::Boolean; //useful only for FMU?
        attribute maxTimeStep : ScalarValues::Real;
        attribute minTimeStep : ScalarValues::Real;
        :> annotatedElement: SysML::ActionDefinition;
        :> annotatedElement: SysML::ActionUsage;
    }
    enum def TimeBehavior {Static; Dynamic;}
    enum def DynamicType {TimeVarying; TimeInvariant;}
    enum def Linearity {Linear; NonLinear; }
    enum def NonLinearityType {ContinuousState; DiscreteState;}
    enum def TimeDomainSolver {
        comment /*Inspired by FMI, to be checked if the info should be exposed here*/
    }

    item def ExecutionConfiguration { // proposal: change name to SimulationConfiguration to clearly distinguish wrt ExecutableModelMetamodel
        doc /**/
        attribute simulationType : SimulationType;
        attribute verificationLogic : ExtractionLogic; // should be assign to each output since single simulation execution could verify multiple requirements
        attribute startTime : ScalarValues::Real;
        attribute stopTime : ScalarValues::Real;
        attribute numberOfIntervals : ScalarValues::Integer;
        attribute tolerance : ScalarValues::Real;
        attribute method : ScalarValues::String;
        attribute outputFormat : ScalarValues::String;
    }
    enum def SimulationType {Time; Frequency;}
    enum def ExtractionLogic {
        doc /* Represent rationale for extraction of (scalar) value from simulation results (often time series) */
        Max {doc /* Take maximum value */}
        Min {doc /* Take minimum value */}
        SteadyState {doc /* Take value before simulation ends */}
    }
    
    private import VectorValues::NumericalVectorValue;
    private import ControlFunctions::maximize;
    private import ControlFunctions::minimize;
    private import SequenceFunctions::last;

    attribute def ExtractedValue {
        doc /*Main container for value extracted from simulation result series*/
        attribute resultSeries: ScalarValues::ScalarValue;  // issue with kernel function definition should be VectorValues::NumericalVectorValues
        attribute value: ScalarValues::ScalarValue;  // issue with kernel function definition, should be ScalarValues::Real
    }
    attribute def maxValue :> ExtractedValue {
        doc /*Max value extracted from result series*/
        :>> value = maximize(resultSeries);
    }
    attribute def minValue :> ExtractedValue {
        doc /*Max value extracted from result series*/
        :>> value = minimize(resultSeries);
    }
    attribute def SteadyState :> ExtractedValue {
        doc /*Max value extracted from result series*/
        :>> value = last(resultSeries);
    }

    // Simulation elements

    abstract part def MBDContainer {
        doc /*MBD container decomposition (reusable abstract base definition for MBD modular unit of structure)*/

        metadata executableMetadata: ExecutableModelMetadata;

        abstract part components: SimulationComponent[0..*] :> subparts;
        abstract ref action behaviors: MBDBehavior[0..*] :> performedActions;

        attribute exposedParameters: MBDParameter[0..*] :> mbdParameters {
            doc /*Exposed parameters (a data value that is constant during the simulation and is provided by the environment and cannot be used in connections)*/
        }
        attribute exposedVariables: MBDVariable[0..*] :> mbdVariables {
            doc /*Exposed variables that are calculated from other variables or are continuous-time states.*/
        }

        item assets: MBDAsset[0..*] {
            doc /* Reference to a resource or an artifact that is created, used, or managed during the development process to drive behavioral modeling. */
        }
    }

    part def SimulationArchitecture :> MBDContainer {
        doc /*MBD architecture top-level model referencing and refining a corresponding system architecture model(s)*/
        ref part systemArchitecture: Architecture[1..*];
    }

    part def SimulationComponent :> MBDContainer {
        doc /*MBD simulation component (reusable modular unit of structure) referencing and refining a corresponding system architecture component(s)*/
        ref part systemArchitectureComponent[1..*];
    }

    action def MBDBehavior {
        doc /*Base definition of executable behavioral model (e.g. an equation, function, or executable code) referencing a context of a corresponding system architecture behavior*/
        ref part systemArchitectureComponent[0..*];

        // metadata behavioralModelMetadata: BehavioralModelMetadata;

        protected attribute parameters: MBDParameter[0..*] :> mbdParameters {
            doc /*Independent parameters (a data value that is constant during the simulation and is provided by the environment and cannot be used in connections)*/
        }
        protected attribute variables: MBDVariable[0..*] :> mbdVariables {
            doc /*Local variable that is calculated from other variables or is a continuous-time state. It is not allowed to use the variable value in another model.*/
        }
    }

    // Currently it is not really possible to create a new attribute def,
    // because then literal values will not inherit from this attribute def and an incompatible data error will be thrown by Syside

    // attribute def MBDParameter;
    alias MBDParameter for Base::DataValue;
    attribute mbdParameters : MBDParameter[*];
    // attribute def MBDVariable;
    alias MBDVariable for Base::DataValue;
    attribute mbdVariables: MBDVariable[*];

    item def MBDAsset {
        doc /*MBD asset refers to any resource or artifact that is created, used, or managed during the development process to support behavioral modeling.
            These assets are essential for designing, implementing, verifying, and documenting the system. */
        attribute type: MBDAssetType[1] default MBDAssetType::Document;
        attribute uri: ScalarValues::String[0..1];
    }

    enum def MBDAssetType {
        Document;
        Specification;
        UseCaseSpecification;
        RequirementsSpecification;
        DesignSpecification;
        ConstraintsSpecification;
        SystemModel;
        BehavioralModel;
        CADModel;
        ExecutableCode;
        TestCase;
        Documentation;
        Diagram;
        SimulationData;
    }

    // Simulation 

    item def AnalysisScenario {
        doc /**/
    }
    item def SimulationResults {
        doc /**/
    }
    analysis def SimulationRun {
        doc /**/
        subject mbdSubject: MBDContainer;
        in configuration: ExecutionConfiguration;
        in scenario: AnalysisScenario;

        return results: SimulationResults;
    }

    // External links

    action def FMUBehavior :> MBDBehavior {
        doc /*Specialization of general MBD behavior in terms of FMI standard*/
        item fmiDescription: 'FMIv2.0.5'::fmiModelDescription;
    }
    abstract ref action fmuBehaviors: FMUBehavior[*];

    // The 'FMIv2.0.5' package (FMU model description schema) lives in FMI.sysml
    // and is re-exported here through the public import above.

    // Semantic metadata

    package MBDSemanticMetadata {
        doc /*Domain-specific Semantic Metadata definitions (DSM)*/

        part simulationArchitectures: SimulationArchitecture[*];
        metadata def <mbd_architecture> SimulationArchitectureDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_architecture declares a simulation architecture model*/
            :> annotatedElement: SysML::PartUsage;
            :>> baseType = simulationArchitectures meta SysML::PartUsage;
        }
        metadata def <mbd_component> SimulationComponentDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_component declares a simulation component model*/
            :> annotatedElement: SysML::PartDefinition;
            :> annotatedElement: SysML::PartUsage;
            :>> baseType = MBDContainer::components meta SysML::PartUsage;
        }
        metadata def <mbd_behavior> SimulationBehaviorDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_behavior declares a simulation behavior (a function, equation, or executable code)*/
            :> annotatedElement: SysML::ActionUsage;
            :>> baseType = MBDContainer::behaviors meta SysML::ActionUsage;
        }
        metadata def <fmu_behavior> FMUBehaviorDSM :> Metaobjects::SemanticMetadata {
            doc /*#fmu_behavior declares a FMU behavior (FMI metadata)*/
            :> annotatedElement: SysML::ActionUsage;
            :>> baseType = fmuBehaviors meta SysML::ActionUsage;
        }
        metadata def <mbd_parameter> MBDParameterDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_parameter declares independent parameters (a data value that is constant during the simulation and is provided by the environment and cannot be used in connections)*/
            :> annotatedElement: SysML::AttributeUsage;
            :>> baseType = mbdParameters meta SysML::AttributeUsage;
        }
        metadata def <mbd_variable> MBDVariableDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_variable declares local variables*/
            :> annotatedElement: SysML::AttributeUsage;
            :>> baseType = mbdVariables meta SysML::AttributeUsage;
        }
        metadata def <mbd_exposed_parameter> MBDExposedParameterDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_exposed_parameter declares exposed parameters in structural model elements*/
            :> annotatedElement: SysML::AttributeUsage;
            :>> baseType = MBDContainer::exposedParameters meta SysML::AttributeUsage;
        }
        metadata def <mbd_exposed_variable> MBDExposedVariableDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_exposed_variable declares exposed variables in structural model elements*/
            :> annotatedElement: SysML::AttributeUsage;
            :>> baseType = MBDContainer::exposedVariables meta SysML::AttributeUsage;
        }
        metadata def <mbd_asset> MBDAssetDSM :> Metaobjects::SemanticMetadata {
            doc /*#mbd_asset declares MBD asset references in structural model elements*/
            :> annotatedElement: SysML::ItemUsage;
            :>> baseType = MBDContainer::assets meta SysML::ItemUsage;
        }
    }

}