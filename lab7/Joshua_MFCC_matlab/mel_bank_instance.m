%%%this function creates a mel-filter-bank by configuration set by user
%output:
%Mel_bank_matrix --> a matrix that stores each mel filter to form the "filter bank"
%input:
%framelen --> length of window  Banks_number-->number of banks  
%sample_f sampling frequency  f_low-->lowest freqeucny cut off,
%f_high --> highest frequency cut off
%nfft --> number of fft
function Mel_bank_matrix = mel_bank_instance(framelen,Banks_number,sample_f,f_low,f_high,nfft)
M1 = 1127*log(1+f_low/700);
M2 = 1127*log(1+f_high/700);
y1 = linspace(M1,M2,Banks_number+2);
f_vector = 700*(exp(y1./1125)-1);
bin_vector = floor((nfft+1) *(f_vector./(sample_f)));
H = zeros(1,framelen);
Mel_bank_matrix = zeros(Banks_number,framelen);
for i = 2 :Banks_number+1
    for k = 1:framelen
        if k < bin_vector (i-1) 
            H(k) = 0;
        elseif k >= bin_vector (i-1) && k <= bin_vector (i)
             H(k) = (k- bin_vector (i-1))/( bin_vector (i)-bin_vector (i-1));  
        elseif k >= bin_vector (i) && k <= bin_vector (i+1)
             H(k) = (bin_vector (i+1)-k )/( bin_vector (i+1)-bin_vector (i));   
        elseif  k > bin_vector (i+1) 
             H(k) = 0;    
        end
    end
    Mel_bank_matrix(i-1,:) = H;
end
end
