function filteredSignal = adaptiveFilter(rawSignal, referenceSignal, mu, filterOrder)
    % 自适应滤波器
    N = length(rawSignal);
    w = zeros(filterOrder, 1);  % 初始化滤波器权重
    filteredSignal = zeros(N, 1);

    for i = filterOrder:N
        x = referenceSignal(i:-1:i-filterOrder+1); % 取过去 filterOrder 个采样点
        x = reshape(x, [], 1);  % 确保 x 是列向量

        y = w' * x;  % 计算滤波输出
        e = rawSignal(i) - y;  % 计算误差
        w = w + 2 * mu * e * x;  % 权重更新
        filteredSignal(i) = e;
    end
end
