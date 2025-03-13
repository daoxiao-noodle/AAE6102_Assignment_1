function filteredSignal = bandpassFilter(rawSignal, Fs)
    % 中频参数
    IF = 4.58e6;  % GPS 中频 (Hz)
    bandwidth = 2e6;  % 滤波带宽 (Hz)
    nyquist = Fs / 2;  % 奈奎斯特频率 (Hz)

    % 计算归一化带宽
    normBand = [(IF - bandwidth/2) / nyquist, (IF + bandwidth/2) / nyquist];

    % 设计 FIR 带通滤波器
    filterOrder = 100;  % 滤波器阶数
    firCoeff = fir1(filterOrder, normBand, 'bandpass', hann(filterOrder + 1));

    % 应用滤波器
    filteredSignal = filtfilt(firCoeff, 1, rawSignal);
end
