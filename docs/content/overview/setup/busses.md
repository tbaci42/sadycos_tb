---
title: Busses Configuration
layout: page
parent: Simulation Setup
nav_order: 5
---

# Busses Configuration
{: .no_toc }
The subsystem functions called in the Simulink model generally output variables of MATLAB's `struct` type.
The corresponding type of signal that Simulink uses to route the data between subsystems is called _bus_.
Since the user can freely define what data to write into the output structures of the subsystem functions, the busses can be different for every simulation.
Simulink unfortunately cannot automatically infer the necessary format of a bus from the MATLAB function block.
That is why the user has to manually provide objects of the MATLAB's class `Simulink.Bus` for every bus signal within the simulink model.
Those busses are:
- `EnvironmentConditions`
- `EnvironmentStates`
- `PlantOutputs`
- `PlantFeedthrough`
- `PlantStates`
- `SensorsOutputs`
- `SensorsStates`
- `ActuatorsOutputs`
- `ActuatorsStates`
- `GncAlgorithmsStates`
- `ActuatorsCommands`
- `LogEnvironment`
- `LogSensors`
- `LogActuators`
- `LogPlantDynamics`
- `LogPlantOutput`
- `LogGncAlgorithms`

## Table of contents
{: .no_toc .text-delta }
- TOC
{:toc}

