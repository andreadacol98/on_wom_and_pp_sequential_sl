function [param_distr, param_sys] = init_param_distr_sys(param_console)
% [param_distr, param_sys] = init_param_distr_sys(param_console)
%
% param_sys: struct with the following fileds
%   .a: A matrix (state eq.)
%   .b: B matrix (state eq.)
%   .h: H matrix (measurement eq.)
%   .g: G matrix (measurement eq.)
%
% param_distr: struct with the following fields
%   .state: struct with the following fields
%       .mean: true mean of the state variables theta
%       .var: true variance of the state variables theta
%   .add_noise_w: struct with the following fields
%       .mean: mean of the process noise
%       .var: variance of the process noise
%   .add_noise_e: struct with the following fields
%       .mean: mean of additive noise "e" on the true theta
%       .var: variance of additive noise "e" on the true theta
%   .add_noise_v: struct with the following fields
%       .mean: mean of additive noises "v^(i)" on theta estimates
%       .var: variance of additive noises "v^(i)" on theta estimates
%   .prediction_cascade
%       .mean: mean of the predicted distributions over time
%       .var: variance of the predicted distributions over time
%   .prediction_WoM
%       .mean: mean of the predicted distributions over time
%       .var: variance of the predicted distributions over time
%   .gain
%   .posterior_cascade
%       .mean: mean of the posterior distributions over time
%       .var: variance of the posterior distributions over time
%   .posterior_WoM
%       .mean: mean of the posterior distributions over time
%       .var: variance of the posterior distributions over time
%   .eq_noise_n_cascade: struct with the following fields
%       .mean: mean of equivalent noises "n^(i)" over time
%       .var: variance of equivalent noises "n^(i)" over time
%   .eq_noise_n_WoM: struct with the following fields
%       .mean: mean of equivalent noises "n^(i)" over time
%       .var: variance of equivalent noises "n^(i)" over time

fprintf("\nINITITIALIZING PARAMETERS FOR SOCIAL LEARNING")

%% EXTRAPOLATE PARAMETERS from "param_console"
m = param_console.m;
k = param_console.k;

seed = 1;

%% STRUCT CONTAINING ALL PARAMETERS
param_sys = struct;
param_distr = struct;

%% SYSTEM PARAMETERS
param_sys.a = 0.95;            % stable scalar system
param_sys.b = 1;
param_sys.h = 1;
param_sys.g = 1;

%% INITIAL STATE DISTRIBUTION (x(0) in paper)
param_distr.state = struct;
param_distr.state.mean = 25; % gen_rand_integer([-100, 100], seed); seed = seed + 1;
param_distr.state.var = 25; % 10; seed = seed + 1;

%% PROCESS NOISE DISTRIBUTION (w in paper)
param_distr.add_noise_w = struct;
param_distr.add_noise_w.mean = 0;
param_distr.add_noise_w.var = 1; % 10 * gen_rand_real(seed); seed = seed + 1;

%% MEASUREMENT NOISE OF FIRST AGENT (e, or v^(0) in paper)
param_distr.add_noise_e = struct;
param_distr.add_noise_e.mean = 0;
param_distr.add_noise_e.var = 1; % 10 * gen_rand_real(seed); seed = seed + 1;

%% MEASUREMENT NOISE OF SUBSEQUENT AGENTS (v^(i) in paper)
param_distr.add_noise_v = struct;
param_distr.add_noise_v.mean = zeros(m-1,1);
param_distr.add_noise_v.var = zeros(m-1,1);

for i = 1:m-1
    param_distr.add_noise_v.var(i,1) = 1; % 10 * gen_rand_real(seed);
    % seed = seed + 1;
end

%% EQUIVALENT NOISE (n_k^(i) in paper)
param_distr.add_noise_n = struct;

% EQUIVALENT NOISE FOR CASCADE
param_distr.add_noise_n.cascade = struct;
param_distr.add_noise_n.cascade.mean = zeros(m,k+1);
param_distr.add_noise_n.cascade.var = zeros(m,k+1);

% EQUIVALENT NOISE FOR WoM 
param_distr.add_noise_n.WoM = struct;
param_distr.add_noise_n.WoM.mean = zeros(m,k+1);
param_distr.add_noise_n.WoM.var = zeros(m,k+1);

% At time step k = 0 (index 1 in MATLAB) we have initial conditions only (no eqivalent noise yet)
param_distr.add_noise_n.cascade.mean(:,1) = NaN(m,1);
param_distr.add_noise_n.cascade.var(:,1)  = NaN(m,1);
param_distr.add_noise_n.WoM.mean(:,1) = NaN(m,1);
param_distr.add_noise_n.WoM.var(:,1)  = NaN(m,1);

% Equivalent noise seen by agent one is constant over time
for t = 2:k+1
    param_distr.add_noise_n.cascade.var(1,t) = param_distr.add_noise_e.var;
    param_distr.add_noise_n.WoM.var(1,t) = param_distr.add_noise_e.var;
end


%% KALMAN GAINS OVER TIME (different for cascade and WoM architectures)
param_distr.gain = struct;
param_distr.gain.cascade = zeros(m,k+1);
param_distr.gain.WoM = zeros(m,k+1);

% No kalman gains at time step k = 0 (initialized at Nan)
param_distr.gain.cascade(:,1) = NaN(m,1);
param_distr.gain.WoM(:,1) = NaN(m,1);

%% ONE-STEP AHEAD PREDICTIONS OVER TIME (prediction step of KF)
param_distr.prediction = struct;

% ONE-STEP AHEAD PREDICTIONS OVER TIME FOR CASCADE ARCHITECTURE (prediction step of KF)
param_distr.prediction.cascade = struct;
param_distr.prediction.cascade.mean = zeros(m,k+1);
param_distr.prediction.cascade.var = zeros(m,k+1);

% ONE-STEP AHEAD PREDICTIONS OVER TIME FOR WoM ARCHITECTURE (prediction step of KF)
param_distr.prediction.WoM = struct;
param_distr.prediction.WoM.mean = zeros(m,k+1);
param_distr.prediction.WoM.var = zeros(m,k+1);

% No prediction at time step k = 0 (initialized at Nan)
param_distr.prediction.cascade.mean(:,1) = NaN(m,1);
param_distr.prediction.cascade.var(:,1) = NaN(m,1);
param_distr.prediction.WoM.mean(:,1) = NaN(m,1);
param_distr.prediction.WoM.var(:,1) = NaN(m,1);

%% POSTERIORS OVER TIME (correction step of KF)
param_distr.posterior = struct;

% POSTERIOR OVER TIME FOR CASCADE ARCHITECTURE
param_distr.posterior.cascade = struct;
param_distr.posterior.cascade.mean = zeros(m,k+1);
param_distr.posterior.cascade.var = zeros(m,k+1);

% POSTERIORS OVER TIME FOR WoM
param_distr.posterior.WoM = struct;
param_distr.posterior.WoM.mean = zeros(m,k+1);
param_distr.posterior.WoM.var = zeros(m,k+1);

% Set initial condition at time step k = 0 (index 1 in MATLAB). In the
% cascade,I set the same initial conditions for every agent for simplicity.
% In WoM, instead, they have to be the same due to the underlying problem structure!!!
for i = 1:m
    param_distr.posterior.cascade.mean(i,1) = param_distr.state.mean;
    param_distr.posterior.cascade.var(i,1)  = param_distr.state.var;
    param_distr.posterior.WoM.mean(i,1) = param_distr.state.mean;
    param_distr.posterior.WoM.var(i,1)  = param_distr.state.var;
end

end