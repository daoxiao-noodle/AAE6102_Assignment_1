function filteredSignal = preprocess(rawSignal, Fs)
    % 1. 确保 rawSignal 不是全零，否则归一化会出错
    if max(abs(rawSignal)) > 0
        rawSignal = rawSignal / max(abs(rawSignal));  % 归一化
    end

    % 2. 先进行带通滤波（分别对 I/Q 分量处理）
    filteredReal = bandpassFilter(real(rawSignal), Fs);
    filteredImag = bandpassFilter(imag(rawSignal), Fs);
    filteredSignal = filteredReal + 1i * filteredImag;

    % 3. 低通滤波，进一步减少多路径影响
    cutoffFreq = 5e6; % 低通滤波截止频率 (Hz)
    filteredReal = lowpassFilter(real(filteredSignal), Fs, [2e6, 6e6]);
    filteredImag = lowpassFilter(imag(filteredSignal), Fs, [2e6, 6e6]);
    filteredSignal = filteredReal + 1i * filteredImag;

    % 4. 使用LMS自适应滤波，增强直线路径信号
    mu = 0.015;  % 学习速率
    filterOrder = 5;
    
    % 采用低通滤波后的信号作为参考信号，而不是随机噪声
    referenceSignal = filteredReal;  

    filteredReal = adaptiveFilter(filteredReal, referenceSignal, mu, filterOrder);
    filteredImag = adaptiveFilter(filteredImag, referenceSignal, mu, filterOrder);
    filteredSignal = filteredReal + 1i * filteredImag;

    % 5. **归一化，恢复信号能量**
    if max(abs(filteredSignal)) > 0
        filteredSignal = filteredSignal / max(abs(filteredSignal));
    end
    % 6. 确保数据格式一致
    filteredSignal = cast(filteredSignal, class(rawSignal)); % 保持数据类型
    filteredSignal = filteredSignal(:)';  % 转换为行向量 (1 × N)
% 绘图对比
figure;
subplot(2,1,1);
plot(real(rawSignal)); hold on;
plot(imag(rawSignal)); hold off;
title('原始信号');

subplot(2,1,2);
plot(real(filteredSignal)); hold on;
plot(imag(filteredSignal)); hold off;
title('优化后的滤波信号');
end