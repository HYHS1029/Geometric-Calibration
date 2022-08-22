clear all

clc
tic;
% delete(gcp('nocreate')); 
% parpool('local',12);
% dir_name='C:\Users\User\Desktop\';%檔案資料夾
Det_w=1168/2;Det_h=1562/2;
% Det_w=896/2;Det_h=1004/2;
% angle_range=179;
angle_step=1;
pix=0.019;
bin=1;
% SOD=175;
% OID=5;
% SID=SOD+OID;
[filename, filepath] =uigetfile( {'*.*',  'All Files (*.*)'},...
    'Pick a file', 'MultiSelect','on');% UI多重選取DATA
S=zeros([Det_w,length(filename),Det_h],'single');%利用全0矩陣預做配置(melloc)
V=zeros([Det_w,Det_w,1,Det_h],'single');% 左右defeact 10 pixels
% theta=-angle_range:angle_step:angle_range;
theta=-10:angle_step:10;
% u_sh=OID*ones(size(theta))./cosd(theta);
% mkdir([filepath,'model_gcproj\']);


im2=zeros(Det_h,Det_w);
for xx=1:length(filename)

im8=imread([filepath,filename{xx}]);
for ii=1:Det_h
    for jj=1:Det_w
        im2(ii,jj)=sum(sum(im8(4*ii-3:4*ii,4*jj-3:4*jj)))/16;
    end
end
% % % % 

if size(im2,3)~=1
    im2=single(rgb2gray(im2));
end

im2(im2<=0)=0;
im2=non_nan_inf(im2);


im2=uint16(im2);
%  figure(1);imagesc(im2);axis image, axis off;colormap('gray');
    
    S(:,xx,:)=permute(im2,[2 3 1]);
end
% S([1:10,Det_w-9:Det_w],:,:)=[];
file=zeros(Det_w,Det_h,Det_w);
Ssize=size(S);
Bllxthis=65535*ones(Ssize(1),Ssize(2));
for ii=1:Det_h
    
    
    C=Bllxthis./S(:,:,ii);

C=non_nan_inf(C);
    D=log(C);

D=non_nan_inf(D);
    V(:,:,1,ii)=medfilt2(iradon(D,theta,Det_w));
    file(:,ii,:)=medfilt2(iradon(D,theta,Det_w));
%     XX1=reshape(file(:,ii,:),390,390,1);
%     figure(2);imagesc(XX1);axis image, axis off;colormap('gray');
    disp(ii);
end

V=non_nan_inf(V);
V=permute(V,[4 2 3 1]);
mov=V/(8*mean(V(:)));
implay(mov);


file=non_nan_inf(file);
filemov=file/(8*mean(file(:)));

shift=filemov;
filename='shift';
save(filename,'shift','-v7.3');
% movie2avi(mov, 'test1');
disp(sprintf('max=%3.3f',max(V(:))));
mkdir([filepath,'\Tomo\']);
fid=fopen([filepath,'\Tomo\CT_',int2str(size(V,1)),'x',int2str(size(V,2)),'x',int2str(size(V,4)),'_float.img'],'w');
fwrite(fid,V,'float');
fclose(fid);
V=uint8(V/max(V(:))*255);

for ii=1:size(V,4)
    imwrite(V(:,:,:,ii),[filepath,'\Tomo\DTS_',int2str(ii),'.tif'],'Compression','none');
end
toc;