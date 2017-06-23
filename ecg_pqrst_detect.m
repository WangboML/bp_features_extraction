function [ecg_Q,ecg_R,ecg_S] = ecg_pqrst_detect(data)
%   心电信号特征检测函数：ecg_pqrst_detect,用于求得ECG信号的pqrst特征点
%   输入：data（ECG数据） 1 * N
%   输出：ecg_P、ecg_Q、ecg_R、ecg_S、ecg_T   N * 2 位置*值


%% ==================== Part 1：R波检测====================
%保留5、6、7阶的细节系数并重构，平方之后自适应阈值检测波峰，然后在回到原信号来找出R波
R_coff= zeros(size(data));
R_coff = wavefilter(data,'db6',10,[5 6 7],0); %0是是否使用尺度系数 0：不使用 ；1：使用
R_coff=R_coff.^2;
% plot(data);hold on;
%自适应阈值寻找平方后的信号的波峰
R_coff_peak = find_peak_ECGpce(R_coff);
% plot(R_coff_peak(:,1),R_coff_peak(:,2),'r*')
%在原始ECG信号中找到对应波峰位置左右30个点的最小值
Interval1=50;
ecg_R = zeros(size(R_coff_peak));
for i=1:length(R_coff_peak)
    min=data(R_coff_peak(i,1)-Interval1);
    locs=R_coff_peak(i,1)-Interval1;
    if R_coff_peak(i,1) + Interval1<=length(data) && R_coff_peak(i,1) - Interval1>0
        for j=(R_coff_peak(i,1)-Interval1):(R_coff_peak(i,1)+Interval1)
            if data(j)<=min
                
                locs=j;
                min=data(locs);
            end
            
        end
    end
    ecg_R(i,1)= locs;
    ecg_R(i,2)=min;
end
%得到ECG信号中的R波位置，ecg_R  N*2

%% ==================== Part 2：QS波检测====================
ecg_Q = zeros(size(ecg_R));
ecg_S = zeros(size(ecg_R));
%在左侧找第一个极大值为Q波
Interval2=100;
for i=1:length(ecg_R)
    if ecg_R(i,1) - Interval2>0
        [~,shift] = findpeaks(data(ecg_R(i,1)- Interval2:ecg_R(i,1)));
        if numel(shift)==0
           ecg_Q(i,1)=0;
        else
         ecg_Q(i,1) = ecg_R(i,1) + shift(1) - Interval2-1;
        end
        
    end
end

for i=1:length(ecg_R)
    if ecg_Q(i,1)==0
        ecg_Q(i,2)=0;
    else
        ecg_Q(i,2)=data(ecg_Q(i,1));
    end
end

%在在右侧找第一个极大值为S波
Interval3=100;
for i=1:length(ecg_R)
   
        
    if ecg_R(i,1) + Interval3<=length(data)
        
        [~,shift] = findpeaks(data(ecg_R(i,1)+15:ecg_R(i,1)+ Interval3));
        if numel(shift)==0
         ecg_S(i,1)=0;
        else
         ecg_S(i,1) = ecg_R(i,1) + shift(1)+14;
        end

        
    end
end
for i=1:length(ecg_R)
    if ecg_S(i,1)==0
        ecg_S(i,2)=0;
    else
        ecg_S(i,2)=data(ecg_S(i,1));
    end
end
% ecg_S(:,2)=data(ecg_S(:,1));



