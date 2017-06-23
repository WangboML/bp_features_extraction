function [dicNotch,dicPeak]=detectDicNotchAndDicPeak(ppg,peak,onset)
%先找出ppg信号中每一个下降沿，并且以N*1表示
%输入信号
% ppgpce:处理后的PPG信号 1*N
% peak:PPG信号的波峰位置和值 N*2
% onset:PPG信号的起始点 N*2
%输出信号
% descendEngeofPPG:PPG信号的下降沿 N*1

%% 先找到PPG信号的下降沿的位置，介于每搏心跳的峰值点到下一个心跳的起始点
lenppg=length(ppg);
lenpeak=size(peak,1);
dicNotch=zeros(lenpeak,2);
dicPeak=zeros(lenpeak,2);
ppgpce_off=ppg-mean(ppg);
% plot(ppgpce_off);
for k=1:lenpeak-1
    for i=1:lenppg
        if i==peak(k,1)
            if onset(k+1,1)-peak(k,1)<1200&&onset(k+1,1)-peak(k,1)>200
                descendingEdgeofPPG=ppgpce_off(peak(k,1):onset(k+1,1));
                descendingEdgeofPPG=descendingEdgeofPPG';
                
                [dicNotch1, dicPeak1, zeroPassPointsNum ] = detectDicNotchAndDicPeakInDescendingEdgeUseWavelet( descendingEdgeofPPG,100 );
               
                
                dicNotch(k,1)=dicNotch1+i;
                dicNotch(k,2)=ppg(dicNotch1+i);
                dicPeak(k,1)= dicPeak1+i;
                dicPeak(k,2)=ppg(dicPeak1+i);
            else
                dicNotch(k,1)=0;
                dicNotch(k,2)=0;
                dicPeak(k,1)= 0;
                dicPeak(k,2)=0;
            end
        end
    end
end

%画图
plot(ppg);
hold on
plot(dicNotch(:,1),dicNotch(:,2),'kx','LineWidth', 2, 'MarkerSize', 7);
hold on
plot(dicPeak(:,1),dicPeak(:,2),'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 7);

end

