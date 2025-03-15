function param_distr = clear_param_distr(param_distr, param_console, ic)
% param_distr = clear_param_distr(param_distr, param_console) sets the data
% structure param_distr to its original inititialization values (as in the
% function "init_param_distr_sys.m"), with a specified initial condition
% for the posterior variance

m = param_console.m;
k = param_console.k;

%% CLEAR INITIAL STATE DISTRIBUTION (x(0) in paper)
param_distr.state.var = ic;

%% EQUIVALENT NOISE (n_k^(i) in paper)

% EQUIVALENT NOISE FOR CASCADE
param_distr.add_noise_n.cascade.var = zeros(m,k+1);

% EQUIVALENT NOISE FOR WoM 
param_distr.add_noise_n.WoM.var = zeros(m,k+1);

% At time step k = 0 (index 1 in MATLAB) we have initial conditions only (no eqivalent noise yet)
param_distr.add_noise_n.cascade.var(:,1)  = NaN(m,1);
param_distr.add_noise_n.WoM.var(:,1)  = NaN(m,1);

% Equivalent noise seen by agent one is constant over time
for t = 2:k+1
    param_distr.add_noise_n.cascade.var(1,t) = param_distr.add_noise_e.var;
    param_distr.add_noise_n.WoM.var(1,t) = param_distr.add_noise_e.var;
end


%% KALMAN GAINS OVER TIME (different for cascade and WoM architectures)
param_distr.gain.cascade = zeros(m,k+1);
param_distr.gain.WoM = zeros(m,k+1);

% No kalman gains at time step k = 0 (initialized at Nan)
param_distr.gain.cascade(:,1) = NaN(m,1);
param_distr.gain.WoM(:,1) = NaN(m,1);

%% ONE-STEP AHEAD PREDICTIONS OVER TIME (prediction step of KF)

% ONE-STEP AHEAD PREDICTIONS OVER TIME FOR CASCADE ARCHITECTURE (prediction step of KF)
param_distr.prediction.cascade.var = zeros(m,k+1);

% ONE-STEP AHEAD PREDICTIONS OVER TIME FOR WoM ARCHITECTURE (prediction step of KF)
param_distr.prediction.WoM.var = zeros(m,k+1);

% No prediction at time step k = 0 (initialized at Nan)
param_distr.prediction.cascade.var(:,1) = NaN(m,1);
param_distr.prediction.WoM.var(:,1) = NaN(m,1);

%% POSTERIORS OVER TIME (correction step of KF)
% POSTERIOR OVER TIME FOR CASCADE ARCHITECTURE
param_distr.posterior.cascade.var = zeros(m,k+1);

% POSTERIORS OVER TIME FOR WoM
param_distr.posterior.WoM.var = zeros(m,k+1);

% Set initial condition at time step k = 0 (index 1 in MATLAB). In the
% cascade,I set the same initial conditions for every agent for simplicity.
% In WoM, instead, they have to be the same due to the underlying problem structure!!!
for i = 1:m
    param_distr.posterior.cascade.var(i,1)  = param_distr.state.var;
    param_distr.posterior.WoM.var(i,1)  = param_distr.state.var;
end

end