function DTS_ITRI
tic;
% delect(gcp('nocreat'));
% parpool('local',12);
% dir_name='C:\Users\User\Desktop\';%�ɮ׸�Ƨ�
%Det_w=1562/2;Det_h=1168/2;
Det_w=896/2;Det_h=1004/2;
angle_range=20;
angle_step=2;
pix=0.038;
bin=1;
SOD=192.5;
OID=7.5;
SID=SOD+OID;
[filename, filepath]=uigetfile( {'*.*', 'All Files(*.*)'},...
    'Pick a file', 'MultiSelect', 'on');% UI�h�����DATA
S=zeros([Det_w,length(filename),Det_h])% �Q�Υ�0�x�}�w���t�m(melloc)
V=zeros([Det_w,Det_w,1,Det_h], 'single');% ���kdefeact 10 pixels
theta=-angle_range:angle_step:angle_range;
u_sh=OID*ones(size(theta)))./cosd(theta);
mkdir([filepath, 'modle_gcproj\']);

