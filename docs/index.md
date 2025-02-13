---
title: Home
layout: home
nav_order: 1
---

# Welcome to the SADYCOS Documentation!

SADYCOS is a simulation environment for satellite dynamics and control algorithms implemented in MATLAB Simulink.
It features a structure that allows for a highly customizable creation and execution of satellite simulations.
A constantly expanding library of models is provided to enable the user to quickly set up new simulations.
By implementing custom models and controllers, the user is in charge of making an own trade-off between simulation speed and level of detail.

## Advantages of SADYCOS:
### Fully Customizable
The Simulink model only provides a general structure for the simulation with subsystems for the environment, actuators, sensors, plant and algorithms.
The user is responsible for implementing the entire functionality of these subsystems. 
For that, the user can rely on the provided library of models or integrate own models.
Thus, the user can decide where to implement a simplified model for the sake of simulation speed and where to use a higher fidelity model for a more detailed analysis.

### Fast
While the simple MATLAB scripting syntax allows for a quick and easy implementation of custom functionality, Simulink's code generation transpiles the model into C code for faster execution.
The structure of SADYCOS and the provided models ensure that code generation is possible for the entire simulation.

### Parallel
Parameter studies, gain optimization or Monte Carlo simulations necessitate a large number of simulations.
SADYCOS allows for the usage of MATLAB's Parallel Computing Toolbox, which enables multiple simulations to be run in parallel on a multi-core machine.

### Trackable
Even though the core of the simulation is implemented in the binary Simulink file, the entire functionality is implemented in text-based m-files.
The user can rely on powerful version control systems optimized for text-based files like Git to track changes in the code and collaborate with other users.
