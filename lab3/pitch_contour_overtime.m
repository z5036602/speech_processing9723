function f_0_time = pitch_contour_overtime(x,fs,length,incre_dura,min_f,max_f)
    incre = incre_dura*fs; 
    window_matrix = enframe(x,length,incre);
    sig_mag = abs(window_matrix);
    energy = sum(sig_mag,2);
    energy_threshold = 0.6*mean(energy);
    energy_frame_slection = find(energy<=energy_threshold);
    ZCR_vector = ZCR(window_matrix');
    crossing_rate_threshold = 0.8*mean(ZCR_vector);
    ZCR_frame_selection = find(ZCR_vector>=crossing_rate_threshold);
    frame_selection = intersect(energy_frame_slection,ZCR_frame_selection);
    f_0_time = zeros(size(window_matrix,1),1);
    assert(fs/min_f<length,'fs/RANGE(1) < WINDOWLENGTH');
    for k = 1:size(f_0_time,1)
        f_0_time(k) = pitch_detection (window_matrix(k,:),fs,80,260);
    end 
    f_0_time(frame_selection,:) = 0;
end 