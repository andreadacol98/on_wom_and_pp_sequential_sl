function plot_variance_trajectories(trajectories, param_console)
% plot_trajectories(param_distr, param_console) plots:
%
% 1) convergence of trajectories.cascade.posteriors.var
% 2) convergence of trajectories.WoM.posteriors.WoM.var

% EXTRACT PARAMETERS
k = param_console.k;
m = param_console.m;
n_ic = trajectories.n_ic;

% TIME VECTOR (with initial conditions)
time_vec = 1:k;
time_vec_0 = 0:k;

% LEGEND CELL ARRAY
legend_cell = cell(1, m);

% COLOR CELL MATRIX
color_mat = zeros(m,3);
color_mat(1,:) = [0 0.4470 0.7410];
color_mat(2,:) = [0.8500 0.3250 0.0980];
color_mat(3,:) = [0.9290 0.6940 0.1250];
color_mat(4,:) = [0.4940 0.1840 0.5560];

%% FIGURE SETTINGS
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'DefaultAxesFontSize', 18);
set(groot, 'DefaultTextFontSize', 28);                                     % Font size for axes labels and tick labels
set(groot, 'DefaultLegendFontSize', 28);                                   % Font size for text elements (titles, labels)
set(0, 'DefaultLegendLocation','Best');                                    % Font size for legend entries


%% PLOTTING PREDICTION VARIANCE OF CASCADE ARCHITECTURE
figure(5);
for j = 1:n_ic
    for i = 1:m 
        legend_cell{1,i} = sprintf('$$p_{k | k-1}^{%d}$$', i);
        plot(time_vec, squeeze(trajectories.cascade.predictions.var(i,2:end,j)), '-o', MarkerFaceColor=color_mat(i,:), Color = color_mat(i,:), LineWidth=1.1, MarkerSize=2.5);
        hold on;
    end
end

% Fill the space in between
for i = 1:m
    fill([time_vec, fliplr(1:k)], [trajectories.cascade.predictions.var(i,2:end,end), fliplr(trajectories.cascade.predictions.var(i,2:end,1))], color_mat(i,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end

hold off; grid on;

% TITLE, LABELS, LEGEND
% title("Private Prior Setup", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
ylabel("Private Prior Setup", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.33, 0.3125]);
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf,'color','w')

%% PLOTTING PREDICTION VARIANCE OF WoM ARCHITECTURE
figure(6);
for j = 1:n_ic
    for i = 1:m 
        legend_cell{1,i} = sprintf('$$p_{k | k-1}^{%d}$$', i);
        plot(time_vec, squeeze(trajectories.WoM.predictions.var(i,2:end,j)), '-o', MarkerFaceColor=color_mat(i,:), Color=color_mat(i,:), LineWidth=1.1, MarkerSize=2.5);
        hold on;
    end
end

% Fill the space in between
for i = m
    fill([time_vec, fliplr(1:k)], [trajectories.WoM.predictions.var(i,2:end,end), fliplr(trajectories.WoM.predictions.var(i,2:end,1))], color_mat(i,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end

hold off; grid on;

% TITLE, LABELS, LEGEND
% title("WoM Setup", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
ylabel("WoM Setup", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.33, 0.3125]);
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf,'color','w')



%% PLOTTING POSTERIOR VARIANCE OF CASCADE ARCHITECTURE
figure(7);
for j = 1:n_ic
    for i = 1:m 
        legend_cell{1,i} = sprintf('$$p_{k | k}^{%d}$$', i);
        plot(time_vec_0, squeeze(trajectories.cascade.posteriors.var(i,:,j)), '-o', MarkerFaceColor=color_mat(i,:), Color=color_mat(i,:), LineWidth=1.1, MarkerSize=2.5);
        hold on;
    end
end

% Fill the space in between
for i = 1:m
    fill([time_vec_0, fliplr(0:k)], [trajectories.cascade.posteriors.var(i,1:end,end), fliplr(trajectories.cascade.posteriors.var(i,1:end,1))], color_mat(i,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end

hold off; grid on;

% TITLE, LABELS, LEGEND
title("Private Prior Setup", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
% ylabel("Private Prior Setup", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.424, 0.85]);
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf,'color','w')

%% PLOTTING POSTERIOR VARIANCE OF WoM ARCHITECTURE
figure(8);
for j = 1:n_ic
    for i = 1:m 
        legend_cell{1,i} = sprintf('$$p_{k | k}^{%d}$$', i);
        plot(time_vec_0, squeeze(trajectories.WoM.posteriors.var(i,:,j)), '-o', MarkerFaceColor=color_mat(i,:), Color=color_mat(i,:), LineWidth=1.1, MarkerSize=2.5);
        hold on;
    end
end

% Fill the space in between
for i = 1:m
    fill([time_vec_0, fliplr(0:k)], [trajectories.WoM.posteriors.var(i,1:end,end), fliplr(trajectories.WoM.posteriors.var(i,1:end,1))], color_mat(i,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end

hold off; grid on;

% TITLE, LABELS, LEGEND
title("WoM Setup", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
% ylabel("WoM Setup", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.424, 0.85]);
xlim([-inf, inf]); ylim([-inf, inf]);
set(gcf,'color','w')




%% PLOTTING GAIN OF CASCADE ARCHITECTURE
figure(9);
for j = 1:n_ic
    for i = 1:m 
        legend_cell{1,i} = sprintf('$\\alpha_{k}^{%d}$', i);
        plot(time_vec, squeeze(trajectories.cascade.gain(i,2:end,j)), '-o', MarkerFaceColor=color_mat(i,:), Color=color_mat(i,:), LineWidth=1.1, MarkerSize=2.5);
        hold on;
    end
end

% Fill the space in between
for i = 1:m
    fill([time_vec, fliplr(1:k)], [trajectories.cascade.gain(i,2:end,end), fliplr(trajectories.cascade.gain(i,2:end,1))], color_mat(i,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end

hold off; grid on;

% TITLE, LABELS, LEGEND
title("Private Prior Setup", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
% ylabel("Private Prior Setup", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.424, 0.85]);
xlim([-inf, inf]); ylim([-inf, 1]);
set(gcf,'color','w')

%% PLOTTING GAIN OF WoM ARCHITECTURE
figure(10);
for j = 1:n_ic
    for i = 1:m 
        legend_cell{1,i} = sprintf('$\\alpha_{k}^{%d}$', i);
        plot(time_vec, squeeze(trajectories.WoM.gain(i,2:end,j)), '-o', MarkerFaceColor=color_mat(i,:), Color=color_mat(i,:), LineWidth=1.1, MarkerSize=2.5);
        hold on;
    end
end

% Fill the space in between
for i = 1:m
    fill([time_vec, fliplr(1:k)], [trajectories.WoM.gain(i,2:end,end), fliplr(trajectories.WoM.gain(i,2:end,1))], color_mat(i,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'HandleVisibility', 'off');
end

hold off; grid on;

% TITLE, LABELS, LEGEND
title("WoM Setup", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
% ylabel("WoM Setup", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, 1]);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.424, 0.85]);
set(gcf,'color','w')


end