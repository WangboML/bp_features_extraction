function [peak,onset]=detectPeaksAndOnsetsInPPG(ppg)
%求PPG信号的波峰
%输入信号
%ppg 采样率1000，1*N
%输出信号
%peak 波峰位置序列 N*2 位置+值
%onset 起始点序列 N*2 位置，值
data=ppg-mean(ppg);

% len=length(data);
% threshold = floor(1000*3/10); %信号周期大概的长度（偏小）
% maxLenRet = ceil(len / threshold);           % 峰值的大致个数
% peak = zeros(maxLenRet,2);

%求信号对应的SSF函数 N*2
ssf=ssfInPPG(data); %N*2的矩阵
 %寻找前三秒SSF的最大值的%70作为初始阈值
 max=ssf(1000,2);
    for i=1000:3000
         if ssf(i,2)>=max
                max=ssf(i,2);
         end
         thres=max*0.7;
    end
    %对之后的SSF函数进行处理
    k=1;
for i=3000:length(data)-150
% for i=3000:10000
    
  
   
   
     %找出信号中前后20个点导数大于零，并且刚好大于阈值的点（上升沿上超出阈值的点）
     if ssf(i,2)<=thres
         if ssf(i+1,2)>=thres
             if ssf(i+5,2)>ssf(i-5,2)%刚好大于阈值的点
                 if k==1
                     
                     peaksofssf(k,1)=i;
                     [locs,pks]=findMaxInSSF(ssf,peaksofssf(k,1),150);
                     peaksofssf(k,2)=pks;
                     peaksofssf(k,3)=locs;
                     k=k+1;
                     
                 else
                     if i-peaksofssf(k-1,1)>150
                         
                         peaksofssf(k,1)=i;
                         [locs,pks]=findMaxInSSF(ssf,peaksofssf(k,1),150);
                         peaksofssf(k,2)=pks;
                         peaksofssf(k,3)=locs; %SSF波峰位置
                         k=k+1;
                     end
                 end
                 
                 
                 
                 
                 if k>6
                     thres=(peaksofssf(k-5,2)+peaksofssf(k-4,2)+peaksofssf(k-3,2)+peaksofssf(k-2,2)+peaksofssf(k-1,2))/5*0.4;
                 end
                
                 
             end
         end
     end
end
for j=1:k-1
    i=peaksofssf(j,1);
    [locs,pks]=findMax(data,i,150);
    peak(j,1)=locs;
    peak(j,2)=ppg(locs);
    
end
for j=1:k-1
    i=peaksofssf(j,1);
    [locs,ons]=findMin(data,i,150);
    onset(j,1)=locs;
    onset(j,2)=ppg(locs);
    
end
end
