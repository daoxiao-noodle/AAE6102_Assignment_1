function PointPlot_ENU(navSolutionsCT) 
% Function to plot estimated positions in ENU (East-North-Up) coordinates
% Inputs:
%   navSolutionsCT - Structure containing estimated ENU positions

% Create scatter plot for estimated positions
figure;
hold on;
time = navSolutionsCT.localTime;
East = navSolutionsCT.usrPosENU(:,1); % Estimated East coordinate
North = navSolutionsCT.usrPosENU(:,2); % Estimated North coordinate
Up = navSolutionsCT.usrPosENU(:,3); % Estimated Up coordinate

% Compute mean positions
meanEast  = mean(East);
meanNorth = mean(North);
meanUp    = mean(Up);

% Reference position (origin)
EastRef = 0;
NorthRef = 0;

% Plot estimated positions (blue dots)
scatter(East, North, 'b.', 'DisplayName', 'Estimated Position');

% Plot reference position (red dot)
scatter(EastRef, NorthRef, 100, 'r', 'filled', 'DisplayName', 'Ground Truth');

% Set axis labels
xlabel('East (meter)');
ylabel('North (meter)');

% Show legend
legend('Location', 'best');

% Set figure title
title('Positioning Error');

% Enable grid with light gray color and transparency
grid on; 
set(gca, 'GridColor', [0.8, 0.8, 0.8], 'GridAlpha', 0.5);

hold off;

% ENU coordinate variations over time
figure;
hold on;
plot(time, East - meanEast, 'b-', 'DisplayName', 'East'); % East variation
plot(time, North - meanNorth, 'r-', 'DisplayName', 'North'); % North variation
plot(time, Up - meanUp, 'g-', 'DisplayName', 'Up'); % Up variation
hold off;

% Set labels and title
xlabel('Local Time (ms)');
ylabel('Coordinate Variations (m)');
legend('Location', 'best');
title('Coordinate Variations Over Time (WLS)');

grid on;
end
