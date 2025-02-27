function [udp_data_vector, LogSendSimData] ...
            = sendSimData(LogSendSimData, ...
                            simulation_time__s, ...
                            LogEnvironment, ...
                            LogSensors, ...
                            LogActuators, ...
                            LogPlantDynamics, ...
                            LogPlantOutput,...
                            LogGncAlgorithms, ...
                            Parameters)

udp_data_vector = [simulation_time__s; ...
                    LogPlantOutput.PlantOutputs.RigidBody.position_BI_I__m;...
                    LogPlantOutput.PlantOutputs.RigidBody.velocity_BI_I__m_per_s];

%% Log relevant data
LogSendSimData.udp_data_vector = udp_data_vector;

end