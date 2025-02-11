function [viewer, sc, sat] = replayPositionAndAttitude(obj, index)

arguments
    obj (1,1) ExampleMission.DefaultConfiguration
    index (1,1) {mustBePositive} = 1
end

LogPlantOutput = get(obj.simulation_outputs(index).logsout, "LogPlantOutput");

position_BI_I__m_time_series = LogPlantOutput.Values.PlantOutputs.RigidBody.position_BI_I__m;
attitude_quaternion_BI = LogPlantOutput.Values.PlantOutputs.RigidBody.attitude_quaternion_BI;

sc = satelliteScenario;
sat = satellite(sc, position_BI_I__m_time_series, "CoordinateFrame", "inertial", "Name", "Satellite");
pointAt(sat, attitude_quaternion_BI, "CoordinateFrame", "inertial", "Format", "quaternion", "ExtrapolationMethod", "fixed")
coordinateAxes(sat);
viewer = satelliteScenarioViewer(sc);

end