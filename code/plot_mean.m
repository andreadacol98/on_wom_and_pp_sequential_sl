function plot_mean(state_true, param_distr, param_console)
% plot_mean(param_distr, param_console) plots:
%
% 1) convergence of param_distr.posterior.cascade.mean
% 2) convergence of param_distr.posterior.WoM.mean

% EXTRACT PARAMETERS
k = param_console.k;
m = param_console.m;

% TIME VECTOR (with initial conditions)
time_vec = 1:k;
time_vec_0 = 0:k;

%% CASCADE - PLOT PREDICTED MEAN AND 3 STANDARD DEVIATIONS (only last agent)
predicted_mean = param_distr.prediction.cascade.mean(end,2:end);
predicted_std_dev = sqrt(param_distr.prediction.cascade.var(end,2:end));

figure(11)

% PLOT TRUE VALUE OF THE STATE
plot(time_vec, state_true(2:end), 'LineWidth', 1, Color=[0.6350 0.0780 0.1840]);
hold on;

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = predicted_mean + 3 * predicted_std_dev;
xHat_3sM = predicted_mean - 3 * predicted_std_dev;
fill([time_vec, fliplr(1:k)], [xHat_3sP, fliplr(xHat_3sM)], [0.7500 0.250 0.0880], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% PLOT POSTERIOR MEAN
plot(time_vec, predicted_mean, 'LineWidth', 1, Color = [0.8500 0.3250 0.0980]);

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
title("Predicted Mean -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k-1}^{(2)}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);


%% WoM - PLOT PREDICTED MEAN AND 3 STANDARD DEVIATIONS (only last agent)
predicted_mean = param_distr.prediction.WoM.mean(end,2:end);
predicted_std_dev = sqrt(param_distr.prediction.WoM.var(end,2:end));

figure(12)

% PLOT TRUE VALUE OF THE STATE
plot(time_vec, state_true(2:end), 'LineWidth', 1, Color=[0.6350 0.0780 0.1840]);
hold on;

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = predicted_mean + 3 * predicted_std_dev;
xHat_3sM = predicted_mean - 3 * predicted_std_dev;
fill([time_vec, fliplr(1:k)], [xHat_3sP, fliplr(xHat_3sM)], [0.7500 0.250 0.0880], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% PLOT POSTERIOR MEAN
plot(time_vec, predicted_mean, 'LineWidth', 1, Color = [0.8500 0.3250 0.0980]);

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
title("Predicted Mean -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k-1}^{(2)}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);




%% CASCADE - PLOT POSTERIOR MEAN AND 3 STANDARD DEVIATIONS (only last agent)
posterior_mean = param_distr.posterior.cascade.mean(end,:);
posterior_std_dev = sqrt(param_distr.posterior.cascade.var(end,:));

figure(13)

% PLOT TRUE VALUE OF THE STATE
plot(time_vec_0, state_true, 'LineWidth', 1, Color=[0.6350 0.0780 0.1840]);
hold on;

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = posterior_mean + 3 * posterior_std_dev;
xHat_3sM = posterior_mean - 3 * posterior_std_dev;
fill([time_vec_0, fliplr(0:k)], [xHat_3sP, fliplr(xHat_3sM)], [0.7500 0.250 0.0880], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% PLOT POSTERIOR MEAN
plot(time_vec_0, posterior_mean, 'LineWidth', 1, Color = [0.8500 0.3250 0.0980]);

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
title("Posterior Mean -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k}^{(2)}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);


%% WoM - PLOT PREDICTED MEAN AND 3 STANDARD DEVIATIONS (only last agent)
posterior_mean = param_distr.posterior.WoM.mean(end,:);
posterior_std_dev = sqrt(param_distr.posterior.WoM.var(end,:));

figure(14)

% PLOT TRUE VALUE OF THE STATE
plot(time_vec_0, state_true, 'LineWidth', 1, Color=[0.6350 0.0780 0.1840]);
hold on;

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = posterior_mean + 3 * posterior_std_dev;
xHat_3sM = posterior_mean - 3 * posterior_std_dev;
fill([time_vec_0, fliplr(0:k)], [xHat_3sP, fliplr(xHat_3sM)], [0.7500 0.250 0.0880], 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');

% PLOT POSTERIOR MEAN
plot(time_vec_0, posterior_mean, 'LineWidth', 1, Color = [0.8500 0.3250 0.0980]);

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
title("Posterior Mean -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k}^{(2)}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);

end