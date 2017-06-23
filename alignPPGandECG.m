function [ppg_locs_off,ecg_locs_off,bp_locs_off]=alignPPGandECG(ppg,ecg,peak,onset,dicNotch, dicPeak,ecg_Q,ecg_R,ecg_S,systolic,diastolic)
%根据ECG信号的R波位置为起始点寻找满足满足在其之后10~900存在PPG信号peak的作为其心动周期内的信号
%并且筛选出所有含有0位置的点（即在特征点不存在的点）
%输入信号
%输出信号
%ppg_locs_off PPG信号的特征点在PPG信号中的位置：起点、波峰、降中峡、重搏波
%ecg_locs_off  ECG信号的特征点在ECG信号中的位置：P Q R S T

ecg_locs(:,1)=ecg_Q(:,1);
ecg_locs(:,2)=ecg_R(:,1);
ecg_locs(:,3)=ecg_S(:,1);

% 将PPG信号的特征联合起来
ppg_locs(:,1)=onset(:,1);
ppg_locs(:,2)=peak(:,1);
ppg_locs(:,3)=dicNotch(:,1);
ppg_locs(:,4)=dicPeak(:,1);
%将BP信号的特征联合起来
bp_locs(:,1)=diastolic(:,1);
bp_locs(:,2)=systolic(:,1);

%根据ECG信号的R波位置为起始点寻找满足满足在其之后10~900存在PPG信号peak的作为其心动周期内的信号
ppg_locs = alignPPGToReferenceECG(ppg_locs, ecg_locs, 10, 900); %寻找不到与ECG心搏周期内的PPG特征点时，PPG信号为0
bp_locs=alignBPToReferenceECG(bp_locs,ecg_locs,10,900);
%剔除所有含有0位置（没找到或者含错误的点）
% len=length(ppg_locs);
% k=1;
% ppg_locs_off=zeros(len,4);
% ecg_locs_off=zeros(len,5);
% for i=1:len
% if ppg_locs(i,2)~=0&&ppg_locs(i,3)~=0&&ecg_locs(i,5)~=0
%     ppg_locs_off(k,:)=ppg_locs(i,:);
%     ecg_locs_off(k,:)=ecg_locs(i,:);
%     k=k+1;
% end
ppg_locs_off=ppg_locs;
ecg_locs_off=ecg_locs;
bp_locs_off=bp_locs;
% %画图 
% plot(ppg,'k');
% hold on
%  plot(ecg);
%  hold on
% %  len=length(ecg_locs_off);
%  for k=1:len
%      %      if ppg_locs_off(k,2)~=0
%      if ppg_locs(k,2)~=0&&ppg_locs(k,3)~=0&&ecg_locs(k,5)~=0
%          hold on
%          i1=ppg_locs_off(k,1);
%          i2=ppg_locs_off(k,2);
%          i3=ppg_locs_off(k,3);
%          i4=ppg_locs_off(k,4);
%          hold on
%          plot(i1,ppg(i1),'r*')
%          hold on
%          plot(i2,ppg(i2),'r*')
%          hold on
%          plot(i3,ppg(i3),'r*')
%          hold on
%          plot(i4,ppg(i4),'r*')
%          j1=ecg_locs_off(k,1);
%          j2=ecg_locs_off(k,2);
%          j3=ecg_locs_off(k,3);
%          j4=ecg_locs_off(k,4);
%          j5=ecg_locs_off(k,5);
%          hold on
%          plot(j1,ecg(j1),'ro');
%          hold on
%          plot(j2,ecg(j2),'ro');
%          hold on
%          plot(j3,ecg(j3),'ro');
%          hold on
%          plot(j4,ecg(j4),'ro');
%          hold on
%          plot(j5,ecg(j5),'ro');
%      end
%  end
end