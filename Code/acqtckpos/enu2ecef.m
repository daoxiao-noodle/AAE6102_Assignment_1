function ecef = enu2ecef(enu, refECEF, refLLH)
    % ENU -> ECEF 坐标转换
    lat = refLLH(1);
    lon = refLLH(2);
    
    % 计算旋转矩阵
    sin_lat = sind(lat);
    cos_lat = cosd(lat);
    sin_lon = sind(lon);
    cos_lon = cosd(lon);

    R = [ -sin_lon,  cos_lon, 0;
          -sin_lat*cos_lon, -sin_lat*sin_lon, cos_lat;
           cos_lat*cos_lon,  cos_lat*sin_lon, sin_lat];

    % 计算 ECEF 坐标
    ecef = (R' * enu')' + refECEF;
end
