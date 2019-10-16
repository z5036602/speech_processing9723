function f_0_time = pitch_contour_overtime(x,fs,length,incre_dura,min_f,max_f,win)
    incre = incre_dura; 
    window_matrix = enframe(x,length,incre);
    switch win
        case 'hamming'
            my_window = hamming(length);
        case 'hanning'
            my_window = hann(length);
        case 'balckman'
            my_window = blackman(length);
        otherwise
            my_window = rectwin(length);
    end
    
    for k = 1:size(window_matrix,1)
        window_matrix(k,:) = window_matrix(k,:).*transpose(my_window);
    end
    
    unvoiced_frame_selection = VAD(window_matrix);
    
    f_0_time = zeros(size(window_matrix,1),1);
    assert(fs/min_f<length,'fs/RANGE(1) < WINDOWLENGTH');
    
    for k = 1:size(f_0_time,1)
        f_0_time(k) = pitch_detection (window_matrix(k,:),fs,min_f,max_f);
    end 
    f_0_time(unvoiced_frame_selection,:) = 0;
end 