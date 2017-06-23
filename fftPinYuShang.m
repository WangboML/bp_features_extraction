function [entropy] = fftPinYuShang(data)
% 显示信号频谱图
%输入信号 
%data 默认采样率为1000,1*N

fs=1000;
Ndata=length(data);
N=2^nextpow2(Ndata);
ffts=fft(data,N);
% mag=abs(y);
% f=(0:N-1)*fs/N;
% plot(f(1:N/2),mag(1:N/2));
%对ffts做归一化
normffts=(abs(ffts).*2)./(ones(1,length(ffts))*(sum(abs(ffts).^2)));
%求熵值

    normffts = normffts.^2;
    normffts = normffts./(ones(1,length(normffts)) * sum(normffts));
    %from stackoverflow 22075285
    entropy = sum(- normffts.*log2(normffts));



end
