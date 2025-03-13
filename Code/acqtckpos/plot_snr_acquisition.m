function plot_snr_acquisition(Acquired, total_sats)
    % plot_snr_acquisition - Plots SNR acquisition results
    % Inputs:
    %   Acquired - Structure containing acquired satellites and SNR values
    %   total_sats - Total number of satellites in PRN list

    % 创建 PRN 编号
    prn_numbers = 1:total_sats;

    % 初始化 SNR 值，未获取的信号设置为 NaN（不会绘制）
    SNR_values = nan(1, total_sats);
    
    % 存储所有 SNR 值（无论是否捕获）
    if isfield(Acquired, 'allSNR')
        SNR_values = Acquired.allSNR; % 直接使用存储的所有 SNR
    end

    % 确定已获取卫星的索引
    acquired_indices = Acquired.sv; % 获取成功的 PRN 号

    % 定义颜色
    colors = repmat({'b'}, 1, total_sats); % 默认所有卫星颜色为蓝色（未获取）
    for i = 1:length(acquired_indices)
        colors{acquired_indices(i)} = 'g'; % 获取成功的卫星设为绿色
    end

    % 绘制条形图
    figure;
    hold on;
    for i = 1:total_sats
        if ~isnan(SNR_values(i)) % 仅绘制有效的 SNR 值
            bar(prn_numbers(i), SNR_values(i), 'FaceColor', colors{i});
        end
    end
    
 % **在 SNR = 18 处添加红色虚线**
    y_threshold = 18; % SNR 阈值
    yline(y_threshold, 'r--', 'LineWidth', 1.5);

    % **在红色虚线旁边添加文字标注**
    x_text = total_sats * 0.8; % 让文字靠右显示
    text(x_text, y_threshold + 1, 'SNR = 18', 'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');


    %% **手动创建正确的图例**

    h1 = bar(NaN, NaN, 'b', 'EdgeColor', 'k'); % 蓝色表示未获取
    h2 = bar(NaN, NaN, 'g', 'EdgeColor', 'k'); % 绿色表示已获取
    legend([h1, h2], {'Not acquired signals', 'Acquired signals'}, 'Location', 'northeast');

    hold off;
    % 设置坐标轴
    xlabel('PRN number');
    ylabel('Acquisition Metric');
    title('Acquisition results');
    grid on;
end
