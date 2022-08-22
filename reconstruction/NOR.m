function NOR=nor(a)
Omin=min(min(a));
Omax=max(max(a));
asize=size(a);
newa=zeros(asize(1),asize(2));
for i=1:asize(1)
    for j=1:asize(2)
        newa(i,j)=((a(i,j)-Omin)/(Omax-Omin))*65535;
    end
end
NOR=newa;