---
title: Configuration Classes
layout: page
parent: Simulation Setup
nav_order: 1
---

# Configuration Classes
{: .no_toc }
Everything that is necessary to set up and run a simulation in SADYCOS is defined in configuration classes.
These classes should be located under `UserFiles/Configurations`.
Initially, this folder contains a namespace `ExampleMission` with two classes `DefaultConfiguration` and `GainSearch` which serve as examples for how to set up own configuration classes.
All configuration classes must inherit from the abstract superclass `SimulationConfiguration` that is provided by in the `Core` folder.
This class already provides the standard interface methods that users can utilize for configuring and executing simulations.

## Page Contents
{: .no_toc .text-delta }
- TOC
{:toc}

## Definition
### Subsystem Functions
The abstract superclass `SimulinkConfiguration` forces its subclasses to implement the functions that are called from the MATLAB function blocks of the Simulink model as static methods.
This is explained in more detail on the page [Subsystem Functions]({% link content/setup/subsystem_functions.md %}).

### Parameter Configuration
Before the simulation can be started, the general properties of the Simulink model as well as parameters of the models used within the subsystem functions must be configured by the user.
For this, the superclass forces subclasses to implement the static method `configureParameters` which is supposed to output a cell array of parameter structures that are used during the preparation and execution of the simulation. The page [Parameter Configuration]({% link content/setup/parameters.md %}) explains this in more detail.

### Buses Configuration
Lastly, the superclass enforces implementation of the static method `configureBuses`.
The subsystem functions will generally output data in the form of structures.
Simulink is not able to infer the bus objects from these structures during model preparation automatically.
Thus, the user must specify a bus object for every signal of the Simulink model.
The page [Buses Configuration]({% link content/setup/buses.md %}) explains this in more detail.

### Simulation Input Configuration
The outputs of the `configureParameters` and `configureBuses` methods are used within another static method `configureSimulationInputs` to create objects of the MATLAB's `Simulink.SimulationInput` class.
Those objects contain all necessary information to run a simulation.
The method `configureSimulationInputs` already has a default implementation in the superclass but can be overridden by the user if necessary.
The details are explained on the page [Simulation Input Configuration]({% link content/setup/simulation_inputs.md %}).

### Additional Methods
Besides these mandatory methods, the user can implement additional ones in the configuration classes.
For example, the `DefaultConfiguration` class of the `ExampleMission` namespace contains a method `replayPositionAndAttitude` which can be called after a simulation to visualize the position and attitude of the satellite over time using MATLAB's satellite scenario functionality.

## Usage
After creating a new configuration class, running the simulation is as simple as instantiating the class and calling its `run` method.
```matlab
o = ExampleMission.DefaultConfiguration;
o.run;
```

Under the hood, the constructor of the class calls the methods `configureParameters`, `configureBuses`, and `configureSimulationInputs` and saves the `Simulink.SimulationInput` objects as properties of the configuration class object `o`.

The `run` method then only calls MATLAB's `sim` function with the `Simulink.SimulationInput` objects as input arguments.
If the user specified multiple parameter structures, the run method can also be configured to use the function `parsim` from MATLAB's Parallel Computing Toolbox to run simulations in parallel.