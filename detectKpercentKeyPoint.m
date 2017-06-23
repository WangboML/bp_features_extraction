function [idx] = detectKpercentKeyPoint(risingEdge, percent)
% [idx] = detectKpercentKeyPoint(data, K) 在上升沿中定位幅值百分点
% idx：位置
% risingEdge：上升沿数据，头是最小值，尾是最大值
% percent：百分比
idx=0;
if isempty(risingEdge)
    return
end
keyVal = risingEdge(1) + percent * (risingEdge(end) - risingEdge(1));
delta4key = abs(risingEdge - keyVal);
idx = find(delta4key == min(delta4key), 1,  'first');

end
