function limit_points = compute_limit_points(param_distr, param_sys, param_console)
% limit_points = compute_limit_points(param_distr, param_console) computes
% the limit point of the predicted variance, posterior variance, asnd the
% kalman gain as a result of the Discrete Algebraic Riccati Equation.
%
% OUTPUTS:
% limit_points: struct containing the limit points for cascade and WoM
% architectures
%
% INPUTS:
% param_distr: struct with fields in init_param_distr_sys.m
% param_sys: struct with fields in init_param_distr_sys.m
% param_console: struct with fields in init_param_console.m

m = param_console.m;

% DECLARE and INITIALIZE THE STRUCTURE OF THE OUTPUT
limit_points = struct;
    limit_points.cascade = struct;
        limit_points.cascade.prediction_infty = NaN(m, 1);
        limit_points.cascade.gain_infty = NaN(m, 1);
        limit_points.cascade.posterior_infty = NaN(m, 1);
    limit_points.WoM = struct;
        limit_points.WoM.poly = struct;
        limit_points.WoM.prediction_infty = NaN(m, 1);
        limit_points.WoM.gain_infty = NaN(m, 1);
        limit_points.WoM.posterior_infty = NaN(m, 1);

% EQUIVALENT NOISES AT INFINITY (CONSTANT FOR AGENT 1)
add_noise_v = param_distr.add_noise_v;
R_infty = NaN(m,1); R_infty(1,1) = param_distr.add_noise_e.var;

%% EXTRACT SYSTEM PARAMETERS THAT ARE COMMON TO ALL KALMAN FILTERS
A = param_sys.a;
B = param_sys.b;
H = param_sys.h;
Q = param_distr.add_noise_w.var;

%% CASCADE ARCHITECTURE
for i = 1:m
    
    % ALGEBRAIC RICCATI EQUATION FOR PREDICTION, POSTERIOR AND GAIN
    R = R_infty(i, 1);
    [prediction_infty, ~, ~] = dare(A, B, Q, R);
    gain_infty = ((prediction_infty * H) / (H^2 * prediction_infty + R));
    posterior_infty = (1 - gain_infty * H) * prediction_infty;
    
    % ASSIGN THE OUTPUT VARIABLES
    limit_points.cascade.prediction_infty(i,1) = prediction_infty;
    limit_points.cascade.gain_infty(i,1) = gain_infty;
    limit_points.cascade.posterior_infty(i,1) = posterior_infty;

    % LIMIT OF EQUIVALENT NOISE AT INFINITY FOR THE NEXT AGENT
    if i < m
        R_infty(i+1,1) = R_infty(i,1) + (add_noise_v.var(i) / (gain_infty)^2);
    end
end

%% WoM ARCHITECTURE
% The limit point is obtained as the solution of a polynomial equuation of high degree

end