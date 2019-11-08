function filter_bank = gamma_tone(fc,fs,n)
%fc = [50 150 250 350 450 570 700 840 1000 1170 1370 1600 1850 2150 2500 2900 3400];
%fs = 8000;
T = 1/fs;
%EBR = 24.7 + 0.108*fc;
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

% %figure;
% %plot(filter_bank(14,:));
% %%%plotting frequency response
% figure;
% for k = 1:length(fc)
%     plot(filter_bank(k,:));
%     hold on 
% end  
end