%/////////////////////////////////////////////////
%
%   简易小波滤波器，用于去除特定的details并重建信号：
%   输入：data 1*N ,wavename,n(阶数)，save（要保留的阶）,flag(是否将最底层的ca置零)
%   输出：output
%
%/////////////////////////////////////////////////

function [output] = wavefilter(data,wavename,n,save,flag)
    [C,L]=wavedec(data,n,wavename);
    %提取尺度系数
    ca=appcoef(C,L,wavename,n);
    if flag==0
        ca=zeros(1,length(ca));
    end
    
    %提取细节系数
    for i=1:n
        cd=detcoef(C,L,n+1-i);
        if(ismember(n+1-i,save)==0)
            %将details清零
            cd = zeros(1,length(cd));
        end
        ca=[ca cd];
    end
    %重建信号
    output=waverec(ca,L,wavename);
end