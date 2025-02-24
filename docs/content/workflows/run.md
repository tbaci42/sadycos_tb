---
title: Running Simulations
layout: page
parent: Workflows
nav_order: 2
---

# Running Simulations
{: .no_toc }
Running simulations is the core functionality of SADYCOS.
This page explains how this is done after a configuration class has been created (see [Creating Configuration Classes]({% link content/workflows/create_configuration_class.md %})).

## Page Contents
{: .no_toc .text-delta }
- TOC
{:toc}

## Default Simulation Execution
Given a configuration class `MyNewConfiguration`, running the simulation is as simple as calling the `run` method of an instance of the configuration class.

```matlab
o = MyNewConfiguration;
o.run;
```

SADYCOS will display the progress of the individual steps of these two commands.
The simulation will run in the background and an output to the command line will indicate that the simulation has finished.

If the configuration class is set up to run multiple similar simulations, the above commands will run all of them in sequence.

## Simultaneous Simulation Execution
On machines with multi-core processors, you can run multiple simulations simultaneously using MATLAB's Parallel Computing Toolbox.
A configuration class that is set up to run multiple similar simulations can be run in parallel by calling the `run` method with the `use_parsim` option set to `true`.

```matlab
o = MyNewConfiguration;
o.run(use_parsim = true);
```

This requires some overhead for setting up the parallel pool and launching the _Simulation Manager_ but then just requires a single compilation of the Simulink model and runs the simulations in parallel.