---
title: Adding New Models
layout: page
parent: Workflows
nav_order: 5
---

# Adding New Models
{: .no_toc }
For the implementation of the system behavior, the user can either rely on the models that SADYCOS provides in the `ModelsLibrary` folder within `Core` or create new models.
This page describes how to add new models to a simulation.

## Page Contents
{: .no_toc .text-delta }

- TOC
{:toc}

## Model Definition
Custom models are meant to be placed in the folder `UserFiles/Models`.
To avoid confusion regarding the model's interface, it is recommended to adhere to the same structure as the models in the `ModelsLibrary` folder, i.e. all models should be implemented as subclasses of the `ModelBase` class provided in `Core/Utilities`.

As an example, we will create a model for equations of motion of a point mass.
For that, a class folder like `@PointMassMechanics` should be created in the `UserFiles/Models` folder.
This folder must contain a class definition file named `PointMassMechanics.m` with the following content:

{: .exp_code_block }
> <details closed markdown="block">
> <summary>PointMassMechanics.m</summary>
> ```matlab
> classdef PointMassMechanics < ModelBase
>     methods (Static)
>         
>         [position_derivative_BI_I__m_per_s, ...
>             velocity_derivative_BI_I__m_per_s2] ...
>             = execute(net_force_I__N, ...
>                         velocity_BI_I__m_per_s, ...
>                         ParametersPointMassMechanics)
>                         
>     end
> 
>     methods (Access = public)
> 
>         function obj = PointMassMechanics(mass__kg)
> 
>         arguments
>             mass__kg (1,1) {mustBePositive}
>         end
> 
>             Parameters.mass__kg = mass__kg;
>             obj = obj@ModelBase("Parameters", Parameters);
> 
>         end
> 
>     end
> end
> ```
> </details>

The first line of the class definition specifies that the class `PointMassMechanics` inherits from the `ModelBase` superclass.
Our example model makes do with two methods.
The constructor is implemented directly in the class definition file and sets the model parameters.
The static method `execute`, whose signature is shown in the above code block, is required by the superclass.
Its implementation will be outsourced into an own file named `execute.m` in the same folder.
After creating such a file, its content should look like this:

{: .exp_code_block }
> <details closed markdown="block">
> <summary>execute.m</summary>
> ```matlab
> function [position_derivative_BI_I__m_per_s, ...
>           velocity_derivative_BI_I__m_per_s2] ...
>           = execute(net_force_I__N, ...
>                     velocity_BI_I__m_per_s, ...
>                     ParametersPointMassMechanics)
>
>     position_derivative_BI_I__m_per_s = velocity_BI_I__m_per_s;
>     velocity_derivative_BI_I__m_per_s2 = net_force_I__N / ParametersPointMassMechanics.mass__kg;
>
> end
> ```
> </details>

## Model Usage
To use the newly created model in a simulation, it must be called from a subsystem function.
Being a model for equations of motion, the `PointMassMechanics` model is best executed within the `PlantDynamics` subsystem function.

Three things must be done to integrate the model here:
1. Specify the constant model parameters.
2. Call the model in the subsystem function.
3. Adjust affected bus definitions.

### Parameter Configuration
Within the static method `configureParameters` of the configuration class, the new model must be instantiated and added to the correct list of models in the `ParameterCreator` object.
This is achieved with the following line of code:
```matlab
parameter_creator.addModel("Plant", PointMassMechanics(17));
```

The call to the constructor `PointMassMechanics(17)` creates an instance of the `PointMassMechanics` model with a mass of 17 kg.
The page [Parameter Configuration]({% link content/setup/parameters.md %}) provides more information on how parameter configuration works.

### Model Call
The static method `plantDynamics` of the configuration class is the subsystem function that contains the model calls.
After the necessary inputs to our model have been prepared, the model can be called with the following code snippet:
```matlab
[position_derivative_BI_I__m_per_s, ...
    velocity_derivative_BI_I__m_per_s2] ...
    = execute(net_force_I__N, ...
                velocity_BI_I__m_per_s, ...
                ParametersPlant.PointMassMechanics)
```

This particular model provides derivatives for the current position and velocity.
These need to be added to the output `PlantStatesDerivatives` to be routed through an integrator block.
```matlab
PlantStatesDerivatives.position_BI_I_m = position_derivative_BI_I__m_per_s;
PlantStatesDerivatives.velocity_BI_I_m_per_s = velocity_derivative_BI_I__m_per_s2;
```

Variables associated with the model can be added to other outputs as well like `LogPlantDynamics` for logging purposes.

The page [Subsystem Functions]({% link content/setup/subsystem_functions.md %}) provides more information on how subsystem functions work.

### Bus Definition
The bus objects corresponding to subsystem function outputs that are affected by the new model must be adjusted in the static method `configureBuses` of the configuration class.
The bus object `PlantStates` is used for both the input with the same name and the output `PlantStateDerivatives` of the `PlantDynamics` subsystem function.
To enable the call to the new model as implemented above, the `elems` variable used in the call
```matlab
busesInfoCreator.setBusByElements('PlantStates', elems);
```
must be extended by the new fields.

A more detailed description of how to adjust bus definitions can be found in the page [Buses Configuration]({% link content/setup/buses.md %}).