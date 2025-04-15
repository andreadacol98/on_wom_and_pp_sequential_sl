function MSE = compute_MSE(state_true, param_distr, param_console)

%% EXTRACT PARAMETERS
m = param_console.m;

%% DEFINE THE OUTPUT VARIABLE
MSE = struct;
MSE.prediction = struct;
MSE.prediction.cascade = zeros(m,1);
MSE.prediction.WoM = zeros(m,1);

%% COMPUTE THE MSE (of the predictions!)
state_true = state_true(2:end);
n_samples = length(state_true);

% LOOP OVER THE AGENTS
for i = 1:m

    % CASCADE INTERCONNECTION
    error = state_true - param_distr.prediction.cascade.mean(i,2:end);
    MSE.prediction.cascade(i,1) = 1/n_samples *( error * error' );

    % WoM INTERCONNECTION
    error = (state_true - param_distr.prediction.WoM.mean(i,2:end));
    MSE.prediction.WoM(i,1) = 1/n_samples *( error * error' );
    
end

end