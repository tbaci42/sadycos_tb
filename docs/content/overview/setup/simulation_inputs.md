---
title: Simulation Input Configuration
layout: page
parent: Simulation Setup
nav_order: 6
---

# Simulation Input Configuration
{: .no_toc }
The creation of `Simulink.SimulationInput` objects is the whole purpose of the [Parameter]({% link content/overview/setup/parameters.md %}) and [Buses Configuration]({% link content/overview/setup/buses.md %}).
These objects encapsulate all information necessary to execute a simulation, including the general settings of the Simulink model, the parameters used in the subsystem functions, the `Simulink.Bus` objects, and the `BusesTemplates` structure.
This page gives a quick overview of how these objects are created in SADYCOS.  

## Page Contents
{: .no_toc .text-delta }
- TOC
{:toc}

## Process
The third static method that the configuration class' constructor calls after `configureParameters` and `configureBuses` is `configureSimulationInputs`.
Its purpose is to take the outputs of the previous methods and use those to prepare `Simulink.SimulationInput` objects that can easily be used to run a simulation using MATLAB's `sim` function.
In contrast to the other two, this method is not abstract but already has a default implementation in the `SimulationConfiguration` superclass.
All it does is call another method `createSimulationInputs` which is responsible for turning the parameter cell array and `BusesInfo` array into an array of `Simulink.SimulationInput` objects.

In general, the user should never need to directly alter the `Simulink.SimulationInput` objects.
All configuration can be done by creating different parameters and buses in the `configureParameters` and `configureBuses` methods.
If for some reason it is desired to directly change the `Simulink.SimulationInput` objects, the user can only do so by overriding the `configureSimulationInputs` method in their configuration class.

## Simulation Input Creation
After creating an array of `Simulink.SimulationInput` objects according to the number of elements the `parameters_cells` array, the `createSimulationInputs` method carries out these three tasks for each object:
1. Apply the general settings of the Simulink model to the `Simulink.SimulationInput` object.
2. Remove the field `Settings` for the general settings from the `Parameters` structure.
3. Store the remaining `Parameters` structure, the `BusTemplates` structure, and the `Simulink.Bus` objects in the `Simulink.SimulationInput` object.