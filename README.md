# GNSS SDR Processing Report

## Usage
The script includes two configurations for different input data scenarios, Open Sky and Urban, which are initialized by `initParametersOpenSky.m` and `initParametersUrban.m` respectively. And then run the `SDR_main.m` script.

## Task 1 – Acquisition
Process the IF data using a GNSS SDR and generate the initial acquisition results. The corresponding implementation can be found in the `acquisition.m` file. The following figure presents the SNR acquisition results.

### Opensky:
<div align="center">
    <img src="/Figure/Acquisition_OpenSky.png" width="400">
</div>

### Urban:
<div align="center">
    <img src="/Figure/Acquisition_Urban.png" width="400">
</div>

## Task 2 – Tracking
Adapt the tracking loop (DLL) to generate correlation plots and analyze the tracking performance. The corresponding implementation can be found in the `trackingCT.m` file.
- Measure the correlation at different code phase offsets within the range of [-0.5, 0.5], implementing multiple correlators with a correlation spacing of 0.1.
- Set the tracking duration to 40 seconds to obtain the correlation distribution of satellites in each dataset at various code phase offsets.
- For each satellite, plot the correlation curve every second, as shown in the figure: `Figure/Correlation_Dataset_PRN X.png` (e.g., `Figure/Correlation_OpenSky_PRN3.png`).
- For all the satellites acquired in each dataset, plot the correlation curve every 5 seconds, shown as follows:
#### Opensky:
<div align="center">
    <img src="/Figure/Correlation_OpenSky Dataset.png" width="400">
</div>

#### Urban:
<div align="center">
    <img src="/Figure/Correlation_Urban Dataset.png" width="400">
</div>
  
### Discuss the impact of urban interference on the correlation peaks
- The OpenSky dataset exhibits a narrow correlation peak, indicating high signal quality, stable DLL (Delay Lock Loop) code tracking, and strong signal correlation. The low sidelobes suggest minimal multipath effects, meaning the signal propagation is more direct with fewer reflections.

- In contrast, the Urban dataset shows a broader correlation peak, especially for PRN 18, as illustrated in the figure below. This suggests lower code phase estimation accuracy and significant signal interference. The higher sidelobes indicate stronger multipath effects, with multiple overlapping signal paths.

- Due to obstructions, reflections, absorption, scattering, and diffraction caused by buildings, trees, vehicles, and other urban structures, the multipath and non-line-of-sight (NLOS) effects are significantly more pronounced in urban environments than in open areas. Additionally, the correlation peak in the Urban dataset is noticeably higher than in the OpenSky dataset, which could be attributed to differences in receiver antenna gain and noise figure.

<div align="center">
    <img src="/Figure/Correlation_Urban_PRN18.png" width="400">
</div>

