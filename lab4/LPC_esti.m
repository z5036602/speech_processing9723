function [mag_response,w_new] = LPC_esti(x,order,fs)
    %%% debugging line
    timemag_full = abs(fft(x));
    timemag_half = timemag_full(1:length(timemag_full)/2);
    %%%
    [r,lg] = xcorr(x,'biased');
    r(lg<0) = [];
    output = levinson(r,order);
    [h,w] = freqz(1,output);
    
    mag_response = abs(h);
    [~,for_1] = findpeaks(mag_response);
    if (length(for_1)<3 && length(for_1)>=2)
     w_new(1) =  for_1(1)./length(w)*(fs/2);   
     w_new(2) =  for_1(2)./length(w)*(fs/2);   
     w_new(3) = 0;
    elseif (length(for_1)<2 && length(for_1)>=1)
       w_new(1) =  for_1(1)./length(w)*(fs/2);   
       w_new(2) = 0;
       w_new(3) = 0;
    elseif (length(for_1)>=3)
       w_new(1) =  for_1(1)./length(w)*(fs/2);   
       w_new(2) =  for_1(2)./length(w)*(fs/2);   
       w_new(3) =  for_1(3)./length(w)*(fs/2);   
    end
    
end