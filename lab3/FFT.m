function fft_out = FFT(x) %recursive radix-2 fft
    pow = ceil(log2(length(x))); %pad with zeros if not length of power 2
    x = vertcat(reshape(x,[length(x) 1]), zeros(2^pow-length(x),1));
    N = length(x);
    if N == 1 
        fft_out = x;
    else 
        x_even = FFT(x(1:2:N-1)); %split 
        x_odd = FFT(x(2:2:N));
        w = exp(-j*2*pi/N).^(0:N/2-1); 
        fft_out = [(x_even + w.*x_odd), (x_even - w.*x_odd)];
    end
end