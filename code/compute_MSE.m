function MSE = compute_MSE(state_true, param_distr, param_console)

%% EXTRACT PARAMETERS
m = param_console.m;

%% DEFINE THE OUTPUT VARIABLE
MSE = struct;
MSE.posterior = struct;
MSE.posterior.cascade = zeros(m,1);
MSE.posterior.WoM = zeros(m,1);

%% COMPUTE THE MSE
n_samples = length(state_true);

% LOOP OVER THE AGENTS
for i = 1:m

    % CASCADE INTERCONNECTION
    error = state_true - param_distr.posterior.cascade.mean(i,:);
    MSE.posterior.cascade(i,1) = 1/n_samples *( error * error' );

    % WoM INTERCONNECTION
    error = (state_true - param_distr.posterior.WoM.mean(i,:));
    MSE.posterior.WoM(i,1) = 1/n_samples *( error * error' );
    
end

end