function [ssfValue] = ssfInPPG(data)
%  获得每个点的ssf函数值
%  输入信号
%  data = PPG 1*N
%  输出信号
%  ssfValue  N*2矩阵 分别是位置和对应的函数值

len=length(data);
ssfValue = zeros(len,2);


for i=1:len
    if i<127
        ssfValue(i,1)=i;
        ssfValue(i,2)=0;
    else
        ssfValue(i,1)=i;
        sum=0;
        for j=i-125:i
            x=data(j)-data(j-1);
            if x<0
                x=0;
            end
            sum=sum+x;
            
        end
        ssfValue(i,2)=sum;
    end
end

% end
end