% %% ==================== Part 4：P====================
% P_coff = wavefilter(data,'db6',10,[ 3 4 5 6 ],1);
% 
% %保留3 4 5 6阶的细节系数并重构，之后在P波的右侧寻找第一个极小值，作为P波近似位置
% P_coff_peak = zeros(size(ecg_Q));
% Interval6=200;
% 
% for i=1:length(ecg_Q)
%    
%         if ecg_Q(i,1) - Interval6>0
%         [~,shift] = findpeaks(-1*P_coff(ecg_Q(i,1)-Interval6:ecg_Q(i,1)-20));
%         P_coff_peak(i,1) = ecg_Q(i,1) + shift(end)-Interval6;
%         end
%   
% end
% P_coff_peak(:,2)=P_coff(P_coff_peak(:,1));
% 
% %与上述R波类似，需要回到原信号中在P波(左边找)附近寻找最小值，找到准确P波位置
% ecg_P = zeros(size(ecg_Q));
% Interval7=100;
% for i=1:length(P_coff_peak)
%     min=data(P_coff_peak(i,1)-Interval7);
%     locs=P_coff_peak(i,1)-Interval7;
%     if P_coff_peak(i,1) + Interval7<=length(data) && P_coff_peak(i,1) - Interval7>0
%         
%         for j=(P_coff_peak(i,1)-Interval7):P_coff_peak(i,1)
%             if data(j)<=min
%                 
%                 locs=j;
%                 min=data(locs);
%             end
%             
%         end
%     end
%     ecg_P(i,1)= locs;
%     ecg_P(i,2)=min;
% end
%   %% ==================== Part 3：T====================
%     %保留8,9阶的细节系数并重构，之后在S波的右侧寻找第一个极小值，作为T波近似位置
%  %   T_coff = wavefilter(data,'db6',10,[8 9 10],1);
%      Wn=0.018;
%     [Bb,Ba]=butter(4,Wn,'low'); % 调用MATLAB butter函数快速设计滤波器
%     T_coff=filter(Bb,Ba,data); % 进行低通滤波
% %     hold on;
% %     plot(T_coff,'r');
%     T_coff_peak = zeros(size(ecg_R));
%     Interval4=380;
%     for i=1:length(ecg_S)
%         if ecg_R(i,1) + Interval4<=length(T_coff)
%             [~,shift] = findpeaks(-1*T_coff(ecg_S(i,1)+10:ecg_S(i,1)+ Interval4));
%             if(isempty(shift))
%                 T_coff_peak(i,1) = 1;
%             else
%                 T_coff_peak(i,1) = ecg_S(i,1) + shift(1)+10;
%             end
%         end
%     end
%     for i=1:size(T_coff_peak,1)
%         if T_coff_peak(i,1)==0
%             T_coff_peak(i,1)=1;
%         end
%     end
%   
%   
% %与上述R波类似，需要回到原信号中在T波附近寻找最小值，找到准确T波位置
%     ecg_T = zeros(size(ecg_S));
%     Interval5=130;
%     for i=1:length(T_coff_peak)
%         if(T_coff_peak(i,1) == 1)
%             ecg_T(i,1) = 0;
%             ecg_T(i,2) = 0;
%         else
%             min=data(T_coff_peak(i,1)-Interval5);
%             locs=T_coff_peak(i,1)-Interval5;
%             if T_coff_peak(i,1) + Interval5<=length(data) && T_coff_peak(i,1) - Interval5>0
%                 for j=(T_coff_peak(i,1)-Interval5):(T_coff_peak(i,1)+Interval5)
%                     if data(j)<=min
%                         locs=j;
%                         min=data(locs);
%                     end
%                 end
%             end
%             if locs<ecg_S(i,1)
%                 ecg_T(i,1) = 0;
%                 ecg_T(i,2) = 0;
%             else
%                 ecg_T(i,1)= locs;
%                 ecg_T(i,2)=min;
%             end
%         end
%     end    


%画图
plot(data,'r');
hold on;
plot(ecg_R(:,1), ecg_R(:,2), 'r+','LineWidth', 2, 'MarkerSize', 5);
hold on;
plot(ecg_Q(:,1), ecg_Q(:,2), 'yo','LineWidth', 2, 'MarkerSize', 5);
hold on;
plot(ecg_S(:,1), ecg_S(:,2), 'rx','LineWidth', 2, 'MarkerSize', 5);
hold on;
% plot(ecg_T(:,1), ecg_T(:,2), 'k^','LineWidth', 2, 'MarkerSize', 5);
% hold on;
% plot(ecg_P(:,1), ecg_P(:,2), 'mH','LineWidth', 2, 'MarkerSize', 5);
end