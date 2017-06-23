 

function [data_peak] = find_peak_ECGpce(data)
%% 寻找前2秒data信号的最大值的%40作为初始阈值
 max=data(1);
    for i=1:2000
         if data(i)>=max
                max=data(i);
         end
         thres=max*0.4;
    end
    %对之后的recg进行处理
    k=1;
for i=2000:length(data)-110
    

    
  
   
   
     %找出信号中前后20个点导数大于零，并且刚好大于阈值的点（上升沿上超出阈值的点）
     if data(i)<=thres
         if data(i+1)>=thres
             if data(i+2)>data(i-2)%刚好大于阈值的点
                 if k==1
                     
                     data_peak_1(k,1)=i;
                     [locs,pks]=findMax(data,i,100);
                     data_peak_1(k,2)=pks;
                     data_peak_1(k,3)=locs;
                     k=k+1;
                     
                 else
                     if i-data_peak_1(k-1,1)>100
                         
                         data_peak_1(k,1)=i;
                         [locs,pks]=findMax(data,i,100);
                         data_peak_1(k,2)=pks;
                         data_peak_1(k,3)=locs; %波峰位置
                         k=k+1;
                     end
                 end
                 
                 
                 
                 
                 if k>6
                     thres=(data_peak_1(k-5,2)+data_peak_1(k-4,2)+data_peak_1(k-3,2)+data_peak_1(k-2,2)+data_peak_1(k-1,2))/5*0.4;
                 end
                
                 
             end
         end
     end
end

data_peak(:,1)=data_peak_1(:,3);
for i=1:k-1
 weizhi=data_peak_1(i,3);
data_peak(i,2)=data(weizhi);
end