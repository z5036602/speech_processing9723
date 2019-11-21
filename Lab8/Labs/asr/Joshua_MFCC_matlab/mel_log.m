function output = mel_log (FFT_matrix,Bank_number,fs,f_low,f_high,nfft)
    Mel_banks = mel_bank_instance(size(FFT_matrix,2),Bank_number,fs,f_low,f_high,nfft);
    H = zeros(1,Bank_number);
    output = zeros(size(FFT_matrix,1),Bank_number);
    for j = 1:size(FFT_matrix,1)
        for i = 1:Bank_number
            if sum( FFT_matrix (j,:) .*  Mel_banks (i,:)) ~= 0
                H(i) = log(sum( FFT_matrix (j,:) .*  Mel_banks (i,:))); 
            else 
                H(i) = 0;
            end 
        end 
        output(j,:) = H;
    end
