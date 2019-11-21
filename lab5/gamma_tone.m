%%% this function will create a gamma_tone scales filter banks
% input:
% fc--> the center frequencies of the gamma_tone filters 
% fs --> sampling frequency
% output:
% filter_bank --> matrix with row as filter, whole matrix formed a filter
% bank
function filter_bank = gamma_tone(fc,fs,n)
T = 1/fs;
t = n*T;
a = 1;
b = 1.019;
N = 4;
filter_bank = zeros(length(fc),length(t));
for k = 1:length(fc)
    EBR = 24.7 + 0.108*fc(k);
    p = a.*t.^(N-1).*exp(-2*pi*b*EBR.*t).*cos(2*pi*fc(k).*t);
    normalization_factor = max(abs(fft(p)));
    filter_bank(k,:) = p/normalization_factor;
end 
end