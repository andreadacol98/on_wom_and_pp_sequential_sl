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

% MATRIX OF PLOT COLORS
color_mat = zeros(m,3);
color_mat(1,:) = [0 0.4470 0.7410];
color_mat(2,:) = [0.8500 0.3250 0.0980];
color_mat(3,:) = [0.9290 0.6940 0.1250];
color_mat(4,:) = [0.4940 0.1840 0.5560];
color_mat(5,:) = [0.6350 0.0780 0.1840];

%% FIGURE SETTINGS
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize', 14);
set(groot, 'DefaultTextFontSize', 25);                                     % Font size for axes labels and tick labels
set(groot, 'DefaultLegendFontSize', 25);                                   % Font size for text elements (titles, labels)
set(0, 'DefaultLegendLocation','Best');                                    % Font size for legend entries


%% CASCADE - PLOT PREDICTED MEAN AND 3 STANDARD DEVIATIONS (only last agent)
predicted_mean = param_distr.prediction.cascade.mean(end,2:end);
predicted_std_dev = sqrt(param_distr.prediction.cascade.var(end,2:end));

figure(11)

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = predicted_mean + 3 * predicted_std_dev;
xHat_3sM = predicted_mean - 3 * predicted_std_dev;
fill([time_vec, fliplr(1:k)], [xHat_3sP, fliplr(xHat_3sM)], color_mat(m,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
hold on;

% PLOT TRUE VALUE OF THE STATE
plot(time_vec, state_true(2:end), 'LineWidth', 1.5, Color=color_mat(end,:));

% PLOT POSTERIOR MEAN
plot(time_vec, predicted_mean, 'LineWidth', 1.5, Color = color_mat(m,:) ); %- [0.1,0.1,0.1]

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
% title("Predicted Mean -- Cascade", Interpreter="latex");
% xlabel("Time $[k]$", Interpreter="latex");
ylabel("Private Prior Setup", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k-1}^{3}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.33, 0.30]);
set(gcf,'color','w')


%% WoM - PLOT PREDICTED MEAN AND 3 STANDARD DEVIATIONS (only last agent)
predicted_mean = param_distr.prediction.WoM.mean(end,2:end);
predicted_std_dev = sqrt(param_distr.prediction.WoM.var(end,2:end));

figure(12)

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = predicted_mean + 3 * predicted_std_dev;
xHat_3sM = predicted_mean - 3 * predicted_std_dev;
fill([time_vec, fliplr(1:k)], [xHat_3sP, fliplr(xHat_3sM)], color_mat(m,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
hold on;

% PLOT TRUE VALUE OF THE STATE
plot(time_vec, state_true(2:end), 'LineWidth', 1.5, Color=color_mat(end,:));

% PLOT POSTERIOR MEAN
plot(time_vec, predicted_mean, 'LineWidth', 1.5, Color = color_mat(m,:) );  % - [0.1,0.1,0.1]

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
% title("Predicted Mean -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
ylabel("WoM Setup", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k-1}^{3}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.33, 0.3125]);
set(gcf,'color','w')



%% CASCADE - PLOT POSTERIOR MEAN AND 3 STANDARD DEVIATIONS (only last agent)
posterior_mean = param_distr.posterior.cascade.mean(end,:);
posterior_std_dev = sqrt(param_distr.posterior.cascade.var(end,:));

figure(13)

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = posterior_mean + 3 * posterior_std_dev;
xHat_3sM = posterior_mean - 3 * posterior_std_dev;
fill([time_vec_0, fliplr(0:k)], [xHat_3sP, fliplr(xHat_3sM)], color_mat(m,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
hold on;

% PLOT TRUE VALUE OF THE STATE
plot(time_vec_0, state_true, 'LineWidth', 1.5, Color=color_mat(end,:));

% PLOT POSTERIOR MEAN
plot(time_vec_0, posterior_mean, 'LineWidth', 1.5, Color = color_mat(m,:) ); % - [0.1,0.1,0.1]

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
% title("Posterior Mean -- Cascade", Interpreter="latex");
% xlabel("Time $[k]$", Interpreter="latex");
ylabel("Private Prior Setup", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k}^{3}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.33, 0.30]);
set(gcf,'color','w')


%% WoM - PLOT PREDICTED MEAN AND 3 STANDARD DEVIATIONS (only last agent)
posterior_mean = param_distr.posterior.WoM.mean(end,:);
posterior_std_dev = sqrt(param_distr.posterior.WoM.var(end,:));

figure(14)

% 3-STANDARD DEVIATIONS FROM THE POSTERIOR VARIANCE 
xHat_3sP = posterior_mean + 3 * posterior_std_dev;
xHat_3sM = posterior_mean - 3 * posterior_std_dev;
fill([time_vec_0, fliplr(0:k)], [xHat_3sP, fliplr(xHat_3sM)], color_mat(m,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
hold on;

% PLOT TRUE VALUE OF THE STATE
plot(time_vec_0, state_true, 'LineWidth', 1.5, Color=color_mat(end,:));

% PLOT POSTERIOR MEAN
plot(time_vec_0, posterior_mean, 'LineWidth', 1.5, Color = color_mat(m,:)); % - [0.1,0.1,0.1]

hold off; grid on;

% TITLE, LABELS, LEGEND, AXES LIMITS
% title("Posterior Mean -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
ylabel("WoM Setup", Interpreter="latex");
legend(["$$x_k$$", "$$\hat{x}_{k|k}^{3}$$"], Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.33, 0.3125]);
set(gcf,'color','w')

end