function poly = compute_pos_poly_cfs(param_distr, param_sys, param_console)

% EXTRACT PARAMETERS
m = param_console.m;
A = param_sys.a;
add_noise_e = param_distr.add_noise_e.var;
add_noise_w = param_distr.add_noise_w.var;
add_noise_v = param_distr.add_noise_v.var;

% OUTPUT STRUCT
poly = struct;

%% POSITIVE COEFFICIENTS OF POLYNOMIALS (rows are the gamma^(i) in the paper)
poly.gamma_cfs = zeros(m, 2^m-1);
poly.positive_cfs = zeros(m, 2^m-1);

for i = 1:m

    % AGENT 1 HAS THE SIUMPLEST EXPRESSION
    if i == 1
        poly.gamma_cfs(1,end) = add_noise_e;
        poly.positive_cfs(1,end) = add_noise_e;
    end

    if i > 1
        % GET GAMMA FOR THE i-th AGENT (see paper for notation)
        get_gamma_i = sum(poly.gamma_cfs(1:i-1,:), 1);                                  % sum all gammaq polynomials until index i-1
        get_gamma_i = [get_gamma_i, 1];                                                 % increase the degree and add 1 as known term
        get_gamma_i = conv(get_gamma_i, get_gamma_i);                                   % square of the polynomial                
        get_gamma_i = add_noise_v(i-1) * get_gamma_i;                                   % multiply by the measurement noise of the agent
        poly.gamma_cfs(i,:) = get_gamma_i(end-2^m+2:end);                               % discard extra coeffcients obtained for square operation

        % GET THE ÅOLYNOMIAL OF POSITIVE COEFFCIENTS
        poly.positive_cfs(i,:) = sum(poly.gamma_cfs(1:i,:), 1);                         % sum of all the gamma polinomials
    end
end

%% POSITIVE COEFFCIENTS OF THE FIXED POINT ITERATION (of the predicted variance)
pos_poly_last_agent = poly.positive_cfs(end,:);
poly_1 = add_noise_w * [pos_poly_last_agent, 0, 0];                        % increase degree by 2 and multiply by process noise variance
poly_2 = (A^2 - 1) * [0, pos_poly_last_agent, 0];                          % increase degree by 1 and multiply by (A^2 - 1) < 0
poly_3 = zeros(1, length(poly_1)); poly_3(end-1:end) = [add_noise_w, -1];

% POLYNOMIAL OF THE FIXED POINT ITERATIONS (TO UNDERSTAND NUMBER OF POSITIVE ROOTS)
poly.fixed_pts_cfs = poly_1 + poly_2 + poly_3;

%% ROOTS OF POLYNOMIAL, FIXED POINTS
poly.poly_roots = roots(poly.fixed_pts_cfs);

end