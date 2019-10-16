%%this function plot phase and magnitude response of signal
function joshuaplot(x,fs,B)
    freq_spec_unvoiced = abs(fftshift(fft(x)));
    f = linspace(-fs/2,fs/2,length(x));
    figure;
    plot(f,log(freq_spec_unvoiced));
    C =  ' Frequency plot';
    title(strcat(B,C));
    xlabel('Frequency'), 
    ylabel('Phase')
    xlim([0 fs/2]);
    
    
    figure; 
    plot(f, angle(fftshift(fft(x))));
    C = ' Phase plot';   
    title(strcat(B,C)), 
    xlabel('Frequency'), 
    ylabel('Phase')
    xlim([0 fs/2]);



end 