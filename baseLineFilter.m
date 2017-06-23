function [dataNoBase] = baseLineFilter(origin, win)
% 用于滤除基线漂移，win为窗口长度，即计算基线的信号长度。
% 信号开始和结尾阶段会用镜像法补全窗口

len = length(origin);    
winMirror = ceil(win / 2);
winMirror = min(winMirror, len);
d = zeros(len + winMirror * 2, 1);
d(1 : winMirror) = origin(winMirror : -1 : 1);
d(winMirror + 1 : end - winMirror) = origin;
d(end - winMirror + 1 : end) = origin(end : -1 : end - winMirror + 1);
u = ones(winMirror * 2 , 1) ./ (winMirror*2);
base = conv(d, u, 'same');
dataNoBase = origin - base(winMirror + 1 : end - winMirror);

end
 