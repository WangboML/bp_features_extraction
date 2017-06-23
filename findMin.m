function [locs,ons]=findMin(data,i,N)
%寻找PPG信号中子在给定位置前N点的最小值

%输入信号
% i PPG 信号中的位置 N 后面多少个点
%输出信号
% locs ons 后面的最大值位置的位置和值
%data 
k=i-N;
min=data(k);
locs=k;
for m=1:N
   
    if data(k+m)<=min
        min=data(k+m);
        locs=k+m;
    end
end
ons=min;
end