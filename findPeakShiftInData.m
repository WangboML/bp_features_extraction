function [ peakpos ] = findPeakShiftInData(data)
%FINDPEAKSHIFTINDATA 在数据段data中查找一个峰值的位置，如果没有发现峰值，则返回-1
%   要求数据段中有一段数据的值大于data起点的值 s-起始值 o-找到的峰值 e-结束值
%                   o
%           *           *
%      *                    **
%   s                               *
%                                           e
%   输入
%   data - [N,1]矩阵 每一行代表一个点
%   输出
%   peakpos - 峰值的位置
%% 预定义
peakpos = -1;
%% 判断输入是否符合要求
len = length(data);
if len<3
    return
end
%% 查找是否有超过起始点y值的数据段
pos = find(data > data(1));
if isempty(pos)
    return
end
[~,ppos] = max(data(data>data(1)));
peakpos = pos(ppos);
end