## Task 3 – Navigation Data Decoding
Decode the navigation message and extract key parameters, such as ephemeris data, for at least one satellite.
The corresponding implementation can be found in the `naviDecode.m` file. 
### Opensky:
Ephemeris data for multiple satellites (PRN 3, 4, 16, 22, 26, 27, 31, 32).
| Parameter      | Description                               | PRN 3            | PRN 4            | PRN 16           | PRN 22           | PRN 26           | PRN 27           | PRN 31           | PRN 32           |
|---------------|------------------------------------------|------------------|------------------|------------------|------------------|------------------|------------------|------------------|------------------|
| TOW      | Time of Week (s)                       | 390120           | 390120           | 390120           | 390120           | 390120           | 390120           | 390120           | 390120           |
| sfb      | Subframe ID                            | 829              | 830              | 831              | 831              | 829              | 831              | 831              | 831              |
| weeknum   | GPS Week Number                          | 1155             | 1155             | 1155             | 1155             | 1155             | 1155             | 1155             | 1155             |
| IODC      | Issue of Data, Clock                     | 56               | 167              | 9                | 22               | 113              | 30               | 83               | 59               |
| TGD       | Group Delay (s)                          | 1.86264514923096e-09 | -4.19095158576965e-09 | -1.02445483207703e-08 | -1.76951289176941e-08 | 6.98491930961609e-09 | 1.86264514923096e-09 | -1.30385160446167e-08 | 4.65661287307739e-10 |
| toc       | Clock Reference Time (s)                 | 396000           | 396000           | 396000           | 396000           | 396000           | 396000           | 396000           | 396000           |
| af2       | Clock Drift Rate (s/s²)                  | 0                | 0                | 0                | 0                | 0                | 0                | 0                | 0                |
| af1       | Clock Drift (s/s)                        | -1.37561073643155e-11 | 4.54747350886464e-13 | -6.36646291241050e-12 | 9.20863385545090e-12 | 3.97903932025656e-12 | -5.00222085975111e-12 | -1.93267624126747e-12 | -4.09272615797818e-12 |
| af0       | Clock Bias (s)                           | -0.000324650201946497 | -0.000203651376068592 | -0.000406925100833178 | -0.000489471945911646 | 0.000144790392369032 | -0.000206120777875185 | -0.000144899822771549 | -1.01206824183464e-05 |
| IODE2     | Issue of Data, Ephemeris                 | 56               | 167              | 9                | 22               | 113              | 30               | 83               | 58               |
| Crs       | Radius Correction Term (m)               | -111.15625       | -40.3125         | 23.34375         | -99.8125         | 21.25            | 70.4375          | 30.71875         | -32              |
| deltan    | Mean Motion Difference (rad/s)           | 4.40196907396673e-09 | 4.36946772015489e-09 | 4.24660545959144e-09 | 5.28307720422847e-09 | 5.05128183473521e-09 | 4.03016787266861e-09 | 4.80734310227929e-09 | 4.58054794106478e-09 |
| M0        | Mean Anomaly at Reference Time (rad)     | 2.7466415762807  | -0.56946766593979 | 0.718116855169471 | -1.26096558850673 | 1.73557093431869 | -0.173022280718201 | 2.82452321963232 | 0.579939454451814 |
| Cuc       | Latitude Correction Term (rad)           | -5.73135912418365e-06 | -2.18488276004791e-06 | 1.38953328132629e-06 | -5.15580177307129e-06 | 1.15297734737396e-06 | 3.73087823390961e-06 | 1.46031379699707e-06 | -1.63912773132324e-06 |
| ecc       | Eccentricity                             | 0.00388247426599264 | 0.00145191792398691 | 0.0122962790774181 | 0.00671353843063116 | 0.00625350861810148 | 0.0095741068944335 | 0.0102715539978817 | 0.00513400882482529 |
| Cus       | Argument of Perigee Correction Term      | 6.02193176746368e-06 | 1.07884407043457e-05 | 7.68713653087616e-06 | 5.16511499881744e-06 | 7.04079866409302e-06 | 8.24220478534698e-06 | 7.22892582416534e-06 | 1.05444341897964e-05 |
| sqrta     | Square Root of Semi-Major Axis (m^0.5)   | 5153.75657081604 | 5153.69046783447 | 5153.77132225037 | 5153.71227264404 | 5153.63645935059 | 5153.65202140808 | 5153.62238883972 | 5153.73119544983 |
| toe       | Time of Ephemeris (s)                    | 396000           | 396000           | 396000           | 396000           | 396000           | 396000           | 396000           | 396000           |
| omegae    | Right Ascension of Ascending Node (rad)  | 1.37716785453468 | 2.45848997315267 | -1.6742614288517 | 1.27273532182622 | -1.81293070066347 | -0.717474660465198 | -2.78727290293283 | 2.41718333718263 |
| i0        | Inclination Angle at Reference Time (rad) | 0.970650171544315 | 0.960892029581391 | 0.971603403113093 | 0.936454582863645 | 0.939912327258293 | 0.974727542206026 | 0.955882550425048 | 0.957701079019777 |
| w         | Argument of Perigee (rad)                | 0.999580010005351 | -3.09959920683989 | 0.679609496852004 | -0.887886685712925 | 0.295685419113131 | 0.630881664719349 | 0.311626182035606 | -2.38400616184867 |
| updatetime| Update Time (s)                          | 34720            | 34740            | 34760            | 34760            | 34720            | 34760            | 34760            | 34760            |

---

