function FFT_output = FFT_matrix(frames) % win = framelength inc = fram step
%ENFRAME split signal up into (overlapping) frames: one per row. F=(X,WIN,INC)
nfft = 512;
FFT_output = zeros(size(frames,1),nfft);
    for i=1:size(frames,1)
      FFT_output (i,:) = fft(frames(i,:),nfft);
    end
FFT_output = FFT_output(:,1:nfft);
end


