function [PPG_Features,ECG_Features,PPG_ECG_alingFeatures]=computeFeatureInPPG(ppg,ecg,ppg_locs_end,ecg_locs_end)
%% 计算PPG信号独有的特征
%首先将原始PPG信号转换成KTE函数
ktes = AGetKTE(ppg);
len=size(ppg_locs_end,1);
PPG_Features=zeros(len,31);
for i=1:len
    PH=ppg(ppg_locs_end(i,2))-ppg(ppg_locs_end(i,1));
    DNH=ppg(ppg_locs_end(i,3))-ppg(ppg_locs_end(i,1));
    DNHr=DNH/PH;
    DPH=ppg(ppg_locs_end(i,4))-ppg(ppg_locs_end(i,1));
    DPHr=DPH/PH;
    RBW=(ppg_locs_end(i,2)-ppg_locs_end(i,1))*10^(-3);
    %计算上升支宽度
    RBW10=ppg_locs_end(i,2) - ppg_locs_end(i,1)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)),0.1);
    RBW25=ppg_locs_end(i,2) - ppg_locs_end(i,1)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)),0.25);
    RBW33=ppg_locs_end(i,2) - ppg_locs_end(i,1)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)),0.33);
    RBW50=ppg_locs_end(i,2) - ppg_locs_end(i,1)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)),0.50);
    RBW75=ppg_locs_end(i,2) - ppg_locs_end(i,1)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)),0.75);
    RBW10=RBW10*10^(-3);
    RBW25=RBW25*10^(-3);
    RBW33=RBW33*10^(-3);
    RBW50=RBW50*10^(-3);
    RBW75=RBW75*10^(-3);
    %计算下降支宽度
    DBW10=ppg_locs_end(i,5) - ppg_locs_end(i,2)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,2):ppg_locs_end(i,5)),0.1);
    DBW25=ppg_locs_end(i,5) - ppg_locs_end(i,2)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,2):ppg_locs_end(i,5)),0.25);
    DBW33=ppg_locs_end(i,5) - ppg_locs_end(i,2)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,2):ppg_locs_end(i,5)),0.33);
    DBW50=ppg_locs_end(i,5) - ppg_locs_end(i,2)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,2):ppg_locs_end(i,5)),0.50);
    DBW75=ppg_locs_end(i,5) - ppg_locs_end(i,2)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,2):ppg_locs_end(i,5)),0.75);
    DBW10=DBW10*10^(-3);
    DBW25=DBW25*10^(-3);
    DBW33=DBW33*10^(-3);
    DBW50=DBW50*10^(-3);
    DBW75=DBW75*10^(-3);
    
    PDNT=(ppg_locs_end(i,3) - ppg_locs_end(i,2))*10^(-3);
    DNDPT=(ppg_locs_end(i,4) - ppg_locs_end(i,2))*10^(-3);
    
    %计算K值
    len1=ppg_locs_end(i,5) - ppg_locs_end(i,1);
    meanppg=0;
    for j=0:len1
        meanppg=meanppg+ppg(ppg_locs_end(i,1)+j);
    end
    meanppg=meanppg/(len1+1);
    KVAL=(meanppg-ppg(ppg_locs_end(i,1)))/(ppg(ppg_locs_end(i,2))-ppg(ppg_locs_end(i,1)));
    
    %计算各种面积
    minPPG= min(ppg);
    PWA=calcArea(ppg(ppg_locs_end(i,1):ppg_locs_end(i,5)) - minPPG);
    RBAr=calcArea(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)) - minPPG) / PWA;
    DBAr=calcArea(ppg(ppg_locs_end(i,2):ppg_locs_end(i,5)) - minPPG) / PWA;
    DiaAr=calcArea(ppg(ppg_locs_end(i,3):ppg_locs_end(i,5)) - minPPG) / PWA;
    
    %平均斜率
    SLP1=(ppg(ppg_locs_end(i,2))-ppg(ppg_locs_end(i,1)))/(ppg_locs_end(i,2)-ppg_locs_end(i,1));
    SLP2=(ppg(ppg_locs_end(i,2))-ppg(ppg_locs_end(i,5)))/(ppg_locs_end(i,5)-ppg_locs_end(i,2));
    SLP3=(ppg(ppg_locs_end(i,4))-ppg(ppg_locs_end(i,5)))/(ppg_locs_end(i,5)-ppg_locs_end(i,4));
    
    %AmBE