### Urban:
Ephemeris data for multiple satellites (PRN 1, 3, 7, 11).
| Parameter  | Description | PRN 1 | PRN 3 | PRN 7 | PRN 11 |
|------------|--------------------------------|----------------------|----------------------|----------------------|----------------------|
| TOW | Time of Week (s) | 449370 | 449370 | 449370 | 449370 |
| sfb | Subframe ID | 804 | 805 | 801 | 804 |
| weeknum | GPS Week Number | 1032 | 1032 | 1032 | 1032 |
| IODC | Issue of Data, Clock | 72 | 72 | 33 | 83 |
| TGD | Group Delay (s) | 5.58793544769287e-09 | 1.86264514923096e-09 | -1.11758708953857e-08 | -1.25728547573090e-08 |
| toc | Clock Reference Time (s) | 453600 | 453600 | 453600 | 453600 |
| af2 | Clock Drift Rate (s/s²) | 0 | 0 | 0 | 0 |
| af1 | Clock Drift (s/s) | -9.43600753089413e-12 | -1.13686837721616e-12 | -7.61701812734827e-12 | 8.52651282912120e-12 |
| af0 | Clock Bias (s) | -3.48975881934166e-05 | 0.000186326447874308 | -3.95108945667744e-05 | -0.000590092502534389 |
| IODE2 | Issue of Data, Ephemeris | 72 | 72 | 33 | 83 |
| Crs | Radius Correction Term (m) | -120.71875 | -62.09375 | 6.46875 | -67.125 |
| deltan | Mean Motion Difference (rad/s) | 4.19088885305685e-09 | 4.44768526394383e-09 | 4.89163232754956e-09 | 5.89095966783021e-09 |
| M0 | Mean Anomaly at Reference Time (rad) | 0.517930887728971 | -0.430397463873374 | -0.0807435368238342 | -0.198905418191912 |
| Cuc | Latitude Correction Term (rad) | -6.33485615253448e-06 | -3.09012830257416e-06 | 3.09199094772339e-07 | -3.60421836376190e-06 |
| ecc | Eccentricity | 0.00892308494076133 | 0.00222623045556247 | 0.0128239667974412 | 0.0166431387187913 |
| Cus | Argument of Perigee Correction Term | 5.30108809471130e-06 | 1.15595757961273e-05 | 8.01496207714081e-06 | 1.51246786117554e-06 |
| sqrta | Square Root of Semi-Major Axis (m^0.5) | 5153.65564346313 | 5153.77780151367 | 5153.74233818054 | 5153.70659637451 |
| toe | Time of Ephemeris (s) | 453600 | 453600 | 453600 | 453600 |
| Cic | Inclination Correction Term (rad) | -7.45058059692383e-08 | 1.11758708953857e-08 | 4.28408384323120e-08 | -3.16649675369263e-07 |
| omegae | Right Ascension of Ascending Node (rad) | -3.10603580061843 | -2.06417843827737 | 0.0440838835392694 | 2.7257703756657 |
| Cis | Inclination Correction Term (rad) | 1.60187482833862e-07 | 5.21540641784668e-08 | 1.26659870147705e-07 | -1.32247805595398e-07 |
| i0 | Inclination Angle at Reference Time (rad) | 0.976127704025529 | 0.962858745925878 | 0.955765376538571 | 0.909806735685277 |
| Crc | Orbit Radius Correction Term (m) | 287.46875 | 160.3125 | 219.59375 | 324.40625 |
| w | Argument of Perigee (rad) | 0.71149759851372 | 0.594974558438531 | -2.46195417194188 | 1.89149296226272 |
| omegadot | Rate of Right Ascension (rad/s) | -8.16962601200122e-09 | -7.83246911092012e-09 | -8.27820196319683e-09 | -9.30431613354218e-09 |
| IODE3 | Issue of Data, Ephemeris | 72 | 72 | 33 | 83 |
| idot | Inclination Rate (rad/s) | -1.81078971237415e-10 | 4.81091467962125e-10 | -6.86814322859069e-10 | 1.28576784310590e-11 |
| updatetime | Update Time (s) | 34220 | 34240 | 34160 | 34220 |

---

## Task 4 – Position and Velocity Estimation
Using pseudorange measurements from tracking, implement the Weighted Least Squares (WLS) algorithm to compute the user's position and velocity.

$\beta = (H^T W H)^{-1} H^T W y$

The weight matrix W is constructed based on the Carrier-to-Noise Ratio (C/N0) and satellite elevation angles (el).  
The corresponding implementation can be found in the `tracking_POS_WLS.m` file.

