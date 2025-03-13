function AcquisitionPlot(acq,svindex,Acquired,signal)
%% 可视化三维捕获结果
    figure(svindex);
    hold on;
    % 计算 freqMax
    freqMax = acq.freqMin + (acq.freqNum - 1) * acq.freqStep;

    % 创建网格，Y 轴表示多普勒频率（从 freqMin 到 freqMax），X 轴表示码相位（samples）
    [X, Y] = meshgrid(1:signal.Sample, acq.freqMin:acq.freqStep:freqMax);
    correlation = Acquired.correlation{svindex};
    surf(Y, X, correlation, 'EdgeColor', 'none'); % 绘制 3D 表面图

    % 设置坐标轴标签
    ylabel('Doppler frequency (Hz)', 'FontSize', 12);
    xlabel('Code phase (samples)', 'FontSize', 12);
    zlabel('Correlation Power', 'FontSize', 12);
    title('GPS Signal Acquisition 3D Visualization', 'FontSize', 14);

    % 颜色映射和优化
    colormap(jet);    % 使用 jet 颜色映射
    colorbar;         % 显示颜色条
    shading interp;   % 平滑着色
    view([-40, 30]);  % 设置 3D 视角

    % 查找相关矩阵中的最大峰值以及其对应的 X, Y, Z 坐标
    [max_corr, idx] = max(correlation(:)); % 找到最大相关值
    [row, col] = ind2sub(size(correlation), idx); % 找到对应的行列（即峰值的X, Y）

    % 计算对应的 X, Y, Z 值
    peak_X = X(row, col);   % 码相位（samples）
    peak_Y = Y(row, col);   % 多普勒频率（Hz）
    peak_Z = max_corr;      % 相关功率

    hold off;
end