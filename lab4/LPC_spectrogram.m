function LPC_spectrogram(x,fs,win_length,incre_dura,win)
    order = 25;
    incre = incre_dura; 
    window_matrix = enframe(x,win_length,incre);
    mag_response = zeros(size(window_matrix,1),512);
    switch win
        case 'hamming'
            my_window = hamming(win_length);
        case 'hanning'
            my_window = hann(win_length);
        case 'balckman'
            my_window = blackman(win_length);
        otherwise
            my_window = rectwin(win_length);
    end
    
    for k = 1:size(window_matrix,1)
        window_matrix(k,:) = window_matrix(k,:).*transpose(my_window);
        [mag_response(k,:),~] = LPC_esti(window_matrix(k,:),order,fs);
    end
    
    mag = log(mag_response);
    %positive = mag(:,1:window_length/2);
    %maximum = max(positive,[],'all');
    %clims = [0 30];
    x = [0 floor(length(x)/fs)];
    y = [0 8000];
    data_matrix_flipping =  flip(mag,1);
    imagesc(x,y,mag');
   %h1 = axes ;
    set(gca,'YDir','normal')
    colorbar;




end