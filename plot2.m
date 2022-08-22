clc
clear all
displa=gaussmf(0,5,1000);
Aref=1;
Asam=1;
I=(1/2)*(Aref^2)+(1/2)*(Asam^2)+(Aref*Asam)*cos((2*pi)/0.5*2*displa);
line(displa,I)
title('Intensity versus mirror displacement');
xlabel('displacement(£gm)');
ylabel('Intensity');