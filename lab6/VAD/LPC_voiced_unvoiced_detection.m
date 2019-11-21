function y = LPC_voiced_unvoiced_detection(x)
    y = zeros(size(x,1),1);
    for i = 1:size(x,1)
    
        [r,lg] = xcorr(x(i,:),'biased');
        r(lg<0) = [];
        output = levinson(r,12);
        y(i) = output(2);
    
    end 

end