---
title: Logging Data
layout: page
parent: Workflows
nav_order: 3
---

# Logging Data
{: .no_toc }
The purpose of SADYCOS simulations is to generate data that can be analyzed to understand the behavior of the system.
This page describes how data can be logged during a simulation and how to access it.

## Page Contents
{: .no_toc .text-delta }

- TOC
{:toc}

## Logging in SADYCOS
Data logging in SADYCOS is done with Simulink's logging functionality for signals which means that all data of a signal that was marked for logging will be made available as a `timeseries` object.
When the simulation has finished, the property `simulation_outputs` of the configuration class instantiation will be a `Simulink.SimulationOutput` object that contains all corresponding `timeseries` objects.

SADYCOS does not log any of the signals that are used for data transfer between the subsystems.
Instead, every subsystem has a dedicated output (e.g. `LogEnvironment` for the `Environment` subsystem) that is piped through `Goto` and `From` blocks to the top-level `Periphery` subsystem where they are marked for logging.
This gives the user the ability to decide which data should be logged and to make the trade-off between memory usage and data availability.

## Add Data to Logging Signals
Adding new data to the logging signals requires two steps:
1. Add the data to the subsystem's logging output
2. Adjust the corresponding bus definition

### Add Data to Logging Output
Each subsystem function has a dedicated output that is mapped to the corresponding block's logging port.
Adding data to it is done by assigning values to the structure's fields.

E.g., the following code block shows an excerpt from the subsystem function `gncAlgorithms` of the configuration class `DefaultConfiguration` within the `ExampleMission` namespace.

```matlab
LogGncAlgorithms.ActuatorsCommands = ActuatorsCommands;
LogGncAlgorithms.GncAlgorithmsStates = GncAlgorithmsStates;
LogGncAlgorithms.GncAlgorithmsStatesUpdateInput = GncAlgorithmsStatesUpdateInput;
LogGncAlgorithms.reference_frame_attitude_quaternion_RI = reference_frame_attitude_quaternion_RI;
LogGncAlgorithms.reference_angular_velocity_RI_B__rad_per_s = reference_angular_velocity_RI_B__rad_per_s;
LogGncAlgorithms.error_quaternion_RB = error_quaternion_RB;
LogGncAlgorithms.angular_velocity_error_RB_B = angular_velocity_error_RB_B;
```

In this example, the logging output contains the inputs to the subsystem function (`GncAlgorithmsStates`), outputs of the subsystem function (`ActuatorsCommands`, `GncAlgorithmsStatesUpdateInput`) and intermediate variables that were used during the computation and aid in debugging (`reference_frame_attitude_quaternion_RI`, `reference_angular_velocity_RI_B__rad_per_s`, `error_quaternion_RB`, `angular_velocity_error_RB_B`).

### Adjust Bus Definition
As described in [Buses Configuration]({% link content/setup/buses.md %}), there must be a bus object containing the format definition for every Simulink bus signal.
The log signals are no exception.
After adding new data to the logging output, the new elements must be added to the corresponding bus object in the configuration class' static method `configureBuses.m`.
The section  of the above example for the `LogGncAlgorithms` bus object in the `configureBuses.m` file would look like this:

```matlab
%% LogGncAlgorithms

% Top-Level Bus

elems = [simpleBusElement('ActuatorsCommands', 1, 'Bus: ActuatorsCommands'), ...
            simpleBusElement('GncAlgorithmsStates', 1, 'Bus: GncAlgorithmsStates'), ...
            simpleBusElement('GncAlgorithmsStatesUpdateInput', 1, 'Bus: GncAlgorithmsStates'), ...
            simpleBusElement('reference_frame_attitude_quaternion_RI', 4, 'double'), ...
            simpleBusElement('reference_angular_velocity_RI_B__rad_per_s', 3, 'double'), ...
            simpleBusElement('error_quaternion_RB', 4, 'double'), ...
            simpleBusElement('angular_velocity_error_RB_B', 3, 'double')];

busesInfoCreator.setBusByElements('LogGncAlgorithms', elems);
```

First, an array of bus elements is created using the utility method `simpleBusElement` by providing the name, dimension, and data type of the element.
Then, the bus object is created by calling the `setBusByElements` method of the `busesInfoCreator` object with the name of the bus object and the array of bus elements.