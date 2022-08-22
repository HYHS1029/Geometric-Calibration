# Geometric calibration
 ## image reconstruction
 1.	將檔案轉為tif檔
→將dat_C_tiff.m和NOR.m這兩個檔案與欲轉檔的dat檔至於同一資料夾
→執行dat_C_tiff.m 
2.	輸入重建條件
→Det_w=X/2;Det_h=Y/2 → X填入圖檔的寬、Y填入高
→angle_range=θ → 填入掃描角度(-θ~θ)
→angle_step= Δ→ 填入角度間隔
→檔名=filemov; →在檔名處輸入重建後data的檔名
→filename='檔名';
→save(filename,'檔名','-v7.3');
3.	選擇圖檔
4.	開始重建
