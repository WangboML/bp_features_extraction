function [peaks] = detetectPeaksInSSF(data)
% 对输入PPG信号求波峰
% 输入信号
% data = PPG
% 输出信号
% 波峰 peaks N*2

len=length(data);
threshold = floor(getSampleRate(1)*3/10); %信号周期大概的长度（偏小）
maxLenRet = ceil(len / threshold);           % 峰值的大致个数
peaks = zeros(maxLenRet, 2);


ssf=ssfInPPG(data); %N*2的矩阵
for i=1:len
    if i<3000
        thres=
    end
end
    
    
    
