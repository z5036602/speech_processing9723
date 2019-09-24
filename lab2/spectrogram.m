function spectrogram(x,fs,length,incre_dura)
    STFT_Matrix = STFT(x,fs,length,incre_dura);
    mag = abs(STFT_Matrix);
    figure;
    positive = mag(:,1:length/2);
    %maximum = max(positive,[],'all');
    clims = [0 30];
    x = [0 900];
    y = [0 4000];
    data_matrix_flipping =  flip(positive,1);
    imagesc(x,y,positive',clims);
   %h1 = axes ;
    set(gca,'YDir','normal')
    colorbar;

end 