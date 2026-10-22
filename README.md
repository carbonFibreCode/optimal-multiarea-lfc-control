# Optimal Control of Multi-Area Power System

**B.Tech Project (BTP)** — Load Frequency Control using PID optimization for multi-area interconnected power systems.

---

## Project Structure

```
├── models/
│   ├── single_area/
│   │   └── single_area_lfc.m              # Single-area LFC with droop control
│   ├── two_area/
│   │   ├── two_area_lfc_transfer_function.m   # Two-area LFC (transfer function approach)
│   │   ├── two_area_lfc_state_space_v1.m      # Two-area LFC (state-space, Kp=100, R=0.05)
│   │   ├── two_area_lfc_state_space_v2.m      # Two-area LFC (state-space, Kp=20, R=2.4, Indian grid 50 Hz)
│   │   └── two_area_lfc_state_space_v3.m      # Two-area LFC (state-space with stability check)
│   ├── simulink/
│   │   └── two_area_lfc_simulink.slx      # Simulink model for two-area LFC
│   ├── synchronous_generator/
│   │   └── v_curve_analysis.m             # V-curve analysis of synchronous generator
│   └── utils/
│       └── controllability_observability_check.m  # Controllability & observability check
├── references/                            # Reference PDFs and textbooks
├── results/                               # Output plots and figures
└── README.md
```

## Models Overview

### Single-Area LFC
- Transfer-function based closed-loop model
- Components: Governor → Turbine → Generator-Load with droop feedback (1/R)
- Analysis: Step response, Bode, Root Locus, Nyquist, Pole-Zero

### Two-Area LFC
Three progressively refined implementations:

| File | Approach | Key Parameters |
|------|----------|----------------|
| `two_area_lfc_transfer_function.m` | Transfer function (sequential sim) | Kp=100, R=0.05 |
| `two_area_lfc_state_space_v1.m` | State-space (7 states, `lsim`) | Kp=100, R=0.05 |
| `two_area_lfc_state_space_v2.m` | State-space + Indian grid (50 Hz base) | Kp=20, R=2.4 |
| `two_area_lfc_state_space_v3.m` | State-space + stability verification | Kp=20, R=2.4 |

**7-State Vector**: `[Δf₁, ΔPg₁, ΔPm₁, Δf₂, ΔPg₂, ΔPm₂, ΔPtie]`

## Current Progress

- [x] Single-area LFC model
- [x] Two-area LFC (transfer function)
- [x] Two-area LFC (state-space)
- [x] Stability analysis & system plots
- [ ] PID controller design
- [ ] ACE (Area Control Error) computation
- [ ] Optimal PID tuning (PSO / GA / LQR)
- [ ] Extension to 3+ areas
- [ ] Performance comparison (droop vs PID vs optimal PID)

## Requirements

- MATLAB R2020a or later
- Control System Toolbox
- Simulink (for `.slx` models)
