---
title: Model Usage
layout: page
parent: Simulation Setup
nav_order: 3
---

# Model Usage
{: .no_toc }
Models are the building blocks of simulations in SADYCOS.
Each model describes a specific part of the satellite system or of its environment.
The `Core` directory contains a collection of models in the `ModelsLibrary` folder which can be used to build a simulation.
The user can also create custom models in the `UserFiles/Models` directory.
This page explains what models are and how to use them in a simulation.

## Page Contents
{: .no_toc .text-delta }
- TOC
{:toc}

## Abstract Superclass
All models are implemented as MATLAB classes.
To enforce a consistent interface, all models must inherit from the abstract superclass `ModelBase` provided in the directory `Core/Utilities`.

All subclasses must implement a static method `execute` that performs the actual run-time calculations of the model.
If a model is meant to simulate the behavior of a dynamic system with states, only the static functions $$f$$ and $$h$$ must be implemented in the model (see [Modelling Dynamic Systems]({% link content/background/dynamic_systems.md %})).
The states update is achieved by adding the output of $$f$$ to the corresponding output of the subsystem function which is then passed to the integrator/delay block in the Simulink model.
The updated states are then automatically fed back into the MATLAB function block in the next call.

## Configuration
The superclass also defines two properties `Parameters` and `Settings` and a constructor that initializes them.
The first property `Parameters` is a structure that is later passed as the last argument to the model's `execute` method.
So, it can be used to store all the constant parameters that the model needs during the simulation.

It is possible that some models need to alter the general settings of the Simulink simulation itself in order to be included.
These settings can be set programmatically by calling the `setModelParameter` method of MATLAB's `Simulink.SimulationInput` class.
Said method expects a name and a value of the parameter to be set.
This is what the second property `Setup` is for.
It is an array of objects of the utility class `SimulinkModelSetting` (also provided in the `Core/Utilities` directory) which has the properties `name` and `value` which are read then used to set the corresponding parameter before a simulation.

The values of the `Parameters` and `Settings` properties are set by the user by instantiating the model classes in the configuration class' static method `configureParameters`. This is explained in more detail in the [Parameter Configuration]({% link content/setup/parameters.md %}) page.

## Usage
Using a model in a simulation is as simple as calling its static method `execute` in the subsystem functions. 
See [Subsystem Functions]({% link content/setup/subsystem_functions.md %}) for an example implementation of such a subsystem function.