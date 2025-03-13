function filteredSignal = lowpassFilter(rawSignal, Fs, cutoffFreq)
    nyquist = Fs / 2;
    normCutoff = cutoffFreq / nyquist;

    filterOrder = 50;
    firCoeff = fir1(filterOrder, normCutoff, 'low', hann(filterOrder + 1));

    filteredSignal = filtfilt(firCoeff, 1, rawSignal);
end
