function formants_matrix = three_formants_matrix(x,fs,length,incre_dura,win)
    incre = incre_dura; 
    order = 25;
    window_matrix = enframe(x,length,incre);
    formants_matrix = zeros(size(window_matrix,1),3);
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
    
%     sig_mag = abs(window_matrix);
%     energy = sum(sig_mag,2);
%     energy_threshold = 0.6*mean(energy);
%     energy_frame_slection = find(energy<=energy_threshold);
%     ZCR_vector = ZCR(window_matrix');
%     crossing_rate_threshold = 0.8*mean(ZCR_vector);
%     ZCR_frame_selection = find(ZCR_vector>=crossing_rate_threshold);
%     frame_selection = intersect(energy_frame_slection,ZCR_frame_selection);
%     f_0_time = zeros(size(window_matrix,1),1);
    %assert(fs/min_f<length,'fs/RANGE(1) < WINDOWLENGTH');
    
    preemph = [1 0.63];
    for k = 1:size(window_matrix,1)
        window_matrix(k,:) = filter(1,preemph,window_matrix(k,:).*transpose(my_window));
  
        [~,formants] = LPC_esti(window_matrix(k,:),order,fs);
        formants_matrix(k,:) =formants; 
    end
    

%     formants_matrix(frame_selection,:) = 0;




end