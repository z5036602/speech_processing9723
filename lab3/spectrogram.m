function spectrogram(x,fs,window_length,incre_dura)
    STFT_Matrix = STFT(x,fs,window_length,incre_dura);
    mag = log(abs(STFT_Matrix));
    positive = mag(:,1:window_length/2);
    %maximum = max(positive,[],'all');
    %clims = [0 30];
    x = [0 length(x)/fs];
    y = [0 4000];
    data_matrix_flipping =  flip(positive,1);
    imagesc(x,y,positive');
   %h1 = axes ;
    set(gca,'YDir','normal')
    colorbar;

end 