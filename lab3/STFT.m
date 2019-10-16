function output = STFT(x,fs,length,incre_dura,win)
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
    pow = ceil(log2(size(window_matrix,2))); %pad with zeros if not length of power 2
    
    output = zeros(size(window_matrix,1),2^pow);
   
    for k = 1:size(window_matrix,1)
        output(k,:) = FFT(window_matrix(k,:));
    end 
end 