function kte = AGetKTE(ppg)
% ‰»Î–≈∫≈Œ™
len=length(ppg);
kte(1)=0;
kte(len)=0;
for i=2:len-1
    kte(i)=ppg(i).^2-ppg(i-1).*ppg(i+1);
end
end