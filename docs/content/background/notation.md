---
title: Notation
layout: page
parent: Background Information
nav_order: 2
---

# Notation
{: .no_toc }
This page describes the naming conventions and notation used in SADYCOS.

## Page Contents
{: .no_toc .text-delta }

- TOC
{:toc}

## Naming Conventions
SADYCOS attempts to adhere to the following naming conventions:
- **Structures** and **Classes**: `PascalCase`
- **Functions** and **Methods**: `camelCase`
- **Non-struct Variables**: `snake_case`

## Physical Quantities
SADYCOS is relatively verbose in its naming of physical quantities.
This is to ensure that the user can easily identify the meaning of a variable by its name which greatly improves debugging.
If applicable, variables names of physical quantities include information about the coordinate frame in which the quantity is expressed and the unit.

In the `execute` method of the `RigidBodyMechanics` model, the variable `angular_velocity_BI_B__rad_per_s` is used. The first part of the name `angular_velocity_BI` indicates that it holds the value of the angular velocity of the body frame `B` with respect to the inertial frame `I`.
The remainder is explained in the following sections. 

### Unit
The physical unit of a variable is always the last part of the variable name.
It is separated from the rest of the name by a double underscore `__`.
Composite units are separated by a single underscore `_`. 
Units with a positive exponent are separated from those with a negative one by `_per_`.

In the above example, the unit part reads `rad_per_s` which indicates that the angular velocity is given in radians per second.

### Coordinate Frame
Many quantities have a numerical representation that is dependent on a choice of coordinate frame.
In SADYCOS, the coordinate frame is indicated by a suffix in the variable name that comes before the physical unit.
It consists of and underscore and an abbreviation (usually a single letter) of the frame.

The above example features a frame suffix `B` which indicates that the variable holds the representation of the angular velocity in the body frame `B`.

The following is a list of frame abbreviations that are commonly used in SADYCOS:
- **`I`**: Inertial frame
    - a frame in which momentum conservation holds 
- **`B`**: Body frame
    - a frame attached to the satellite body
- **`CAD`**: (Computer Aided) Design frame
    - another frame attached to the satellite body that is used for the design of the satellite
    - positions and directions of satellite parts are often more readily available in this frame
- **`R`**: Reference frame
    - a frame that is used as a reference for a specific task
    - e.g., the frame that represents the desired attitude of the satellite
