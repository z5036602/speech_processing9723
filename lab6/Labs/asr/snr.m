function output = snr(signal,noise)
    
        output=10*log10(mean((signal).^2)/mean(noise.^2));
   




end 