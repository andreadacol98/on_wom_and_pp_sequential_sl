function plot_variance(param_distr, param_console)
% plot_variance(param_distr, param_console) plots:
%
% 1) convergence of param_distr.posterior.cascade.var
% 2) convergence of param_distr.posterior.WoM.var

% EXTRACT PARAMETERS
k = param_console.k;
m = param_console.m;

% TIME VECTOR (with initial conditions)
time_vec = 1:k;
time_vec_0 = 0:k;

% LEGEND CELL ARRAY
legend_cell = cell(1, m);

%% PLOTTING POSTERIOR VARIANCE OF CASCADE ARCHITECTURE
figure(1);
for i = 1:m 
    legend_cell{1,i} = sprintf('$$P_k^{(%d)}$$', i);
    plot(time_vec_0, param_distr.posterior.cascade.var(i,:), 'LineWidth', 1.25);
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Posterior Variance -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");

%% PLOTTING POSTERIOR VARIANCE OF WoM ARCHITECTURE
figure(2);
for i = 1:m
    legend_cell{1,i} = sprintf('$$P_k^{(%d)}$$', i);
    plot(time_vec_0, param_distr.posterior.WoM.var(i,:), 'LineWidth', 1.25);
    hold on;
end
hold off; grid on;

% TITLE, LABELS, LEGEND
title("Posterior Variance -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");


%% PLOTTING GAIN OF CASCADE ARCHITECTURE
figure(3);
for i = 1:m
    legend_cell{1,i} = sprintf('$$K_k^{(%d)}$$', i);
    plot(time_vec, param_distr.gain.cascade(i,2:end), 'LineWidth', 1.25);
    hold on;
end
hold off; grid on; 
xlim([-inf, inf]); ylim([0, 1]);

% TITLE, LABELS, LEGEND
title("Kalman Gain -- Cascade", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");


%% PLOTTING GAIN OF WoM ARCHITECTURE
figure(4);
for i = 1:m
    legend_cell{1,i} = sprintf('$$K_k^{(%d)}$$', i);
    plot(time_vec, param_distr.gain.WoM(i,2:end), 'LineWidth', 1.25);
    hold on;
end
hold off; grid on;
xlim([-inf, inf]); ylim([0, 1]);

% TITLE, LABELS, LEGEND
title("Kalman Gain -- WoM", Interpreter="latex");
xlabel("Time $[k]$", Interpreter="latex");
legend(legend_cell, Interpreter="latex", Location="best");


end