function [PlantOutputs, ...
            LogPlantOutput] ...
            = plantOutput(PlantOutputs, ...
                            LogPlantOutput, ...
                            PlantStates, ...
                            ParametersPlant)

%% Abbreviations
q = PlantStates.RigidBody.attitude_quaternion_BI;

%% Set Output
% output all states
PlantOutputs = PlantStates;

% Normalize quaternion
q = q / norm(q);
PlantOutputs.RigidBody.attitude_quaternion_BI = q;

%% Log relevant data
LogPlantOutput.PlantOutputs = PlantOutputs;