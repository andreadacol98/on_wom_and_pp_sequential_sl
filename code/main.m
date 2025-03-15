clc
clear
close all

%% SET RANDOM NUMBER GENERATOR
rng(1);

%% SET DESIGN PARAMETERS
param_console = init_param_console();

%% SET DISTRIBUTION PARAMETERS
[param_distr, param_sys] = init_param_distr_sys(param_console);

%% COMPUTE OFFLINE KALMAN UPDATE (gain and variance)
fprintf("\nPERFORM OFFLINE COMPUTATIONS");

% Loop over time steps to trajectories of gain and variance
for k = 2:param_console.k + 1
    param_distr = offline_Kalman_update(k, param_sys, param_distr, param_console);
    % Update user of progress...
    if mod(k,10000) == 0
        fprintf("\n\tCURRENT ITERATION: %d",k)
    end
end

%% CONVERGENCE TO THE LIMIT POINTS (gain and predicted/posterior variance)
fprintf("\nCOMPUTE LIMIT POINTS");
limit_points = compute_limit_points(param_distr, param_sys, param_console);

%% PLOT THE POSTERIOR VARIANCE (CASCADE and WoM)
fprintf("\nPLOT TRAJECTORY EVOLUTION");
plot_variance(param_distr, param_console);

%% PLOT UNIQUENESS OF FIXED POINTS (Cascade and WoM)
fprintf("\nPLOT TRAJECTORY FOR SEVERAL INITIAL CONDITIONS");
[trajectories, param_distr] = compute_trajectories(param_distr, param_sys, param_console);
plot_trajectories(trajectories, param_console);

