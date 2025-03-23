function [trajectories, param_distr] = compute_trajectories(param_distr, param_sys, param_console)

%% EXTRACTING PARAMETERS
% FROM PARAM CONSOLE
k = param_console.k;
m = param_console.m;

%% NUMBER OF INITIAL CONDITONS (POSTERIORS) AND THEIR RANGE TO BE CONSIDERED
n_ic = 2;
ic_min = 0;
ic_max = 2;
ic_vec = linspace(ic_min, ic_max, n_ic);

%% DEFINE DATA STRUCTURES TO STORE THE TRAJECTORIES
trajectories = struct;

% NUMBER OF TRAJECTORIES
trajectories.n_ic = n_ic;

% CASCADE ARCHITECTURE
    trajectories.cascade = struct;
        trajectories.cascade.predictions = struct;
            trajectories.cascade.predictions.var = NaN(m, k+1, n_ic);
        trajectories.cascade.posteriors = struct;
            trajectories.cascade.posteriors.var = NaN(m, k+1, n_ic);
        trajectories.cascade.gain = NaN(m, k+1, n_ic);
        trajectories.cascade.add_noise_n.var = NaN(m, k+1, n_ic);

% WoM ARCHITECTURE
    trajectories.WoM = struct;
        trajectories.WoM.predictions = struct;
            trajectories.WoM.predictions.var = NaN(m, k+1, n_ic);
        trajectories.WoM.posteriors = struct;
            trajectories.WoM.posteriors.var = NaN(m, k+1, n_ic);
        trajectories.WoM.gain = NaN(m, k+1, n_ic);
        trajectories.WoM.add_noise_n.var = NaN(m, k+1, n_ic);

%% INITIALIZE THE ABOVE DATA STRUCTURES WITH THE INITIAL CONDITIONS (CASCADE AND WoM)
for i = 1:m
    trajectories.cascade.posteriors.var(i, 1, :) = ic_vec;
    trajectories.WoM.posteriors.var(i, 1, :) = ic_vec;
end

%% COMPUTE ALL THE TRAJECTORIES (FOR CASCADE and WoM INTERCONNECTIONs)
% LOOP OVER THE INITIAL CONDITIONS
for i_ic = 1:n_ic

    % initialize "param_distr" with the new initial condition of the
    % posterior variance, and ripristinate the equivalent noises
    param_distr = clear_param_distr(param_distr, param_console, ic_vec(i_ic));              

    % LOOP OVER THE TIME STEPS
    for i_k = 2:k+1
        param_distr = offline_Kalman_update(i_k, param_sys, param_distr, param_console);    % perform the kalman update for all agents, given the current initial condition i_ic
    end

    % PERFORM ASSIGNMENT TO "trajectories" DATA STRUCTURE
    trajectories.cascade.predictions.var(:,:,i_ic) = param_distr.prediction.cascade.var;
    trajectories.cascade.gain(:,:,i_ic) = param_distr.gain.cascade;
    trajectories.cascade.posteriors.var(:,:,i_ic) = param_distr.posterior.cascade.var;
    trajectories.cascade.add_noise_n.var(:,:,i_ic) = param_distr.add_noise_n.cascade.var;
  
    trajectories.WoM.predictions.var(:,:,i_ic) = param_distr.prediction.WoM.var;
    trajectories.WoM.gain(:,:,i_ic) = param_distr.gain.WoM;
    trajectories.WoM.posteriors.var(:,:,i_ic) = param_distr.posterior.WoM.var;
    trajectories.WoM.add_noise_n.var(:,:,i_ic) = param_distr.add_noise_n.WoM.var;

end
        
end