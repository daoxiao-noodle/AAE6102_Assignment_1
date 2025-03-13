function llh = ecef2llh(ecef)
    % WGS-84 椭球参数
    a = 6378137.0;          % 长半轴
    e = 0.0818191908426;    % 第一偏心率

    x = ecef(:,1);
    y = ecef(:,2);
    z = ecef(:,3);
    
    lon = atan2d(y, x); % 计算经度
    
    % 计算纬度
    p = sqrt(x.^2 + y.^2);
    theta = atan2d(z * a, p * (1 - e^2));
    lat = atan2d(z + (e^2 * a / sqrt(1 - e^2)) * sind(theta).^3, ...
                 p - (e^2 * a * cosd(theta).^3));
    
    % 计算高度
    N = a ./ sqrt(1 - e^2 * sind(lat).^2);
    h = p ./ cosd(lat) - N;
    
    % 输出 LLH
    llh = [lat, lon, h];
end
