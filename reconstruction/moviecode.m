clc
clear all
close all


load('topan.mat');
aviobj = avifile('topan.avi','compression','None');
FanPsize=size(topan);
fig=figure;
%  for kk=1:3
for k=1:1:FanPsize(1)
    temp=reshape(topan(k,:,:),FanPsize(2),FanPsize(3))';
 imagesc(temp,[0 2]);axis image, axis off;colormap('gray');
%   pause(0.3);

    F = getframe(fig);
    aviobj = addframe(aviobj,F);
end
% for k=1:2:FanPsize(2)
%     temp=reshape(test1005(:,k,:),FanPsize(1),FanPsize(3))';
%  imagesc(temp);axis image, axis off
% %   pause(0.3);
% 
%     F = getframe(fig);
%     aviobj = addframe(aviobj,F);
% end
% for k=1:2:FanPsize(3)
%     temp=reshape(dicom0623(:,:,k),FanPsize(1),FanPsize(2))';
%  imagesc(temp);axis image, axis off
% %   pause(0.3);
% 
%     F = getframe(fig);
%     aviobj = addframe(aviobj,F);
% end
%  end
% close(fig);
% temp1=reshape(FanP(:,50,:),170,170)';
% figure(2);imagesc(temp1);axis image, axis off
aviobj = close(aviobj);



