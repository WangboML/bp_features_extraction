function [area] = calcArea(vals)
% 计算vals曲线段下的面积
% vals 曲线段 - 已减去最小值

% if length(vals(:,1)) == 0
% 	area = 0;
% 	return;
% end
area = sum(vals);
end