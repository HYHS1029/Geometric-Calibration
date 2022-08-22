# Geometric calibration
 * calibration 
 1. 將校正仿體影像讀入Callibration20170717.m 
  → 輸入拍攝條件  
  SOD:光源至物體的距離(source to object distance)  
  OID:物體至偵測器的距離(object to detector distance)  
  theta:拍攝角度  
  angle_step:角度間隔  
  proj_n:拍攝影像張數  
  → 取得校正參數(6 parameters)  
  CircularHough_Grd.m 會辨識校正仿體x-ray影像上鋼珠的座標，再藉由Callibration20170717.m計算出校正參數(x,y,z axis shift and rotation angle)  
  Callibration20170717.m 與 CircularHough_Grd.m 需放於同一資料夾內  
 2. 取得校正參數後，使用reprojection_DTS_single.m 對拍攝的影像進行reprojection，即完成校正，可接著進行影像重建  
 
***
 * image reconstruction  
 1.	將檔案轉為tif檔  
→將dat_C_tiff.m和NOR.m這兩個檔案與欲轉檔的dat檔至於同一資料夾  
→執行dat_C_tiff.m  
2.	輸入重建條件  
→Det_w=X/2;Det_h=Y/2 → X填入圖檔的寬、Y填入高  
→angle_range=θ → 填入掃描角度(-θ~θ)  
→angle_step= Δ→ 填入角度間隔  
→檔名=filemov; →在檔名處輸入重建後data的檔名  
→filename='檔名'  
→save(filename,'檔名','-v7.3')  
3.	選擇圖檔  
4.	開始重建  
