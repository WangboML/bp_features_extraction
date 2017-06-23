function wl = waveletMethodB(data)
    % WAVELETMETHODB - 用于进行正交小波变换
    %   waveletMethodB(B)对B进行下列步骤
    %   1.求n阶差分
    %   2.求尺度为scale的bior6.8小波变换
    %   3.求小波变换的的归一化序列
    %% 预定义
    n = 1; 
    scale = 8;
    %% 1
    wl = diff(data,n);
    wl = [zeros(n,1);wl(:)];
    %% 2
    wl = cwt(wl,scale,'bior6.8');
    %% 3
    wl = wl/max(abs(wl));
end