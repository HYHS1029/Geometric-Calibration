
% clc;clear;close all;          
clc
det_pix_x = 1168; 
det_pix_y = 1562; 
pix_size = 0.019;  
proj_n   = 41;  % projection 數量
step = 1;   %角度間隔

input_data_path  = 'C:\Users\user\Desktop\實驗室\Callibration_new\2017.07.10拍攝影像\YM_phantom_02\軸心位置_620\';


for proj= 0 : proj_n-1
    %%  input 6 parameters

    OID = 0;   %(mm)
    SOD = 347;  %(mm)
    x_shift= 0;  %(mm)                      
    y_shift= 0;  %(mm)   
    eta = 0   *pi/180;
    phi = 0   *pi/180;
    theta = (-20 + (proj*step))  *pi/180;  % 掃描角度

    %% calculate the rotated positions
    pos_S1=pos_S*0.019;
    SID = OID+SOD; 
    value_zero = 0;
    
    [Sa,Sb,Sc] = rot (x_mean, y_mean, -SOD-z_mean, theta, phi, eta);
    
    a=zeros(det_pix_y*det_pix_x,1);
    b=a;
    c=a;

    for x = 1:det_pix_x
        for y = 1: det_pix_y
        
        x_initial = (x - (det_pix_x+1)/2)*pix_size;
        y_initial = (y - (det_pix_y+1)/2)*pix_size;
        
        intersec_x = (Sc*SOD*x_initial)/(Sa*x_initial+Sb*y_initial+Sc*SID);                    
        intersec_y = (Sc*SOD*y_initial)/(Sa*x_initial+Sb*y_initial+Sc*SID);
        intersec_z = ((-Sa*x_initial-Sb*y_initial-Sc*OID)*SID)/(Sa*x_initial+Sb*y_initial+Sc*SID);
        
        [a((x-1)*det_pix_y+y),b((x-1)*det_pix_y+y),c((x-1)*det_pix_y+y)] = invers_rot(intersec_x, intersec_y, intersec_z, -theta, -phi, -eta);
                 
        a((x-1)*det_pix_y+y) = a((x-1)*det_pix_y+y)/pix_size + (det_pix_x+1)/2;
        b((x-1)*det_pix_y+y) = b((x-1)*det_pix_y+y)/pix_size + (det_pix_y+1)/2;
             
        end
    end
    
    reprojected_projection = zeros(det_pix_y,det_pix_x);
    input_proj_data = imread([input_data_path,sprintf('%d',proj),'.tif']);
    ori_proj_data = double(rgb2gray(input_proj_data));
%     fid  = fopen([input_data_path,sprintf('%d',proj),'.raw'],'r');
%     ori_proj_data = fread(fid,'uint16');
%     ori_proj_data =reshape(ori_proj_data, [det_pix_x,det_pix_y]);
%     fclose(fid);

    
    %x_shift
            if x_shift>=0
                shifted_proj_data= value_zero * ones(det_pix_y,det_pix_x);
                shifted_proj_data(:,(round(x_shift/pix_size)+1):det_pix_x)= ori_proj_data(:,1:(det_pix_x-round(x_shift/pix_size)));
            else
                x_shift_mod=-x_shift;
                shifted_proj_data= value_zero * ones(det_pix_y,det_pix_x);
                shifted_proj_data(:,(1:(det_pix_x-round(x_shift_mod/pix_size))))= ori_proj_data(:,(round(x_shift_mod/pix_size)+1):det_pix_x);
                
            end


     %y_shift
            if y_shift>=0
                shifted_proj_data(1:(det_pix_y-round(y_shift/pix_size)),:)=shifted_proj_data(round(y_shift/pix_size)+1:det_pix_y,:);
                shifted_proj_data((det_pix_y-round(y_shift/pix_size)+1):det_pix_y,:) = value_zero;
            else
                y_shift_mod = - y_shift;
                shifted_proj_data((round(y_shift_mod/pix_size)+1):det_pix_y,:)=shifted_proj_data(1:(det_pix_y-round(y_shift_mod/pix_size)),:);
                shifted_proj_data(1:(round(y_shift_mod/pix_size)),:) = value_zero;
            end

    
    for x = 1: det_pix_x
        for y = 1: det_pix_y
            
            
            %rotate
             
            if b((x-1)*det_pix_y+y) >= 1 && b((x-1)*det_pix_y+y) < det_pix_y && a((x-1)*det_pix_y+y) >= 1 && a((x-1)*det_pix_y+y) < det_pix_x
                    x_floor = floor(a((x-1)*det_pix_y+y));
                    y_floor = floor(b((x-1)*det_pix_y+y));
                    x_dis = a((x-1)*det_pix_y+y) - x_floor;
                    y_dis = b((x-1)*det_pix_y+y) - y_floor;
                    reprojected_projection(y,x) =  shifted_proj_data(y_floor,x_floor)    * x_dis      * y_dis    +... 
                                                   shifted_proj_data(y_floor+1,x_floor)  *(1-x_dis)   * y_dis    +...
                                                   shifted_proj_data(y_floor,x_floor+1)  * x_dis      *(1-y_dis) +...
                                                   shifted_proj_data(y_floor+1,x_floor+1)*(1-x_dis)   *(1-y_dis) ;

             else
                    reprojected_projection(y,x) = value_zero;
             end

    
        end
    end

 
     disp(['projection number = ' int2str(proj)])
%     fid = fopen([output_data_path,sprintf('%d',proj),'.raw'],'w');
%     fwrite(fid,uint16(reprojected_projection),'uint16');
%     fclose(fid);

    imwrite(uint16((reprojected_projection/max(reprojected_projection(:)))*65535),sprintf('%d.tif',proj));
    
    end

    
    
    
    


