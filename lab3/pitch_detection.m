function f_0 = pitch_detection (x,fs,minimum_f,maximum_f)
    [acs] = empirical_autocorr(x);
    maximum_samples = floor(fs/minimum_f);
    minimum_samples = floor(fs/maximum_f);
    pos = find(acs == max(acs(minimum_samples:maximum_samples)));%%window is too small??
    
    f_0 = 1/(pos/fs);
   



end 