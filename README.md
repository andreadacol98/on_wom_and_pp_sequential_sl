# On Word-of-Mouth and Private-Prior Sequential Social Learning

## Abstract
**Social learning** constitutes a fundamental framework for studying interactions among rational agents who observe each other’s actions but lack direct access to individual beliefs. 
This paper investigates a specific social learning paradigm known as **Word-of-Mouth (WoM)**, where a series of agents seeks to estimate the state of a dynamical system. 
The first agent receives noisy measurements of the state, while each subsequent agent relies solely on a degraded version of her predecessor’s estimate. 
A defining feature of WoM is that the final agent’s belief is publicly broadcast and subsequently adopted by all agents, in place of their own. 
We analyze this setting theoretically and through numerical simulations, noting that some agents benefit from using the belief of the last agent, while others experience performance degradation.

## Additional Information
This repository provides commented code for studying (and visualizing) the asymptotic dynamics of two social learning paradigms, called **private-prior (PP)** and **Word-of-Mouth**.
The code was used to produces several illustrative examples to corroborate recent theoretical findings on social learning, data incest and misinformation propagation.
Further details about this line of research are found in the following document, accepted for publication at the **64<sup>th</sup> IEEE Conference on Decision and Control**:
[🔗 On Word-of-Mouth and Private-Prior Sequential Social Learning](https://arxiv.org/abs/2504.02913).

## Requirements
**MATLAB R2024b** or later (tested on R2024b). No specific toolboxes are needed.

## Installation
Clone this repository by downloading the zip file. Alternatively, one can use:
```bash
git clone https://github.com/andreadacol98/on_wom_and_pp_sequential_sl.git
```

## File Overview

The code is organised so  the user only needs to run `main_simulation.m`.
The problem parameters will be inserted (from keyboard) in command window after the start of the program (a simple example on how to do this i provided in a later section).

Here is an high-level description of the MATLAB files in this repository:

| File              | Description                                      |
|-------------------|--------------------------------------------------|
| `main_simulation.m`       | Main script to reproduce the simulations in the paper. |
| `clear_para_distr.m`      | Sets the data structure `param_distr` to its default initialization, as specified in `init_param_distr_sys.m`. |
| `compute_MSE.m`           | Computes the mean-squared error (MSE). |
| `compute_limit_points.m`  | Compute the limit points for the predictive variance, Kalman gains, and posterior variance as the result of Discrete Algebraic Riccati equations (DAREs), for the PP framework. |
| `compute_trajectories.m`  | Computes the trajectories of the predictive variance, Kalman gain, and posterior variance for both the PP and WoM settings. |
| `gen_rand_integer.m`      | Generates a random integer in a certain range, using a specified seed for the random number generator. |
| `gen_rand_real.m`         | Generates a random integer in a certain range, using a specified seed for the random number generator. |
| `init_param_console.m`    | The user initializes the main problem parameters from keyboard (e.g., number of agents, simulation length etc). |
| `init_param_distr_sys.m`  | Initialize other problem parameters (e.g., the state transition matrix, the process and measurement noise varioances etc). |
| `offline_Kalman_update.m` | Performs the deterministic updates (i.e., variances and gain), that can therefore be carryed offline. |
| `online_Kalman_update.m`  | Performs the updates that depend on online data (i.e., mean estimates). |
| `plot_mean.m`             | Plots the time trajectory of the predictive and posterior estimates, for both PP and WoM. |
| `plot_variance_trajectories.m`         | Plots the time trajectory of the predictive and posterior variances and gains, for both PP and WoM. |