%     AmBE=mean(ppg(ppg_locs_end(i,2):ppg_locs_end(i,1)+99) - ppg(ppg_locs_end(i,2)+100));
    AmBE=sum(ppg(ppg_locs_end(i,2):ppg_locs_end(i,2)+99)-ppg(ppg_locs_end(i,2)+100))/ppg(ppg_locs_end(i,2))/100;
    %能量特征
    %1每个心搏周期内的能量E的对数
    E=log2(sum(ppg(ppg_locs_end(i,1):ppg_locs_end(i,5)).^2));
    %KTE的统计系数
    KTEMIU=mean(ktes(ppg_locs_end(i,1):ppg_locs_end(i,5)));
    KTEDELTA=var(ktes(ppg_locs_end(i,1):ppg_locs_end(i,5)));
     %频域熵
    ENTROP = fftPinYuShang(ppg(ppg_locs_end(i,1):ppg_locs_end(i,5)));
     
    %组成特征矩阵
    PPG_Features(i,1)=PH;
    PPG_Features(i,2)=DNH;
    PPG_Features(i,3)=DNHr;
    PPG_Features(i,4)=DPH;
    PPG_Features(i,5)=DPHr;
    PPG_Features(i,6)=RBW;
    PPG_Features(i,7)= RBW10;
    PPG_Features(i,8)=RBW25;
    PPG_Features(i,9)=RBW33;
    PPG_Features(i,10)=RBW50;
    PPG_Features(i,11)=RBW75;
    PPG_Features(i,12)=DBW10;
    PPG_Features(i,13)=DBW25;
    PPG_Features(i,14)=DBW33;
    PPG_Features(i,15)=DBW50;
    PPG_Features(i,16)=DBW75;
    PPG_Features(i,17)=PDNT;
    PPG_Features(i,18)=DNDPT;
    PPG_Features(i,19)=KVAL;
    PPG_Features(i,20)= PWA;
    PPG_Features(i,21)= RBAr;
    PPG_Features(i,22)=DBAr;
    PPG_Features(i,23)=DiaAr;
    PPG_Features(i,24)=SLP1;
    PPG_Features(i,25)=SLP2;
    PPG_Features(i,26)=SLP3;
    PPG_Features(i,27)=AmBE;
    PPG_Features(i,28)= E;
    PPG_Features(i,29)=KTEMIU;
    PPG_Features(i,30)= KTEDELTA;
    PPG_Features(i,31)=ENTROP;

end
  
    
    %% 求ECG信号独有的特征
     ECG_Features=zeros(len,5);
    for i=1:len
%         T_PR=(ecg_locs_end(i,3)-ecg_locs_end(i,1))*10^(-3);
        T_QR=(ecg_locs_end(i,2)-ecg_locs_end(i,1))*10^(-3);
        T_RS=(ecg_locs_end(i,3)-ecg_locs_end(i,2))*10^(-3);
%         T_RT=(ecg_locs_end(i,5)-ecg_locs_end(i,3)*10^(-3));
        if i==len
            T_RR=(ecg_locs_end(i,2)-ecg_locs_end(i-1,2))*10^(-3);
        else
            T_RR=(ecg_locs_end(i+1,2)-ecg_locs_end(i,2))*10^(-3);
        end
        H_QR=ecg(ecg_locs_end(i,1))-ecg(ecg_locs_end(i,2));
        H_RS=ecg(ecg_locs_end(i,3))-ecg(ecg_locs_end(i,2));
        
        %组成特征矩阵
        ECG_Features(i,1)=T_QR;
        ECG_Features(i,2)=T_RS;
        ECG_Features(i,3)=T_RR;
        ECG_Features(i,4)=H_QR;
        ECG_Features(i,5)=H_RS;
       
            
    end
    
    
    %% 求ECG和PPG信号的联合特征
    PPG_ECG_alingFeatures=zeros(len,3);
    for i=1:len
        PWTT_RP=(ppg_locs_end(i,2)-ecg_locs_end(i,2))*10^(-3);
        PWTT_RO=(ppg_locs_end(i,1)-ecg_locs_end(i,2))*10^(-3);
        TT=ppg_locs_end(i,2) - ppg_locs_end(i,1)-detectKpercentKeyPoint(ppg(ppg_locs_end(i,1):ppg_locs_end(i,2)),0.25);
        PWTT_RhalfP=TT*10^(-3)+PWTT_RO;
        % 组成矩阵向量
        PPG_ECG_alingFeatures(i,1)=PWTT_RP;
        PPG_ECG_alingFeatures(i,2)=PWTT_RO;
        PPG_ECG_alingFeatures(i,3)=PWTT_RhalfP;
    end
   
        
    
end



