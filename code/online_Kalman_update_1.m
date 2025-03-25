function param_distr = online_Kalman_update_1(state_true, param_sys, param_distr, param_console)
% param_distr = online_Kalman_update(k, param_sys, param_distr, param_console)
% performs the updates that can be carries online (mean) at a given time step k.
%
% OUTPUTS:
% param_distr: struct with fields in init_param_distr.m
%
% INPUTS:
% param_distr: struct with fields in init_param_distr_sys.m
% param_sys: struct with fields in init_param_distr_sys.m
% param_console: struct with fields in init_param_console.m

%% EXTRACT PARAMETERS FORM STRUCTS
m = param_console.m;
k = param_console.k;
A = param_sys.a;
add_noise_e = param_distr.add_noise_e;                                                      % MEASUREMENT NOISE BEFORE AGENT 1
add_noise_v = param_distr.add_noise_v;                                                      % MEASUREMENT NOISE BEFORE AGENT i>=2 AND i<=m

%% NOISE REALIZATIONS FOR THE RANDOM PROCESSES e and v
add_noise_e_real = [NaN, normrnd(add_noise_e.mean, add_noise_e.var, 1, k)];                 % A SEQUENCE OF REALIZATIONS FOR TEH RANDOM VARIABLE "e"
add_noise_v_real = NaN(m-1,k+1);
for i = 1:m-1
    add_noise_v_real(i, 2:end) = normrnd(add_noise_v.mean(i), add_noise_v.var(i), 1, k);    % A SEQUENCE OF REALIZATIONS FOR TEH RANDOM VARIABLE "v^(i)"
end

%% MEASUREMENTS OBTAINED BY EVERY AGENT
measurements = struct;
measurements.cascade = NaN(m, k+1);
measurements.WoM     = NaN(m, k+1);

%% POST PROCESSING STEP OF EVERY AGENT
post_processing = struct;
post_processing.cascade = NaN(m, k+1);
post_processing.WoM = NaN(m, k+1);

%% CASCADE/PRIVATE-PRIOR SETUP

% MEASUREMENT COLLECTED BY THE FIRST AGENT
measurements.cascade(1,2:end) = state_true(1,2:end) + add_noise_e_real(1,2:end);

% LOOP OVER ALL TIME STEPS
for curr_k = 2:k+1

    % LOOP OVER ALL THE AGENTS
    for i = 1:m
        if i == 1

            % PRIOR SEEN BY AGENT 1
            prior_mean = param_distr.posterior.cascade.mean(1,curr_k-1);

            % PREDICTION STEP AGENT 1
            predicted_mean = A * prior_mean;

            % A-POSTERIORI STEP AGENT 1
            gain = param_distr.gain.cascade(1,curr_k);
            posterior_mean = (1 - gain) * predicted_mean + gain * measurements.cascade(1, curr_k);

            % POST-PROCESSING STEP
            post_processing.cascade(1, curr_k) = posterior_mean - (1 - gain) * prior_mean;

            % ASSIGN THE OUTPUT FIELDS in param_distr
            param_distr.prediction.cascade.mean(1, curr_k) = predicted_mean;
            param_distr.posterior.cascade.mean(1, curr_k)  = posterior_mean;

        elseif (i > 1) && (i < m)

            % PRIOR SEEN BY AGENT i
            prior_mean = param_distr.posterior.cascade.mean(i,curr_k-1);

            % PREDICTION STEP AGENT i
            predicted_mean = A * prior_mean;

            % A-POSTERIORI STEP AGENT i (INCLUDES PRE-PROCESSING STEP)
            measurements.cascade(i, curr_k) = (post_processing.cascade(i-1, curr_k) + add_noise_v_real(i-1, curr_k)) / param_distr.gain.cascade(i-1, curr_k);
            gain = param_distr.gain.cascade(i, curr_k);
            posterior_mean = (1 - gain) * predicted_mean + gain * measurements.cascade(i, curr_k);
            
            % POST-PROCESSING STEP AGENT i
            post_processing.cascade(i, curr_k) = posterior_mean - (1 - gain) * prior_mean;

            % ASSIGN THE OUTPUT FIELDS in param_distr
            param_distr.prediction.cascade.mean(i, curr_k) = predicted_mean;
            param_distr.posterior.cascade.mean(i, curr_k)  = posterior_mean;

        elseif i == m

            % PRIOR SEEN BY AGENT m
            prior_mean = param_distr.posterior.cascade.mean(i,curr_k-1);

            % PREDICTION STEP AGENT m
            predicted_mean = A * prior_mean;

            % A-POSTERIORI STEP AGENT m (INCLUDES PRE-PROCESSING STEP)
            measurements.cascade(i, curr_k) = (post_processing.cascade(i-1, curr_k) + add_noise_v_real(i-1, curr_k)) / param_distr.gain.cascade(i-1, curr_k);
            gain = param_distr.gain.cascade(i, curr_k);
            posterior_mean = (1 - gain) * predicted_mean + gain * measurements.cascade(i, curr_k);

            % ASSIGN THE OUTPUT FIELDS in param_distr
            param_distr.prediction.cascade.mean(i, curr_k) = predicted_mean;
            param_distr.posterior.cascade.mean(i, curr_k)  = posterior_mean;
        end
    end
