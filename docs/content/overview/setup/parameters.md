---
title: Parameter Configuration
layout: page
parent: Simulation Setup
nav_order: 4
---

# Parameter Configuration
{: .no_toc }
A simulation in SADYCOS can be customized by the user in two ways:
1. by implementing the desired system behavior in the subsystem functions as explained in the page [Subsystem Functions]({% link content/overview/setup/subsystem_functions.md %}) and
2. by setting constant parameters of the simulation which is the topic of this page.

## Page Contents
{: .no_toc .text-delta }
- TOC
{:toc}

## Parameter Usage
After creating an object of a configuration class, it will have a property called `parameters_cells` which is a cell array of structures which hold parameter values for use during the setup and run of a simulation.
The values of these cell array elements must be set by the user through the output of the configuration class' static method `configureParameters` which is automatically called by the configuration class' constructor.
Afterwards, the `parameter_cells` property is used to configure bus objects explained in the page [Buses Configuration]({% link content/overview/setup/buses.md %}) and to create `Simulink.SimulationInput` objects explained in [Configuring Simulation Inputs]({% link content/overview/setup/simulation_inputs.md %}).

Each element of the cell array will result in an individual `Simulink.SimulationInput` object.
The `run` method of the configuration class will perform a simulation for every one of these objects giving the user the ability to run multiple similar simulations with differing parameters with a single function call.

The parameter structures holds general settings for the Simulink model itself (like the simulation duration) and constant parameters that models can use during the simulation.

## Configuration
A parameter structure must adhere to a certain format for the Simulink model to find the appropriate parameters in the right places.
SADYCOS provides the class `ParameterCreator` in `Core/Utilities` to help the user create these structures.
A good example of how to use this class can be found in the `configureParameters` method of the `DefaultConfiguration` class in the `ExamplesMission` namespace.
Its code can be seen in full by opening the following code block:

