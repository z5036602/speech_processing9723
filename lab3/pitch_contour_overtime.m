function f_0_time = pitch_contour_overtime(x,fs,length,incre_dura)
   incre = incre_dura*fs; 
    window_matrix = enframe(x,length,incre);
    
    
    f_0_time = zeros(size(window_matrix,1),1);
    for k = 1:size(f_0_time,1)
        f_0_time(k) = pitch_detection (window_matrix(k,:),fs,80,260);
    end 
    
end 