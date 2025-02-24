---
title: Analyzing Simulation Results
layout: page
parent: Workflows
nav_order: 4
---

# Analyzing Simulation Results
{: .no_toc }
Data generated and logged (see [Logging Data]({% link content/workflows/logging.md %})) during a SADYCOS simulation are made available to the user for further analysis.
As of now, SADYCOS does not provide any new tools for data analysis but enables the user to utilize MATLAB's and Simulink's built-in capabilities.

## Page Contents
{: .no_toc .text-delta }

- TOC
{:toc}

## During Simulation
Simulink provides the _Simulation Data Inspector_ to visualize signals marked for logging in real time during a simulation.
It can be opened either by executing the following command in MATLAB's command window before starting the simulation:
```matlab
Simulink.sdi.view;
```

or by clicking the _Simulation Data Inspector_ button in the Simulink toolstrip.
The latter option is also available after a simulation has been started.

## After Simulation
After the simulation has finished, the logged data is available in the property `simulation_outputs` of the configuration class instantiation as a `Simulink.SimulationOutput` object (or an array of those for multiple simulations).
If `o` is such an instantiation and its `run` method has already been called, then the following command returns the logged data of the `GNC Algorithms` subsystem and opens the Simulation Data Inspector for visualization:
```matlab
logGnc = getElement(o.simulation_outputs.logsout, "LogGncAlgorithms");
logGnc.plot;
```

The outputs also allow for further analysis and manipulation.
E.g., the `GNC Algorithms` subsystem function of the configuration class `DefaultConfiguration` within the `ExampleMission` namespace logs the error of the angular velocity vector.
Its norm can be calculated and plotted with the following code:
```matlab
logGnc = getElement(o.simulation_outputs.logsout, "LogGncAlgorithms");
errorNorm = vecnorm(logGnc.Values.angular_velocity_error_RB_B.Data, 2, 2);
figure;
plot(logGnc.Values.angular_velocity_error_RB_B.Time, errorNorm);
xlabel("Time [s]");
ylabel("Error Norm [rad/s]");
title("Error Norm of Angular Velocity Vector");
```