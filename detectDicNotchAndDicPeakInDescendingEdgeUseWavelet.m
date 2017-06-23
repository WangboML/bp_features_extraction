function [dicNotch, dicPeak, zeroPassPointsNum ] = detectDicNotchAndDicPeakInDescendingEdgeUseWavelet( descendingEdge,range )
%DETECTDICNOTCHANDDICPEAKINDESCENDINGEDGEUSEWAVELET 执行以下几个步骤 重采样 ->
%求差分信号的小波变换 -> 找到特定过零点作为降中峡 ->根据降中峡的位置使用距离法查找重搏波
%   使用小波法在下降支中检测重博波和降中峡
%   输入
%   descendingEdge [N*1]矩阵 脉搏波下降支
%   range 使用衰减法计算出的当前距离法搜索范围
%   输出
%   zeroPassPointsNum 半心动周期内过零点的数量

%%参数与输出预定义
resampleInterval = 10;%减采样周期
dicNotch = -1;
dicPeak = -1;
zeroPassPointsNum = 0;
flag = 0;
pos=1;
%% 步骤1：信号段减采样与归一化 
data = descendingEdge;
dataPart = downsample(data,resampleInterval);
dataPart = dataPart/max(abs(dataPart));



%% 步骤2：求小波变换

wlp = waveletMethodB(dataPart);
% 
% figure;
% plot(dataPart,'r');
% hold on;
% plot(0.5*wlp);

%% 步骤3：降中峡位置
%   3-1 通过降采样后的下降沿和小波变换后的信号做比较，确定降中峡粗略位置，以下采用4种方法，优先级依次降低
%方法一：寻找dataPart前半段的极小值点，如果找到，则认为是降中峡
if(floor(length(dataPart)/2)>=24)
    if(isempty(findpeaks(-1*dataPart(11:floor(length(dataPart)/2))))==0)
        [~,pos] = findpeaks(-1*dataPart(11:floor(length(dataPart)/2)));
        pos = pos(1)+10;
        flag = 0;
    elseif(min(dataPart)<max(0.5*wlp))%方法二：方法一失败，没有找到极小值，则寻找dataPart和wlp的交点作为降中峡位置（下面还有判断）
        for i = 1:length(dataPart)
            if(0.5*wlp(i)>=dataPart(i))
                pos = i-1;
                flag = 1;
                break;
            end
        end
    else
        pos=1;
        flag=1;
    end
else
%     fprintf('真的没办法了'); %信号长度非常短，继续寻找已没有意义
    dicNotch = 0;
    dicPeak = 0;
    return
end


[~,peak] = findpeaks(wlp);
[~,valley] = findpeaks(-1*wlp);
%方法三：判断方法二找到的点是否位置合适（在最开头或是后半段），若不合适则采用wlp的第四个过零点作为降中峡
%if(flag)
if((pos>floor(length(wlp)/2) || pos<floor(length(wlp)/10) || pos<peak(1))  && flag)
%if((pos>floor(length(wlp)/2) || pos<floor(length(wlp)/10) || pos<=peak(1)) && flag)
    pos = findPassZeroPointPos(wlp(1:floor(end/2))) ; 
    zeroPassPointsNum = length(pos);
    if zeroPassPointsNum<4  %方法四：如果wlp前半段的过零点数不足4，则采用方法四：寻找wlp第二个波谷和第二个波峰之间的过零点作为降中峡
        if(peak(2)>valley(2))
            pos_zero = findPassZeroPointPos(wlp(valley(2):peak(2)));
            if(isempty(pos_zero)==0)
                pos = valley(2)+pos_zero(1);
            else
%                 fprintf('真的没办法了');  %如果波峰波谷之间还找不到过零点，返回-1
                dicNotch = 0;
                dicPeak = 0;
                return 
            end
        else
            pos_zero = findPassZeroPointPos(wlp(valley(1):peak(2)));
            if(isempty(pos_zero)==0)
                pos = valley(1)+pos_zero(1);
            else
                fprintf('真的没办法了');  %如果波峰波谷之间找不到过零点，返回-1
                dicNotch = 0;
                dicPeak = 0;
                return
            end
        end
    else
        pos =  pos(4);
    end
end

% 调试画图程序
% figure;
% plot(dataPart,'r');
% hold on;
% plot(0.6*wlp);
% hold on;
% plot(pos, dataPart(pos), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7);



%   3-2 将降中峡位置增采样，并在[-resampleInterval,resampleInterval]内寻找二阶导最大值点，作为降中峡原始波形位置
pos = pos*resampleInterval;
resampleInterval = 10;
if pos + resampleInterval<=length(data) && pos - resampleInterval>0
        [~,shift] = min(abs(diff(data(pos- resampleInterval:pos + resampleInterval),1)));
        pos = pos + shift - resampleInterval-1; 
end

if pos >= length(data)
    return
end
dicNotch = pos;
%% 步骤4：在[pos+1:pos+range-1]范围内寻找到包含[pos,data(pos)]与[pos+range,data(pos+range)]这两点的直线
%       的距离最近且处于直线上方的点，然后在起点到这点之间找波峰。如果找到了波峰，则将其位置作为重博波位置，否则使用终点位置
if pos+range > length(data)
    range = length(data) - pos;
end
tmp = data(pos+1:pos+range-1);
[~,maxpos,~] = poinToLineDistance([pos+1:pos+range-1;tmp(:)']',...
    [pos,data(pos)],[pos+range,data(pos+range)],1);
tmp = findPeakShiftInData(data(pos:pos+maxpos));
if tmp~=-1
    dicPeak = pos+tmp-1;
else
    dicPeak = pos+maxpos;
end
end

