function [locs,pks]=findMax(data,i,N)
%找出PPG信号中第I个信号后N个序列中的最大值
%输入信号
% i PPG 信号中的位置 N 后面多少个点
%输出信号
% locs pks 后面的最大值位置的位置和值
max=data(i);
locs=i;
for m=1:N
   
    if data(i+m)>=max
        max=data(i+m);
        locs=i+m;
    end
end
pks=max;
end



