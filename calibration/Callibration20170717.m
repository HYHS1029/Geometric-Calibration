clc; clear; close all
%%
SOD=337; %mm
OID=10.0; %mm
SID=SOD+OID;
theta=20;
angle_step=1;
det_h=1562;
det_v=1168;
proj_n=41;
pix_size_h=0.019;
pix_size_v=0.019;
det_pix_x = 1562;
det_pix_y = 1168;
pix_size = 0.019;
step = 1;
Be = 8.0; %mm

maxrad=22;         %%%% rat
minrad=10;      

fltr4LM_R=20;         %%%rat = 8    %%% mice=15
multirad=1;         %%%rat = 0.1    %%% mice=1
%  fltr4LM_R:   (Optional, default is 8, minimum is 3)
%               The radius of the filter used in the search of local
%               maxima in the accumulation array. To detect circles whose
%               shapes are less perfect, the radius of the filter needs
%               to be set larger.
%
% multirad:     (Optional, default is 0.5)
%               In case of concentric circles, multiple radii may be
%               detected corresponding to a single center position. This
%               argument sets the tolerance of picking up the likely
%               radii values. It ranges from 0.1 to 1, where 0.1
%               corresponds to the largest tolerance, meaning more radii
%               values will be detected, and 1 corresponds to the smallest
%               tolerance, in which case only the "principal" radius will
%               be picked up.
%%%
%%
[FilePara.filename, FilePara.filepath] = uigetfile( {'*.tif','TIFF-files (*.tif)';...
    '*.*',  'All Files (*.*)'},  'Pick a file', 'MultiSelect', 'on',[uigetdir,'\']);
disp('recheck all projection data');

mkdir([FilePara.filepath,'para7_fig/'])

tic
dist=zeros(1,proj_n);
pos_cent=[];

h = waitbar(0,'Please wait...');
for sni=1:proj_n
    
     waitbar(sni/proj_n);
     x = single(rgb2gray(imread(sprintf('%s%s',FilePara.filepath,FilePara.filename{sni}))));       
     x(x<255)=0;
     x(:,[1:600,1050:end])=0;
     x = x';     
     se = strel('disk',3);
     imgx = imfilter(imclose(x,se),ones(3)/9);     
%      x(:,1530:end)=0;
     [grdx, grdy] = gradient(x);
     grdmag = sqrt(grdx.^2 + grdy.^2);
     thres = max(grdmag(:))/25;  %%%rat=25(4% of the max)
     [accum,circen,cirrad] = CircularHough_Grd(imgx,[minrad,maxrad],thres,fltr4LM_R,multirad);  
     circen(:,3)=[sni;sni];
     pos_cent=[pos_cent;circen];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
     dist(sni)=norm(circen(1,:)-circen(2,:));
end
close(h);
%% calculate the sorce positions
S=[0 0 SOD/pix_size];
D_c=[0 0 -OID/pix_size];
pos_S=[];
figure(1);
for ii=1:proj_n
    P_b1=[pos_cent(2*ii-1,1)-det_pix_x/2, pos_cent(2*ii-1,2)-det_pix_y/2, -OID/pix_size];
    P_b2=[pos_cent(2*ii,1)-det_pix_x/2, pos_cent(2*ii,2)-det_pix_y/2, -OID/pix_size];
    slope_xy=atand((P_b2(2)-P_b1(2))/(P_b2(1)-P_b1(1)));
%     B1_c=[-Be/pix_size*cosd(slope_xy) -Be/pix_size*sind(slope_xy) 0];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
%     B2_c=[Be/pix_size*cosd(slope_xy) Be/pix_size*sind(slope_xy) 0];
    B1_c=[cosd(slope_xy) -sind(slope_xy) 0; sind(slope_xy) cosd(slope_xy) 0; 0 0 1]*[-Be/pix_size 0 0]';
    B2_c=[cosd(slope_xy) -sind(slope_xy) 0; sind(slope_xy) cosd(slope_xy) 0; 0 0 1]*[Be/pix_size 0 0]';
    Vec_l1=B1_c'-P_b1;
    Vec_l2=B2_c'-P_b2;
    
    % AX=B
    A=[Vec_l1',-Vec_l2'];B=(P_b2-P_b1)';
    X=A\B;
    S=P_b1+Vec_l1*X(1);
    pos_S=[pos_S;S];
    line([S(1), B1_c(1), P_b1(1),P_b2(1), B2_c(1),S(1)],...
         [S(2),B1_c(2), P_b1(2),P_b2(2), B2_c(2),S(2)],...
         [S(3),B1_c(3), P_b1(3),P_b2(3), B2_c(3),S(3)]);hold on;
    
%      line([ P_b1(1),P_b2(1)],...
%          [ P_b1(2),P_b2(2)],...
%          [ P_b1(3),P_b2(3)]);
    grid on;
    plot3([B1_c(1), B2_c(1)],[B1_c(2), B2_c(2)],[B1_c(3), B2_c(3)],'.b');
    hold on;
end
hold off;
%% calculate the initial sorce postion
s=[0-det_pix_x/2 0-det_pix_y/2 SOD/pix_size];
postion=[];
shift_x=[];
shift_y=[];
shift_z=[];
for alpha=-theta:step:theta
    S_c=[cosd(alpha) 0 sind(alpha);0 1 0;-sind(alpha) 0 cosd(alpha)]*s';
    postion=[postion;S_c'];
end
%% calculate the sorce shift
for i=1:proj_n
    shift_x=[shift_x;pos_S(i,1)-postion(42-i,1)];
    shift_y=[shift_y;pos_S(i,2)-postion(42-i,2)];
    shift_z=[shift_z;pos_S(i,3)-postion(42-i,3)];
end
x1=shift_x*0.019; x_mean=mean((x1))
y1=shift_y*0.019; y_mean=mean((y1))
z1=shift_z*0.019; z_mean=mean((z1))
