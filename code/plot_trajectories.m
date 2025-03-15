function plot_trajectories(trajectories, param_console)
% plot_trajectories(param_distr, param_console) plots:
%
% 1) convergence of trajectories.cascade.posteriors.var
% 2) convergence of trajectories.WoM.posteriors.WoM.var

% EXTRACT PARAMETERS
k = param_console.k;
m = param_console.m;

% TIME VECTOR (with initial conditions)
time_vec = 1:k;
time_vec_0 = 0:k;

% LEGEND CELL ARRAY
legend_cell = cell(1, m);

% COLORS CELL ARRAY
color_cell = cell(1,m); color_cell = {"#000000"};
color_cell{1,1} = "#0072BD";
color_cell{1,2} = "#D95319";
color_cell{1,3} = "#EDB120";
color_cell{1,4} = "#7E2F8E";




%% PLOTTING PREDICTION VARIANCE OF CASCADE ARCHITECTURE
figure(5);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$P_{k | k-1}^{(%d)}$$', i);
    plot(time_vec, squeeze(trajectories.cascade.predictions.var(i,2:end,:)), 'LineWidth', 1.25, Color=color_cell{1,i});
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Predicted Variance -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);

%% PLOTTING PREDICTION VARIANCE OF WoM ARCHITECTURE
figure(6);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$P_{k | k-1}^{(%d)}$$', i);
    plot(time_vec, squeeze(trajectories.WoM.predictions.var(i,2:end,:)), 'LineWidth', 1.25, Color=color_cell{1,i});
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Predicted Variance -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);




%% PLOTTING POSTERIOR VARIANCE OF CASCADE ARCHITECTURE
figure(7);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$P_{k | k}^{(%d)}$$', i);
    plot(time_vec_0, squeeze(trajectories.cascade.posteriors.var(i,:,:)), 'LineWidth', 1.25, Color=color_cell{1,i});
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Posterior Variance -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);

%% PLOTTING POSTERIOR VARIANCE OF WoM ARCHITECTURE
figure(8);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$P_{k | k}^{(%d)}$$', i);
    plot(time_vec_0, squeeze(trajectories.WoM.posteriors.var(i,:,:)), 'LineWidth', 1.25, Color=color_cell{1,i});
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Posterior Variance -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);





%% PLOTTING GAIN OF CASCADE ARCHITECTURE
figure(9);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$K_{k}^{(%d)}$$', i);
    plot(time_vec, squeeze(trajectories.cascade.gain(i,2:end,:)), 'LineWidth', 1.25, Color=color_cell{1,i});
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Kalman Gain -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);

%% PLOTTING GAIN OF WoM ARCHITECTURE
figure(10);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$K_{k}^{(%d)}$$', i);
    plot(time_vec, squeeze(trajectories.WoM.gain(i,2:end,:)), 'LineWidth', 1.25, Color=color_cell{1,i});
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Kalman Gain -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");
xlim([-inf, inf]); ylim([-inf, inf]);



end