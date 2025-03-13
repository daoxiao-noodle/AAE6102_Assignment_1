function VEL_Plot_ENU(navSolutionsCT)
% Function to plot velocity components in ENU (East-North-Up) coordinates
% Inputs:
%   navSolutionsCT - Structure containing estimated ENU velocities

figure;
hold on;
time = navSolutionsCT.localTime;
VelEast = navSolutionsCT.usrVelENU(:,1); % Estimated velocity in the East direction
VelNorth = navSolutionsCT.usrVelENU(:,2); % Estimated velocity in the North direction
VelUp = navSolutionsCT.usrVelENU(:,3); % Estimated velocity in the Up direction

% Plot velocity components over time
plot(time, VelEast, 'b-', 'DisplayName', 'Vel_X'); % Velocity in East direction
plot(time, VelNorth, 'r-', 'DisplayName', 'Vel_Y'); % Velocity in North direction
plot(time, VelUp, 'g-', 'DisplayName', 'Vel_Z'); % Velocity in Up direction

hold off;

% Set axis labels
xlabel('Local Time (ms)');
ylabel('Velocity (m/s)');

% Show legend
legend('Velocity X', 'Velocity Y', 'Velocity Z');

% Set figure title
title('Velocity Components Over Time (WLS)');

% Enable grid
grid on;
end
