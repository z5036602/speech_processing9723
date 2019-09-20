function joshuaplot(x,fs,B)
    freq_spec_unvoiced = abs(fftshift(fft(x)));
    f = linspace(-fs/2,fs/2,256);
    figure;
    plot(f,log(freq_spec_unvoiced));
    title(B)
    xlim([0 fs/2]);
    




end 