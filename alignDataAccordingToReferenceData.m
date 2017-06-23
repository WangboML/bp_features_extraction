function [dataAligned] = alignDataAccordingToReferenceData(src, ref, intervalLowerBound, intervalUpperBound)
% [dataAligned] = alignDataAccordingToReferenceData(src, ref)
% 函数将目标数据与参考数据对齐，如果目标数据中没有和参考数据中的点对应的点，则该点设为[-1, 0]
% 输入：
%   src：    N x 2   目标数据
%   ref：    N x 2   参考数据
%   intervalLowerBound：目标数据和参考数据的时间差中较小的值，区分正负
%   intervalUpperBound：目标数据和参考数据的时间差中较大的值，区分正负
% 例子：
%   [onsetsAligned] = alignDataAccordingToReferenceData(onsets, peaks, -300, -10)
%           onsets的合法位置是在peaks的前300到前10之间
%   [dicNotchAligned] = alignDataAccordingToReferenceData(dicNotch, peaks, 100, 500)
%           onsets的合法位置是在peaks的后100到后500之间

lb = intervalLowerBound;
ub = intervalUpperBound;

%% 步骤1：结果初始化
dataAligned = zeros(size(ref));

%% 步骤2：为参考数据中的每个点寻找对应点
j = 1;
lenRef = size(ref, 1);
lenSrc = size(src, 1);
for i = 1 : lenRef
    %% 在目标数据中找到第一个可能处于合法范围的点
    while j <= lenSrc && src(j, 1) < ref(i, 1) + lb
        j = j + 1;
    end % while
    %% 目标数据已经完全遍历完毕，没有找到对应的点
    if j > lenSrc
        dataAligned(i, :) = [-1, 0];
    else
        %% 判定当前目标点是否在合法范围内
        if src(j, 1) < ref(i, 1) + ub;
            dataAligned(i, :) = src(j, :);
        else
            dataAligned(i, :) = [-1, 0];
        end % if
    end % if
    
    
end % for


end % function