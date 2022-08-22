clc
clear all
for i=0:20
temp=int2str(1000+i);
str=[temp(3:end),'.dat'];
fid=fopen(str,'r');
img=fread(fid,[1004 896],'float32');
fclose(fid);
newimg=NOR(img);
newimg=uint16(newimg);
strr=[temp(3:end),'.tiff'];

imwrite(newimg,strr,'tiff');
end