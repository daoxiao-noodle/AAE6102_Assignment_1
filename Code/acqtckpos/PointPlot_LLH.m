function PointPlot_LLH(navSolutions, iniPos)
% Function to plot GPS estimated positions on a geographic map
% Inputs:
%   navSolutions - Structure containing estimated GPS positions
%   iniPos - Reference position [latitude, longitude, altitude] in radians

% Extract latitude, longitude, and altitude from estimated positions
latitudes = navSolutions.usrPosLLH(:,1); % Estimated latitude
longitudes = navSolutions.usrPosLLH(:,2); % Estimated longitude
altitudes = navSolutions.usrPosLLH(:,3); % Estimated altitude

% Convert reference position from radians to degrees
RefLat = iniPos(1) * 180 / pi;
RefLon = iniPos(2) * 180 / pi;
RefAlt = iniPos(3) * 180 / pi;

% Create geographic map
figure;
geoscatter(latitudes, longitudes, 20, 'b', 'filled', 'DisplayName', 'Estimated Position');
hold on;

% Plot reference position as a red dot
geoscatter(RefLat, RefLon, 100, 'r', 'filled', 'DisplayName', 'Ground Truth');

% Set satellite basemap
geobasemap('satellite'); % Options: 'satellite', 'topographic', 'streets'

% Set title
title('Position Results on Geographic Map');

% Display legend
legend('Location', 'best');

hold off;
end
