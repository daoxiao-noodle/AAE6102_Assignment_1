function [file, signal, acq, track, solu, cmn] = initParametersUrban()
%Purpose:
%   Parameter initialization
%Inputs: 
%	None
%Outputs:
%	file        - parameters related to the data file to be processed,a structure
%	signal      - parameters related to signals,a structure
%	acq         - parameters related to signal acquisition,a structure
%	track       - parameters related to signal tracking,a structure
%	solu        - parameters related to navigation solution,a structure
%	cmn         - parameters commmonly used,a structure
%--------------------------------------------------------------------------
%                           GPSSDR_vt v1.0
% 
% Written by B. XU and L. T. HSU


%% File parameters
file.fileName       = 'Urban'; 
file.fileRoute      = ['C:\data\',file.fileName,'.dat']; % Change the route of the raw IF data 
% file.fileName       = 'Opensky'; 
% file.fileRoute      = ['C:\data\',file.fileName,'.bin']; % Change the route of the raw IF data 
file.skip        	= 0; %5000;   	
file.fid           	 = fopen(file.fileRoute,'r','ieee-le');
file.skiptimeVT     = 100; %1000; % when vector tracking begins, unit: ms
file.dataType       = 2;    %1:I; 2:I/Q
file.dataPrecision  = 1;    %1:int8; 2; int16 


%% Signal parameters
signal.IF               = 0; % unit: Hz 
signal.Fs               = 26e6;	
% signal.IF               = 4.58e6; % unit: Hz 
% signal.Fs               = 58e6;	
signal.Fc               = 1575.42e6; 	
signal.codeFreqBasis	= 1.023e6;  	
signal.ms               = 1e-3; % unit: s
signal.Sample           = ceil(signal.Fs*signal.ms);	
signal.codelength       = signal.codeFreqBasis * signal.ms;


%% Acquisition parameters
acq.prnList     = 1:32;     % PRN list
acq.freqStep    = 500;      % unit: Hz
acq.freqMin     = -10000;   % Minimum Doppler frequency
acq.freqNum     = 2*abs(acq.freqMin)/acq.freqStep+1;    % number of frequency bins
acq.L           = 10;       % number of ms to perform FFT

%% Tracking parameters
track.CorrelatorSpacing  	= 0.5;  % unit: chip
track.DLLBW               	= 2;	% unit: Hz
track.DLLDamp           	= 0.707; 
track.DLLGain            	= 0.1;	
track.PLLBW              	= 20;  	
track.PLLDamp             	= 0.707;
track.PLLGain              	= 0.25; 	
track.msEph                 = 40000; % at least 30 seconds 
track.msPosCT               = 40000; % unit: ms
track.msToProcessCT       	= 40000; %40000; %90000; %5000; % unit: ms
track.msToProcessVT         = 5000; %90000; %5000; %
track.pdi                   = 1;


%% Navigation parameters
% initial position of the receiver
solu.iniPos	= [22.3198722/180 * pi, 114.209101777778/180 * pi, 3]; % data_20180930_KAITOK_dynamic_f 
%solu.iniPos	= [22.314/180 * pi, 114.206/180 * pi, 12.849]; % data_20180930_KAITOK_dynamic_f 
solu.cnslxyz = llh2xyz(solu.iniPos); % initial position in the Cartesian ECEF-frame
solu.rate  	= 1000; % unit: Hz
solu.navSolPeriod = 10; % unit: ms 
solu.iniVel = [0 0 0];% Ground truth velocity at HD_GPSL1 (FULL) localTime 264894.0
solu.flag_spaceUsr = 0; % 0:ground user; 1:spaceborne user, for tropo correction switching
solu.accel_navStateVT = 1; % 0:no accelerations as navigation states; 1:accelerations as navigation states in VTL EKF
solu.sat_dynamic = 0; % 0: no dynamic model involved; 1: satellite dynamic model aiding in VTL EKF
solu.iniCoeffAlpha_pos = 0.5; % Position weighting of VTL EKF in VTL+DM integration
solu.iniCoeffBeta_pos = 0.5; % Position weighting of DM in VTL+DM integration
solu.iniCoeffAlpha_vel = 0.5; % Velocity weighting of VTL EKF in VTL+DM integration
solu.iniCoeffBeta_vel = 0.5; % Velocity weighting of DM in VTL+DM integration
%% commonly used parameters
cmn.vtEnable  	= 1;            % 0: disable vector tracking; 1:enable vector tracking
cmn.cSpeed      = 299792458;    % speed of light, [m/s]
cmn.doy         = 158;       	% Day of year, 273, 282; 362 184;%
%cmn.doy         = 287;       	

%% ionospheirc model (from rinex)
global ALPHA BETA

% ALPHA = [0.1118e-07  0.7451e-08 -0.5960e-07 -0.5960e-07];% 2021/10/14
% BETA  = [0.9011e+05  0.1638e+05 -0.1966e+06 -0.6554e+05]; 

ALPHA = [0.1118e-07  0.7451e-08 -0.5960e-07 -0.5960e-07]; % 2019/06/07 
BETA  = [0.9011e+05  0.1638e+05 -0.1966e+06 -0.6554e+05];  

%ALPHA = [0.1024E-07  0.7451E-08 -0.5960E-07 -0.5960E-07]; % 2018/09/30 KAIT0K,HONGKONG
%BETA  = [0.8806E+05  0.0000E+00 -0.1966E+06 -0.6554E+05];
 
  