function PointPlot(track, navSolutionsVT, navSolutionsCT)
% East 和 North 分别是东向和北向的位置数据
% ConventionalTracking 和 VectorTracking 是两个位置数据集
% ReferencePos 是参考位置坐标
pdi     = track.pdi;
datalength  = track.msToProcessCT;
% 创建散点图
figure;
hold on;
EastConventional = navSolutionsCT.usrPosENU(:,1); % 常规跟踪的东向坐标
%fprintf('EastConventional: %+3.4f\n',EastConventional);
NorthConventional =navSolutionsCT.usrPosENU(:,2); % 常规跟踪的北向坐标
EastVector = navSolutionsVT.usrPosENU(:,1); % 矢量跟踪的东向坐标
NorthVector = navSolutionsVT.usrPosENU(:,2); % 矢量跟踪的北向坐标

% 参考位置
EastRef = 0;
NorthRef = 0;
% 绘制常规跟踪数据（蓝色）
scatter(EastConventional, NorthConventional, 'b.', 'DisplayName', 'Conventional tracking');

% 绘制矢量跟踪数据（红色）
scatter(EastVector, NorthVector, 'r.', 'DisplayName', 'Vector tracking');

% 绘制参考位置（黑色圆点）
scatter(EastRef, NorthRef, 100, 'k', 'filled', 'DisplayName', 'Reference position');

% 设置坐标轴标签
xlabel('East (meter)');
ylabel('North (meter)');

% 显示图例
legend('Location', 'best');

% 设置图形的标题
title('Horizontal positioning error');

% 设置轴的范围
axis([-40 30 -20 40]);

grid on; % 打开网格
set(gca, 'GridColor', [0.8, 0.8, 0.8], 'GridAlpha', 0.5); % 设置浅灰色网格并调整透明度

% 设置更精细的网格
%grid minor; % 打开次网格

hold off;
end