function param_distr = online_Kalman_update(k, state_true, param_sys, param_distr, param_console)
% param_distr = online_Kalman_update(k, param_sys, param_distr, param_console)
% performs the updates that can be carries online (mean) at a given time step k.
%
% OUTPUTS:
% param_distr: struct with fields in init_param_distr.m
%
% INPUTS:
% k: current time step
% param_distr: struct with fields in init_param_distr_sys.m
% param_sys: struct with fields in init_param_distr_sys.m
% param_console: struct with fields in init_param_console.m

%% EXTRACT PARAMETERS FORM STRUCTS
m = param_console.m;
A = param_sys.a;                                                           % Changing to uppercase for readability purposes
H = param_sys.h;                                                           % Changing to uppercase for readability purposes

%% KALMAN UPDATE FOR THE CASCADE ARCHITECTURE

% PRIOR MEAN OF THE LAST AGENT at time k-1
prior_mean = param_distr.posterior.cascade.mean(end, k-1);

% EQUIVALENT MEASUREMENT NOISE SEEN BY THE LAST AGENT at TIME STEP k
R = param_distr.add_noise_n.cascade.var(end, k);

% PRIOR UPDATE STEP
predicted_mean = A * prior_mean;

% MEASUREMENT UPDATE STEP
measurement = state_true + normrnd(0, sqrt(R));
gain = param_distr.gain.cascade(end,k);
posterior_mean = (1 - gain*H) * predicted_mean + gain * measurement;

% ASSIGN THE OUTPUT FIELDS in param_distr
param_distr.prediction.cascade.mean(end,k) = predicted_mean;
param_distr.posterior.cascade.mean(end,k) = posterior_mean;


%% KALMAN UPDATE FOR THE WoM ARCHITECTURE

% PRIOR MEAN OF THE LAST AGENT at time k-1
prior_mean = param_distr.posterior.WoM.mean(end, k-1);

% EQUIVALENT MEASUREMENT NOISE SEEN BY THE LAST AGENT at TIME STEP k
R = param_distr.add_noise_n.WoM.var(end, k);

% PRIOR UPDATE STEP
predicted_mean = A * prior_mean;

% MEASUREMENT UPDATE STEP
measurement = state_true + normrnd(0, sqrt(R));
gain = param_distr.gain.WoM(end,k);
posterior_mean = (1 - gain*H) * predicted_mean + gain * measurement;

% ASSIGN THE OUTPUT FIELDS in param_distr
param_distr.prediction.WoM.mean(end,k) = predicted_mean;
param_distr.posterior.WoM.mean(end,k) = posterior_mean;

end