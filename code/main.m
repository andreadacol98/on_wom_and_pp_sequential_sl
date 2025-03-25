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

% Loop over time steps to get trajectoriy of gain and variance
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
% fprintf("\nPLOT ONE TRAJECTORY OF POSTERIOR VARIANCE");
% plot_variance(param_distr, param_console);

%% PLOT UNIQUENESS OF FIXED POINTS (Cascade and WoM)
fprintf("\nPLOT TRAJECTORY FOR SEVERAL INITIAL CONDITIONS");
[trajectories, param_distr] = compute_trajectories(param_distr, param_sys, param_console);
plot_variance_trajectories(trajectories, param_console);

%% COMPUTE ONLINE KALMAN UPDATE (mean)
fprintf("\nPERFORM ONLINE COMPUTATIONS");

% True value of the state over time (what we want to estimate)
state_true = zeros(1, param_console.k+1); 
state_true(1, 1) = normrnd(param_distr.state.mean, sqrt(param_distr.state.var));

% COMPUTE THE TRUE SEQUENCE OF STATES
for k = 2:param_console.k + 1
    state_true(1, k) = param_sys.a * state_true(1, k-1) + normrnd(0, sqrt(param_distr.add_noise_w.var));
end

% ONLINE UPDATE
param_distr = online_Kalman_update_1(state_true, param_sys, param_distr, param_console);

% Loop over time steps to get trajectory of mean
% for k = 2:param_console.k + 1
%     % Compute estimates
%     param_distr = online_Kalman_update(k, state_true(1, k), param_sys, param_distr, param_console);
%     % Update user of progress...
%     if mod(k,10000) == 0
%         fprintf("\n\tCURRENT ITERATION: %d",k)
%     end
% end

%% COMPUTE MEAN SQUARE ERROR FOR ALL AGENTS
MSE = compute_MSE(state_true, param_distr, param_console);

%% PLOT THE POSTERIOR MEAN (CASCADE and WoM)
fprintf("\nPLOT ONE TRAJECTORY OF POSTERIOR MEAN");
plot_mean(state_true, param_distr, param_console);
