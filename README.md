# McCabe-Thiele Method Simulation

This project consists of a MATLAB implementation of the McCabe-Thiele method for determining the number of theoretical stages in binary distillation columns.

## Description

This project provides a numerical simulation of the McCabe-Thiele method, a graphical technique used in chemical engineering to determine the number of theoretical plates required for binary distillation separation. The implementation includes visualization of the equilibrium curve, operating lines, and step-wise construction.

### Features

- Vapor-liquid equilibrium (VLE) curve generation
- Operating lines calculation (minimum reflux ratio)
- Automatic stepping procedure for stage determination
- Customizable feed conditions and column parameters

## Prerequisites

- MATLAB R2019b or newer
- MATLAB Optimization Toolbox (optional, for enhanced curve fitting)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/MohamedAliAJROUD/MATLAB_Project
```

2. Add the project directory to your MATLAB path:
```matlab
addpath('path/to/mccabe-thiele-matlab')
```

3. Input the required parameters when prompted:
   - Feed composition (z_F)
   - Feed quality (q)
   - Desired distillate composition (x_D)
   - Desired bottom composition (x_B)
   - Reflux ratio (R)

### Example

```matlab
% Define system parameters
params.zF = 0.5;    % Feed composition
params.q = 1;       % Saturated liquid feed
params.xD = 0.95;   % Distillate composition
params.xB = 0.05;   % Bottom composition
params.R = 1.5;     % Reflux ratio

% Run simulation
[stages, diagram] = McCabeThiele_simulate(params);
```

## Theory

The McCabe-Thiele method uses the following key concepts:
1. Equilibrium curve (y vs x diagram)
2. Operating lines:
   - Rectifying section: y = (R/(R+1))x + (xD/(R+1))
   - Stripping section: y = (L_s/V_s)x - (B*xB/V_s)
3. Feed line: y = ((q-1)/q)x + (z_F/q)


## Authors

* **Mohamed Ali AJROUD** - *Chemical Engineering Student*

## Acknowledgments

* Chemical Engineering Department at National Institue of Applied Sciences and Technology of Tunis
* Pr. Mohammad Jamel Mohammad

## Contact

Mohamed Ali AJROUD - mohamedali.ajroud@insat.ucar.tn
Project Link: https://github.com/MohamedAliAJROUD/MATLAB_Project
