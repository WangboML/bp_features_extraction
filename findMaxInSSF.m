function [locs,pks]=findMaxInSSF(data,i,N)
%找出SSF信号中第I个信号后N个序列中的最大值
%输入信号
% i SSF 信号中的位置 N 后面多少个点 N*2
%输出信号
% locs pks 后面的最大值位置的位置和值
max=data(i,2);
locs=data(i,1);
for m=1:N
    
    if data(i+m,2)>=max
        max=data(i+m,2);
        locs=data(i+m,1);
    end
end
pks=max;
end