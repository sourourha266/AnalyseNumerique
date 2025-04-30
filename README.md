# 🔬 Diffusion Simulation in MATLAB

## 📘 Overview

This project simulates the **diffusion process** (also known as the heat equation) using **finite difference methods** in MATLAB. It models how a concentration or temperature spreads over time in one or two spatial dimensions, based on Fick’s Law or the diffusion equation:

\[
\frac{\partial u}{\partial t} = D \nabla^2 u
\]

Where:
- \( u \) is the scalar field (e.g., concentration or temperature),
- \( D \) is the diffusion coefficient,
- \( \nabla^2 u \) is the Laplacian (second spatial derivative).

---

## 🧮 Methods

- **Numerical method**: Finite Difference Method (Explicit Scheme)
- **Boundary conditions**: Dirichlet or Neumann (depending on setup)
- **Dimensions**: 1D and/or 2D
- **MATLAB version**: R2020 or later recommended

---

## 📁 Files

| File                | Description                                        |
|---------------------|----------------------------------------------------|
| `diffusion_1d.m`    | 1D diffusion simulation script                     |
| `diffusion_2d.m`    | 2D diffusion simulation using a square grid        |
| `initial_conditions.m` | Helper file to set initial concentration/temperature |
| `plot_results.m`    | Visualization of results as heatmaps or line plots |

---

## ⚙️ Parameters

You can configure the following parameters inside the script:

```matlab
D = 0.1;          % Diffusion coefficient
L = 1.0;          % Length of domain (1D) or size of square (2D)
Nx = 50;          % Number of spatial steps
dt = 0.001;       % Time step
T  = 1.0;         % Total simulation time
