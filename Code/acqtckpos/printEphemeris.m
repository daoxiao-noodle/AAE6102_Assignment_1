function printEphemeris(ephemeris, prn) 
    % Check if ephemeris data exists for the given PRN
    if ~isfield(ephemeris, num2str(prn)) && isempty(ephemeris(prn))
        fprintf('Ephemeris data for PRN %d does not exist!\n', prn);
        return;
    end
    
    % Retrieve the ephemeris for the specified PRN
    eph = ephemeris(prn);
    
    % Output GPS ephemeris information
    fprintf('================ GPS Ephemeris for PRN %d =================\n', prn);
    
    % Time parameters
    fprintf('TOW (Time of Week)       : %s\n', num2str(eph.TOW));
    fprintf('GPS Week Number          : %d\n', eph.weeknum);
    fprintf('Toe (Ephemeris Time)     : %d sec\n', eph.toe);
    fprintf('Toc (Clock Data Time)    : %d sec\n', eph.toc);
    fprintf('TGD (Group Delay)        : %.10f sec\n', eph.TGD);
    
    % Orbital parameters
    fprintf('Semi-major Axis (√A)     : %.6f m^1/2\n', eph.sqrta);
    fprintf('Eccentricity (e)         : %.10f\n', eph.ecc);
    fprintf('Inclination (i0)         : %.10f rad\n', eph.i0);
    fprintf('RAAN (Ω)                 : %.10f rad\n', eph.omegae);
    fprintf('Argument of Perigee (ω)  : %.10f rad\n', eph.w);
    fprintf('Mean Anomaly (M0)        : %.10f rad\n', eph.M0);
    fprintf('Mean Motion Correction   : %.10e rad/s\n', eph.deltan);
    fprintf('Rate of RAAN (Ω̇)        : %.10e rad/s\n', eph.omegadot);
    fprintf('Inclination Rate (i̇)     : %.10e rad/s\n', eph.idot);

    % Satellite clock correction parameters
    fprintf('Clock Bias (af0)         : %.10e sec\n', eph.af0);
    fprintf('Clock Drift (af1)        : %.10e sec/sec\n', eph.af1);
    fprintf('Clock Drift Rate (af2)   : %.10e sec/sec²\n', eph.af2);
    
    % Orbit correction parameters
    fprintf('Crs (Radius Correction)  : %.4f m\n', eph.Crs);
    fprintf('Crc (Radius Correction)  : %.4f m\n', eph.Crc);
    fprintf('Cuc (Latitude Correction): %.10f rad\n', eph.Cuc);
    fprintf('Cus (Latitude Correction): %.10f rad\n', eph.Cus);
    fprintf('Cic (Inclination Corr.)  : %.10f rad\n', eph.Cic);
    fprintf('Cis (Inclination Corr.)  : %.10f rad\n', eph.Cis);

    % Satellite health status
    fprintf('Satellite Health         : %d (0 = Healthy)\n', eph.health);
    fprintf('IODC (Clock Data Issue)  : %d\n', eph.IODC);
    fprintf('IODE2 (Ephemeris Issue 2): %d\n', eph.IODE2);
    fprintf('IODE3 (Ephemeris Issue 3): %d\n', eph.IODE3);
    
    % Update information
    fprintf('Ephemeris Update Flag    : %d\n', eph.updateflag);
    fprintf('Update Time (ms)         : %s\n', num2str(eph.updatetime));
    fprintf('Update Time (TOW sec)    : %s\n', num2str(eph.updatetime_tow));
    
    fprintf('===========================================================\n\n');
end
