function [SYS_BP,DIA_BP]=computebpvalue(bp,bp_locs_end)

% ’Àı—πµƒ÷µ£∫
[px,py]=size(bp_locs_end);
SYS_BP=zeros(1,px);
DIA_BP=zeros(1,px);
for i=1:px
    SYS_BP(i)=bp(bp_locs_end(i,1));
    DIA_BP(i)=bp(bp_locs_end(i,2));


end






end