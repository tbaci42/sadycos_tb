function [stop_criterion, LogStopCriterion] ...
            = stopCriterion(LogStopCriterion, ...
                                simulation_time__s, ...
                                LogEnvironment, ...
                                LogSensors, ...
                                LogActuators, ...
                                LogPlantDynamics, ...
                                LogPlantOutput,...
                                LogGncAlgorithms, ...
                                Parameters)

% Angle between body-fixed z axis and inertial z axis
body_z__I = smu.unitQuat.att.transformVector(LogPlantOutput.PlantOutputs.RigidBody.attitude_quaternion_BI, ...
                        [0;0;1]);
angle = acos(dot(body_z__I, [0;0;1]));

stop_criterion = (angle > deg2rad(30));

%% Log relevant data
LogStopCriterion.stop_criterion = stop_criterion;

end