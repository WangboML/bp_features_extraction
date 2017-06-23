function [pos] = findPassZeroPointPos(data)
%%找一组离散数据的近似过零点
%  输入:
%  data: N维离散数据(N>2)
%  输出:
%  pos : 离散数据中近似过零点的位置
% 预处理数据
if min(data)>1 || length(data)<3
    pos = [];
    return
end
%% 求数据移位相乘的结果
plusResult = data(1:end-1).*data(2:end);
%% 找到小于0的数据点的位置
pos = find(double(plusResult<=0));
for i=1:length(pos)
    if abs(data(pos(i))) > abs(data(pos(i) + 1))
        pos(i) = pos(i)+1;
    end
end