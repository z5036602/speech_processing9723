function output = STFT(x,fs,length,incre_dura)
    incre = incre_dura*fs; 
    window_matrix = enframe(x,length,incre);
    pow = ceil(log2(size(window_matrix,2))); %pad with zeros if not length of power 2
    
    output = zeros(size(window_matrix,1),2^pow);
   
    for k = 1:size(window_matrix,1)
        output(k,:) = FFT(window_matrix(k,:));
    end 
end 