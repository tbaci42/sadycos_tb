function BusesInfo = configureBuses(parameters_cells)

%% Use helper class
import BusesInfoCreator.simpleBusElement

%% Create BusesInfoCreator Object
busesInfoCreator = BusesInfoCreator(parameters_cells{1});

%% EnvironmentStates
% none -> bus with dummy element
elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements("EnvironmentStates", elems);

%% EnvironmentConditions

% Nested Buses

% Earth Atmosphere
elems = [simpleBusElement('mass_density__kg_per_m3', 1), ...
            simpleBusElement('number_density__1_per_m3', 1), ...
            simpleBusElement('temperature__K', 1)];

busesInfoCreator.setBusByElements('EarthAtmosphere', elems);

% Top-Level Bus

elems = [simpleBusElement('EarthAtmosphere', 1, 'Bus: EarthAtmosphere')];

busesInfoCreator.setBusByElements('EnvironmentConditions', elems);

%% LogEnvironment

% Top-Level Bus

elems = [simpleBusElement('EnvironmentConditions', 1, 'Bus: EnvironmentConditions'), ...
            simpleBusElement('EnvironmentStatesDerivatives', 1, 'Bus: EnvironmentStates'), ...
            simpleBusElement('EnvironmentStates', 1, 'Bus: EnvironmentStates')];

busesInfoCreator.setBusByElements('LogEnvironment', elems);

%% PlantStates

% Nested Buses

% Rigid Body
elems = [simpleBusElement('attitude_quaternion_BI', 4), ...
            simpleBusElement('angular_velocity_BI_B__rad_per_s', 3)];

busesInfoCreator.setBusByElements('RigidBodyStates', elems);

% Top-Level Bus

elems = [simpleBusElement('RigidBody', 1, 'Bus: RigidBodyStates')];

busesInfoCreator.setBusByElements('PlantStates', elems);

%% PlantFeedthrough

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('PlantFeedthrough', elems);

%% LogPlantDynamics

% Nested Buses

% Forces
elems = [simpleBusElement('aerodynamic_force_B__N', 3)];

busesInfoCreator.setBusByElements('Forces', elems);

% Torques
elems = [simpleBusElement('aerodynamic_torque_B__Nm', 3)];

busesInfoCreator.setBusByElements('Torques', elems);

% Top-Level Bus

elems = [simpleBusElement('PlantStatesDerivatives', 1, 'Bus: PlantStates'), ...
            simpleBusElement('PlantStates', 1, 'Bus: PlantStates'), ...
            simpleBusElement('Forces', 1, 'Bus: Forces'), ...
            simpleBusElement('Torques', 1, 'Bus: Torques')];

busesInfoCreator.setBusByElements('LogPlantDynamics', elems);

%% PlantOutputs

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('PlantOutputs', elems);

%% LogPlantOutput

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('LogPlantOutput', elems);

%% SensorsStates
% none -> bus with dummy element
elems = [simpleBusElement('dummy', 1, 'double')];

busesInfoCreator.setBusByElements("SensorsStates", elems);

%% SensorsOutputs

% Nested Buses

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('SensorsOutputs', elems);

%% LogSensors

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('LogSensors', elems);

%% GncAlgorithmsStates
% none -> bus with dummy element
elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements("GncAlgorithmsStates", elems);

%% ActuatorsCommands

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('ActuatorsCommands', elems);

%% LogGncAlgorithms

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('LogGncAlgorithms', elems);

%% ActuatorsStates
% none -> bus with dummy element
elems = [simpleBusElement('dummy', 1, 'double')];

busesInfoCreator.setBusByElements("ActuatorsStates", elems);

%% ActuatorsOutputs

% Top-Level Bus
elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('ActuatorsOutputs', elems);

%% LogActuators

% Top-Level Bus

elems = simpleBusElement('dummy', 1, 'double');

busesInfoCreator.setBusByElements('LogActuators', elems);

%% LogSendSimData

elems = simpleBusElement('udp_data_vector', 7, 'double');

busesInfoCreator.setBusByElements('LogSendSimData', elems);

%% LogStopCriterion

elems = simpleBusElement('stop_criterion', 1, 'boolean');

busesInfoCreator.setBusByElements('LogStopCriterion', elems);

%% Get Outputs
BusesInfo = busesInfoCreator.getBusesInfo();

end