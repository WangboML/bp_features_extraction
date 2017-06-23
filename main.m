clear all
close all
clc
load('a44002_0010.mat'); %原始数据是N*1
ecg=-ecg;
bp= interp(bp, 8);
ecg= interp(ecg, 8);
ppg= interp(ppg, 8);
bp=bp(24000000:28500000);
ecg=ecg(24000000:28500000);
ppg=ppg(24000000:28500000);
% bp2=bp(8200000:10700000);
% ecg2=ecg(8200000:10700000);
% ppg2=ppg(8200000:10700000);
% bp=[bp1,bp2];
% ecg=[ecg1,ecg2];
% ppg=[ppg1,ppg2];
%% ���ź�ȥ�룬�źŹ�һ����
ppg=wavefilter(ppg,'db6',10,[1,2,3,4,5,6,7,8,9,10],0);    %С��ȥ�����Ư��
ppg= mapminmax(ppg, 0, 1);
ecg= mapminmax(ecg, 0, 1);
Wn=0.1;
[Bb,Ba]=butter(4,Wn,'low'); % ����MATLAB butter�����������˲���
[BH,BW]=freqz(Bb,Ba); % ����Ƶ����Ӧ����
ppg=filter(Bb,Ba,ppg); % ���е�ͨ�˲�
ecg=filter(Bb,Ba,ecg); % ���е�ͨ�˲�
data=ppg-mean(ppg);
bp=filter(Bb,Ba,bp);
plot(ppg);
plot(ecg);
plot(bp);


%% ���PPG�źŲ������ʼ�㣬
[peak,onset]=detectPeaksAndOnsetsInPPG(ppg); % N*2��� peak���� onset��ʼ��
%���PPG�����ҳ�����Ĳ���
onset=alignDataAccordingToReferenceData(onset, peak,-300, -10);
plot(ppg)
hold on
plot(peak(:,1),peak(:,2),'ro');
hold on
plot(onset(:,1),onset(:,2),'r*');

%% ��PPG�źŵĽ���Ͽ���ز��� ��ΪN*2

[dicNotch, dicPeak] = detectDicNotchAndDicPeak(ppg,peak,onset); %�Ҳ�������Ͽ���ز���ʱ��λ��Ϊ0


%% �ҳ�ECG�ź�R��λ�úͶ�Ӧ��ֵ N*2
[ecg_Q,ecg_R,ecg_S] = ecg_pqrst_detect(ecg); %�Ҳ���T���� T��λ��Ϊ0

%% �ҳ�Ѫѹ�źŵ�����ѹ������ѹ
[systolic,diastolic]=detectPeaksAndOnsetsInPPG(bp);
diastolic=alignDataAccordingToReferenceData(diastolic, systolic,-300, -10);
plot(bp)
hold on
plot(diastolic(:,1),diastolic(:,2),'ro');
hold on
plot(systolic(:,1),systolic(:,2),'r*');

%%  �������źŰ�ʱ����������
% ���Ƚ�����ECG�ź��������һ��N*5���� �ֱ���һ���Ķ������ڵ�P��Q��R��S��T ���źŵ�λ������
%ppg_locs_off PPG�źŵ���������PPG�ź��е�λ�ã���㡢���塢����Ͽ���ز���
%ecg_locs_off  ECG�źŵ���������ECG�ź��е�λ�ã�P Q R S T
%����������ͬһ��λ��Ϊͬһ�Ķ����ڵ�����,��û�����1 ECGû�ҵ�T�� 2�����ڶ�Ӧ��PPG 3�������ز����������
[ppg_locs_off,ecg_locs_off,bp_locs_off]=alignPPGandECG(ppg,ecg,peak,onset,dicNotch, dicPeak,ecg_Q,ecg_R,ecg_S,systolic,diastolic);
%ppg_locs_end PPG�źŵ���������PPG�ź��е�λ�ã���㡢���塢����Ͽ���ز������յ�
%ecg_locs_end  ECG�źŵ���������ECG�ź��е�λ�ã�P Q R S T
[ppg_locs_end,ecg_locs_end,bp_locs_end]=deleteInefficientFeatureInPPGandECG(bp,ppg,ecg,ppg_locs_off,ecg_locs_off,bp_locs_off);

%% �����ź�����
[PPG_Features,ECG_Features,PPG_ECG_alingFeatures]=computeFeatureInPPG(ppg,ecg,ppg_locs_end,ecg_locs_end);

%% ����Ѫѹֵ
[SYS_BP,DIA_BP]=computebpvalue(bp,bp_locs_end);

%% �����õ���ݺ�����
save realdata10 bp ppg ecg PPG_Features ECG_Features PPG_ECG_alingFeatures SYS_BP DIA_BP 
plot(ppg);


    


