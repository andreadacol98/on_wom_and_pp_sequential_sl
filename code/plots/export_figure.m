% Open the figure
fig = openfig('prediction_var_WoM.fig'); % Select the desired .fig file
ax = gca; % Get the current axes

% Ensure the figure/axes units are in normalized coordinates
fig.Units = 'normalized';
ax.Units = 'normalized';

% Calculate the new position using TightInset margins
ti = ax.TightInset; % [left, bottom, right, top]
outerpos = ax.OuterPosition;

% Adjust axes position to trim borders
ax.Position = [ ...
  outerpos(1) + ti(1), ...       % Left: shifted right by left inset
  outerpos(2) + ti(2), ...       % Bottom: shifted up by bottom inset
  outerpos(3) - ti(1) - ti(3), ... % Width: reduced by left + right insets
  outerpos(4) - ti(2) - ti(4) - 0.01 ...  % Height: reduced by bottom + top insets
];

% (Optional) Remove extra whitespace in the saved figure
fig.PaperPositionMode = 'auto'; % Preserve the on-screen size
set(fig, 'InvertHardcopy', 'off'); % Keep background color if changed

% Save the trimmed figure
savefig(fig, 'trimmed_figure.fig'); % Save as .fig
