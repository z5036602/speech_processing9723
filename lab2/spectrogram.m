function spectrogram(x,fs,length,incre_dura)
    STFT_Matrix = STFT(x,fs,length,incre_dura);
    mag = log(abs(STFT_Matrix));
    positive = mag(:,1:length/2);
    %maximum = max(positive,[],'all');
    %clims = [0 30];
    x = [0 900];
    y = [0 4000];
    data_matrix_flipping =  flip(positive,1);
    imagesc(x,y,positive');
   %h1 = axes ;
    set(gca,'YDir','normal')
    colorbar;

end 