{: .code_block }
> <details closed markdown="block">
> <summary>configureParameters.m</summary>
> ```matlab
> function parameters_cells = configureParameters()
> 
> %% General Parameters
> 
> % Simulation Duration
> simulation_duration__s = 1000;
> 
> % Simulation Mode
> simulation_mode = "normal";
> 
> % Pacing
> enable_pacing = false;
> pacing_rate = 1;
> 
> % Send Simulation Data
> enable_send_sim_data = false;
> 
> % Stop Criterion
> enable_stop_criterion = false;
> 
> 
> % Subsystem-Specific Parameters
> 
> % States
> % Plant
> gravitational_parameter_Earth = 3.986004e14;
> 
> InitialPlantStates.RigidBody.position_BI_I__m = [6.771e6;0;0];
> InitialPlantStates.RigidBody.velocity_BI_I__m_per_s = [0;sqrt(gravitational_parameter_Earth/6.771e6);0];
> InitialPlantStates.RigidBody.attitude_quaternion_BI = [1;zeros(3,1)];
> InitialPlantStates.RigidBody.angular_velocity_BI_B__rad_per_s = [0;0;0];
> InitialPlantStates.ReactionWheels.angular_velocities__rad_per_s = 100 * ones(3,1);
> 
> % Sample Times
> % Sensors
> sensors_sample_time_parameter__s = [0.1, 0];
> 
> % GNC Algorithms
> gnc_algorithms_sample_time_parameter__s = [0.1, 0];
> 
> % Delays
> % GNC Algorithms
> gnc_delay = 1;
> InitialActuatorCommands.ReactionWheels.torque_commands__N_m = zeros(3,1);
> 
> % Use helper class to prepare Parameters structure
> parameter_creator = ParameterCreator(InitialPlantStates, ...
>                                     sensors_sample_time_parameter__s = sensors_sample_time_parameter__s, ...
>                                     gnc_algorithms_sample_time_parameter__s = gnc_algorithms_sample_time_parameter__s, ...
>                                     simulation_duration__s = simulation_duration__s, ...
>                                     simulation_mode = simulation_mode, ...
>                                     enable_pacing = enable_pacing, ...
>                                     pacing_rate = pacing_rate, ...
>                                     enable_send_sim_data = enable_send_sim_data, ...
>                                     enable_stop_criterion = enable_stop_criterion);
> 
> parameter_creator.activateDelay("GncAlgorithms", gnc_delay, InitialActuatorCommands);
> 
> %% Model-Specific Parameters
> 
> % Environment Models
> 
> % Common
> mjd0 = mjuliandate('17-July-2024 12:00:00','dd-mmm-yyyy HH:MM:SS');
> 
> % Time
> parameter_creator.addModel("Environment", ModifiedJulianDate(mjd0))
> 
> % Atmosphere
> parameter_creator.addModel("Environment", Nrlmsise00(mjd0, simulation_duration__s, true(24,1), 1e-2));
> 
> % Gravitational Field
> gravitationalField_max_Degree = 3;
> parameter_creator.addModel("Environment", SphericalHarmonicsGeopotential(gravitationalField_max_Degree));
> 
> % Magnetic Field
> magnetic_field_max_degree = 2;
> parameter_creator.addModel("Environment", Igrf(mjd0, simulation_duration__s, magnetic_field_max_degree));
> 
> % Plant Models
> 
> % Mechanics
> mass__kg = 2;
> inertia_B_B__kg_m2 = 1*diag([1,1,1]);
> parameter_creator.addModel("Plant", RigidBodyMechanics(mass__kg, inertia_B_B__kg_m2));
> 
> % Aerodynamics
> % Get absolute path of this file's folder
> [this_folder,~,~] = fileparts(mfilename("fullpath"));
> % Get absolute paths of all obj files
> obj_files = string(fullfile(this_folder, 'obj_files', 'body.obj'));
> rotation_hinge_points_CAD = zeros(3,1);
> 
> rotation_directions_CAD = [1; 0; 0];
> 
> surface_temperatures__K = num2cell(300);
> 
> surface_energy_accommodation_coefficients = num2cell(0.9);
> 
> DCM_B_from_CAD = [0, -1, 0;...
>                     -1, 0, 0; ...
>                     0, 0, -1];
> 
> center_of_mass_CAD = [0; 2; 0];
> 
> parameter_creator.addModel("Plant", SimplifiedVleoAerodynamics(obj_files, ...
>                                                     rotation_hinge_points_CAD, ...
>                                                     rotation_directions_CAD, ...
>                                                     surface_temperatures__K, ...
>                                                     surface_energy_accommodation_coefficients, ...
>                                                     DCM_B_from_CAD, ...
>                                                     center_of_mass_CAD, ...
>                                                     false, ...
>                                                     1));
> 
> % Gravity
> parameter_creator.addModel("Plant", PointMassGravity(mass__kg));
> 
> % Reaction Wheels
> reaction_wheels_spin_directions_B = eye(3);
> reaction_wheels_inertias__kg_m2 = 1E-4 * ones(3,1);
> reaction_wheels_friction_coefficients__N_m_s_per_rad = zeros(3,1);
> reaction_wheels_maximum_frequencies__rad_per_s = 500 * ones(3,1);
> 
> parameter_creator.addModel("Plant", RateLimitedReactionWheels(reaction_wheels_inertias__kg_m2, ...
>                                                                 reaction_wheels_spin_directions_B, ...
>                                                                 reaction_wheels_friction_coefficients__N_m_s_per_rad, ...
>                                                                 reaction_wheels_maximum_frequencies__rad_per_s));
> 
> % Actuator Models
> % Magnetic Torquers
> magnetic_torquers_directions = eye(3);
> magnetic_torquers_max_dipole_moments__A_m2 = 5 * ones(3,1);
> 
> parameter_creator.addModel("Actuators", GenericMagneticTorquers(magnetic_torquers_directions, ...
>                                                                     magnetic_torquers_max_dipole_moments__A_m2));
> 
> % GNC Algorithms Models
> qfr_proportional_gain = 1E-3;
> qfr_derivative_gain = 1E-1;
> 
> parameter_creator.addModel("GncAlgorithms", QuaternionFeedbackControl(qfr_proportional_gain, qfr_derivative_gain));
> 
> %% Get Parameters Structure
> Parameters = parameter_creator.getParameters();
> 
> %% Add Non-Model Parameters
> Parameters.GncAlgorithms.reaction_wheels_spin_directions_B = reaction_wheels_spin_directions_B;
> Parameters.GncAlgorithms.magnetic_torquers_directions_B = magnetic_torquers_directions;
> Parameters.GncAlgorithms.reaction_wheels_desaturation_gain__1_per_s = 1E-2;
> Parameters.GncAlgorithms.reaction_wheels_inertias__kg_m2 = reaction_wheels_inertias__kg_m2;
> 
> %% Write Structure to Cell for Output
> parameters_cells = {Parameters};
> end
> ```
> </details>

Roughly in the middle, an object of the `ParameterCreator` class is created.
The constructor expects a single positional argument for the initial states of the the `Plant` subsystem.
Besides this the user can specify a number of optional arguments for general simulation settings like the simulation duration, simulation mode, pacing, ...
If the user does not specify a value for these optional arguments, a default value will be used.

After the instantiation, the user can further adapt the parameters with methods.
There is `activateDelay` to add delays to the subsystems `Sensors`, `Actuators`, and `GNC Algorithms`.
By default, the subsystems `Environment`, `Sensors`, `Actuators`, and `GNC Algorithms` do not simulate any state dynamics.
This can be changed by calling the method `activateStates` (which is not done in the above example).
Finally, the method `addModel` is used to include parameters specific to models in the parameter structure.
This method expects two arguments: the name of the subsystem in which the parameters should be available during simulation and an object of a model class.

After all these methods are used, the above example calls the method `getParameters` which assembles the parameter structure in the correct format and returns it.
This structure can subsequently be amended with additional parameters that are not specific to a model before packing it into a cell and returning it.