### Plot the user position and velocity. Compare the results with the ground truth.
#### Opensky:
##### Position:
<div align="center">
    <img src="/Figure/LLH_OpenSky_WLS.png" height="300">
    <img src="/Figure/ENU_OpenSky_WLS.png" height="300">
    <img src="/Figure/ENU_Variations_OpenSky_WLS.png" height="300">
</div>

##### Velocity:
<div align="center">
    <img src="/Figure/Velocity_OpenSky_WLS.png" width="400">
</div>

#### Urban:
##### Position:
<div align="center">
    <img src="/Figure/LLH_Urban_WLS.png" height="300">
    <img src="/Figure/ENU_Urban_WLS.png" height="300">
    <img src="/Figure/ENU_Variations_Urban_WLS.png" height="300">
</div>

#### Velocity:
<div align="center">
    <img src="/Figure/Velocity_Urban_WLS.png" width="400">
</div>

### Discuss the impact of multipath effects on the WLS solution
- In the OpenSky dataset, the WLS-computed coordinates exhibit minimal variations, with error distributions remaining relatively concentrated. The velocity curves are stable with minor fluctuations, indicating high signal quality. In open environments, GNSS signals propagate directly with minimal multipath effects. As a result, the primary sources of error are likely receiver noise and satellite geometry, such as the Geometric Dilution of Precision (GDOP).

- Conversely, in the Urban dataset, the WLS solution shows significantly larger errors, with fluctuations appearing more random in the East, North, and altitude directions. The velocity curves exhibit substantial variations and pronounced jitter, particularly in the altitude component, suggesting severe signal tracking disturbances. In urban environments, obstacles such as buildings, trees, and vehicles contribute to non-line-of-sight (NLOS) propagation, causing signal reflections, scattering, and diffraction. This results in severe multipath effects, leading to unpredictable and random error fluctuations.

- In conclusion, multipath effects introduce severe distortions in pseudorange measurements, causing inaccuracies in both position and velocity estimation by the WLS solution. The OpenSky dataset benefits from a direct line-of-sight (LOS) to satellites, ensuring stable tracking and precise solutions, while the Urban dataset suffers from significant errors due to reflections and signal obstructions, leading to degraded positioning performance.

## Task 5 – Kalman Filter-Based Positioning
Develop an Extended Kalman Filter (EKF) using pseudorange and Doppler measurements to estimate user position and velocity.
The corresponding implementation can be found in the `tracking_POS_KF.m` file. The results are shown as follows:
### Opensky:
#### Position:
<div align="center">
    <img src="/Figure/LLH_OpenSky_EKF.png" height="300">
    <img src="/Figure/ENU_OpenSky_EKF.png" height="300">
    <img src="/Figure/ENU_Variations_OpenSky_EKF.png" height="300">
</div>

#### Velocity:
<div align="center">
    <img src="/Figure/Velocity_OpenSky_EKF.png" width="400">
</div>

### Urban:
#### Position:
<div align="center">
    <img src="/Figure/LLH_Urban_EKF.png" height="300">
    <img src="/Figure/ENU_Urban_EKF.png" height="300">
    <img src="/Figure/ENU_Variations_Urban_EKF.png" height="300">
</div>

#### Velocity:
<div align="center">
    <img src="/Figure/Velocity_Urban_EKF.png" width="400">
</div>

## References
- Xu, B., & Hsu, L.-T. (2019). [Open-source MATLAB code for GPS vector tracking on a software-defined receiver](https://doi.org/10.1007/s10291-019-0839-x). *GPS Solutions, 23(2)*, 46.  
- Ng, H.-F., Zhang, G., Yang, K.-Y., Yang, S.-X., & Hsu, L.-T. (2020).  [Improved weighting scheme using consumer-level GNSS L5/E5a/B2a pseudorange measurements in the urban area](https://doi.org/10.1016/j.asr.2020.06.002). *Advances in Space Research, 66(7)*, 1647-1658.  
- [Open source MATLAB-based code](https://www.ngs.noaa.gov/gps-toolbox/GPS_VT_SDR.htm)
- [GNSS-SDR Documentation](https://gnss-sdr.org)
- [GPT-4o](https://chatgpt.com/?model=gpt-4o)
- [DeepSeek](https://www.deepseek.com/)
