function o=non_nan_inf(p)
o=p;
pp=p;
pp(isnan(pp))=0;
pp(isinf(pp))=0;
k=sign(p);         
o((k==-1) & isinf(p))=0;         
o((k==1) & isinf(p))=max(pp(:));
clear k p pp