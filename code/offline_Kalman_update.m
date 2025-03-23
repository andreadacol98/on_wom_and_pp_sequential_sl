function param_distr = offline_Kalman_update(k, param_sys, param_distr, param_console)
% param_distr = offline_Kalman_update(k, param_sys, param_distr, param_console)
% performs the updates that can be carries offline (variance and gain) at a given time step k.
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
Q = param_distr.add_noise_w.var;                                           % Changing to uppercase for readability purposes
v_i = param_distr.add_noise_v;

%% KALMAN UPDATE FOR THE CASCADE ARCHITECTURE
for i = 1:m

    % PRIOR VARIANCE OF AGENT i
    prior_var = param_distr.posterior.cascade.var(i, k-1);

    % EQUIVALENT MEASUREMENT NOISE SEEN BY AGENT i (entering in the POSTERIORI UPDATE)
    R = param_distr.add_noise_n.cascade.var(i, k);

    % PRIOR UPDATE OF AGENT i
    prediction_var = A * prior_var * A' + Q;

    % A POSTERIORI UPDATE
    gain = prediction_var * H' * inv(H * prediction_var * H' + R);
    posterior_var = (1 - gain * H) * prediction_var * (1 - gain * H)' + gain * R * gain';

    % COMPUTE EQUIVALENT NOISE FOR SUBSEQUENT AGENTS
    if i < m
        param_distr.add_noise_n.cascade.var(i+1,k) = param_distr.add_noise_n.cascade.var(i, k) + (v_i.var(i) / (gain)^2);
    end

    % ASSIGN THE OUTPUT FIELDS in param_distr
    param_distr.prediction.cascade.var(i, k) = prediction_var;
    param_distr.gain.cascade(i,k) = gain;
    param_distr.posterior.cascade.var(i, k) = posterior_var;

end

%% KALMAN UPDATE FOR THE WoM ARCHITECTURE
for i = 1:m

    % PRIOR VARIANCE OF AGENT i (same as last agent's in WoM)
    prior_var = param_distr.posterior.WoM.var(end, k-1);

    % EQUIVALENT MEASUREMENT NOISE SEEN BY AGENT i (entering in the POSTERIORI UPDATE)
    R = param_distr.add_noise_n.WoM.var(i, k);

    % PRIOR UPDATE OF AGENT i
    prediction_var = A * prior_var * A' + Q;

    % A POSTERIORI UPDATE
    gain = prediction_var * H' * inv(H * prediction_var * H' + R);
    posterior_var = (1 - gain * H) * prediction_var;

    % COMPUTE EQUIVALENT NOISE FOR SUBSEQUENT AGENTS
    if i < m
        param_distr.add_noise_n.WoM.var(i+1,k) = param_distr.add_noise_n.WoM.var(i, k) + (v_i.var(i) / (gain)^2);
    end

    % ASSIGN THE OUTPUT FIELDS in param_distr
    param_distr.prediction.WoM.var(i, k) = prediction_var;
    param_distr.gain.WoM(i,k) = gain;
    param_distr.posterior.WoM.var(i, k) = posterior_var;

end


end