end


%% WoM SETUP

% MEASUREMENT COLLECTED BY THE FIRST AGENT
measurements.WoM(1,2:end) = state_true(1,2:end) + add_noise_e_real(1,2:end);

% LOOP OVER ALL TIME STEPS
for curr_k = 2:k+1

    % PRIOR SEEN BY ALL AGENTS
    prior_mean = param_distr.posterior.WoM.mean(end, curr_k-1);

    % PREDICTION STEP AGENT 1
    predicted_mean = A * prior_mean;

    % LOOP OVER ALL THE AGENTS
    for i = 1:m

        if i == 1

            % A-POSTERIORI STEP AGENT 1
            gain = param_distr.gain.WoM(1,curr_k);
            posterior_mean = (1 - gain) * predicted_mean + gain * measurements.WoM(1, curr_k);

            % POST-PROCESSING STEP
            post_processing.WoM(1, curr_k) = posterior_mean - (1 - gain) * prior_mean;

            % ASSIGN THE OUTPUT FIELDS in param_distr
            param_distr.prediction.WoM.mean(1, curr_k) = predicted_mean;
            param_distr.posterior.WoM.mean(1, curr_k)  = posterior_mean;

        elseif (i > 1) && (i < m)

            % A-POSTERIORI STEP AGENT i (INCLUDES PRE-PROCESSING STEP)
            measurements.WoM(i, curr_k) = (post_processing.WoM(i-1, curr_k) + add_noise_v_real(i-1, curr_k)) / param_distr.gain.WoM(i-1, curr_k);
            gain = param_distr.gain.WoM(i, curr_k);
            posterior_mean = (1 - gain) * predicted_mean + gain * measurements.WoM(i, curr_k);
            
            % POST-PROCESSING STEP AGENT i
            post_processing.WoM(i, curr_k) = posterior_mean - (1 - gain) * prior_mean;

            % ASSIGN THE OUTPUT FIELDS in param_distr
            param_distr.prediction.WoM.mean(i, curr_k) = predicted_mean;
            param_distr.posterior.WoM.mean(i, curr_k)  = posterior_mean;

        elseif i == m

            % A-POSTERIORI STEP AGENT m (INCLUDES PRE-PROCESSING STEP)
            measurements.WoM(i, curr_k) = (post_processing.WoM(i-1, curr_k) + add_noise_v_real(i-1, curr_k)) / param_distr.gain.WoM(i-1, curr_k);
            gain = param_distr.gain.WoM(i, curr_k);
            posterior_mean = (1 - gain) * predicted_mean + gain * measurements.WoM(i, curr_k);

            % ASSIGN THE OUTPUT FIELDS in param_distr
            param_distr.prediction.WoM.mean(i, curr_k) = predicted_mean;
            param_distr.posterior.WoM.mean(i, curr_k)  = posterior_mean;
        end
    end
end



end