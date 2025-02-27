function parameters_cells = configureParameters()

%% General Parameters

% Simulation Duration
simulation_duration__s = 1000;

% Simulation Mode
simulation_mode = "normal";

% Pacing
enable_pacing = false;
pacing_rate = 1;

% Send Simulation Data
enable_send_sim_data = false;

% Stop Criterion
enable_stop_criterion = false;


% Subsystem-Specific Parameters

% States
% Plant
InitialPlantStates.RigidBody.attitude_quaternion_BI = [1;zeros(3,1)];
InitialPlantStates.RigidBody.angular_velocity_BI_B__rad_per_s = [0;0;0];

% Sample Times
% Sensors
sensors_sample_time_parameter__s = [0, 0];

% GNC Algorithms
gnc_algorithms_sample_time_parameter__s = [0, 0];

% Delays
% GNC Algorithms
gnc_delay = 1;
InitialActuatorCommands.dummy = 0;

% Use helper class to prepare Parameters structure
parameter_creator = ParameterCreator(InitialPlantStates, ...
                                    sensors_sample_time_parameter__s = sensors_sample_time_parameter__s, ...
                                    gnc_algorithms_sample_time_parameter__s = gnc_algorithms_sample_time_parameter__s, ...
                                    simulation_duration__s = simulation_duration__s, ...
                                    simulation_mode = simulation_mode, ...
                                    enable_pacing = enable_pacing, ...
                                    pacing_rate = pacing_rate, ...
                                    enable_send_sim_data = enable_send_sim_data, ...
                                    enable_stop_criterion = enable_stop_criterion);

parameter_creator.activateDelay("GncAlgorithms", gnc_delay, InitialActuatorCommands);

%% Model-Specific Parameters

% Environment Models

% Common
mjd0 = smu.time.modifiedJulianDateFromCalDat(2025, 02, 25.5);

% Atmosphere
parameter_creator.addModel("Environment", Nrlmsise00(mjd0, simulation_duration__s, true(24,1), 1e-2));

% Plant Models

% Mechanics
mass__kg = 2;
inertia_B_B__kg_m2 = 1*diag([1,1,1]);
parameter_creator.addModel("Plant", RigidBodyMechanics(mass__kg, inertia_B_B__kg_m2));

% Aerodynamics
% Get absolute path of this file's folder
[this_folder,~,~] = fileparts(mfilename("fullpath"));
% Get absolute paths of all obj files
obj_files = string(fullfile(this_folder, 'obj_files', 'Feather.obj'));
rotation_hinge_points_CAD = zeros(3,1);

rotation_directions_CAD = [1; 0; 0];

surface_temperatures__K = num2cell(300);

surface_energy_accommodation_coefficients = num2cell(0.9);

DCM_B_from_CAD = [1, 0, 0;...
                    0, -1, 0; ...
                    0, 0, -1];

center_of_mass_CAD = [-0.15; 0; 0];

parameter_creator.addModel("Plant", SimplifiedVleoAerodynamics(obj_files, ...
                                                    rotation_hinge_points_CAD, ...
                                                    rotation_directions_CAD, ...
                                                    surface_temperatures__K, ...
                                                    surface_energy_accommodation_coefficients, ...
                                                    DCM_B_from_CAD, ...
                                                    center_of_mass_CAD, ...
                                                    false, ...
                                                    1));
% Actuator Models

% GNC Algorithms Models

%% Get Parameters Structure
Parameters = parameter_creator.getParameters();

%% Add Non-Model Parameters

%% Write Structure to Cell for Output
parameters_cells = {Parameters};
end