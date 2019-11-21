function output = noise_generator(signal,snrdb)
    %utput=10*log10(mean((signal).^2)/mean(noise.^2));
    output = mean((signal).^2)/(10^(snrdb/10));

end 