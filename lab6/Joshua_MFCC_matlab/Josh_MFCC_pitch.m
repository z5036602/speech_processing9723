% 3/9/2019 Zhengyue LIU 
function [output,f_0,voiced_frames] = Josh_MFCC_pitch (x,fs,FrameLen,inc,f_low,f_high,bank_number,delta)
% f_0 = pitch(x,fs, ...
%      'WindowLength',400, ...
%      'OverlapLength',(400-160), ...
%       'Range',[50 350], ...
%       'Method','NCF');

Frames_matrix  = enframe(x, FrameLen,inc);
%voiced_frame  = VAD(Frames_matrix);

number_of_frames = size(Frames_matrix,1);


hamming_window = hamming(size(Frames_matrix,2));
hammming_window_matrix = zeros(number_of_frames,FrameLen);
for i= 1:number_of_frames
    hammming_window_matrix(i,:) = hamming_window;
end


Frames_matrix = Frames_matrix .*hammming_window_matrix;
MAG  = abs(FFT_matrix (Frames_matrix));

nfft= size(MAG,2);
FFT_MA = MAG(:,1:(nfft/2+1));
mel_MA = mel_log(FFT_MA,bank_number,fs,f_low,f_high,nfft);
DCT_onlecture = zeros(size(mel_MA));

for k=1:size(mel_MA,1)
    DCT_onlecture(k,:) = DCT_II(mel_MA(k,:));
end
%%%% creating delta, concatenate the delta with oridingal mfcc
if delta == true
   delta_output = Deltas(DCT_onlecture(:,1:13));
   output = [DCT_onlecture(:,1:13),delta_output(:,1:5)]; 
else 
%%%just a really neat implementation of DCT
% CC = mel_MA';
% dctm = @( N, K )( sqrt(2/N) * cos( repmat([0:N-1].',1,K).* repmat(pi*([0:K-1]+0.5)/K,N,1) ) );
% DCT = dctm(17,bank_number);
% CC =  (DCT * CC)';
%%%%%%%%%%%%%%

%output = mel_MA;    %%%without DCT

%output = CC;    %%%withDCT

output = DCT_onlecture(:,1:13);    %%%according to DCT on lecture notes (with DCT)


%%question 4 check out get rid of some coefficients, the perform the
%%inverse DCT, remeber to set break point
% mel_MA_from_inverse_DCT = zeros(size(mel_MA));
% DCT_onlecture(:,3:end) = 0;
% for k=1:size(mel_MA,1)
%     mel_MA_from_inverse_DCT(k,:) = IDCT_II(DCT_onlecture(k,:));
% end
% figure;
% subplot(2,1,1);
% plot(mel_MA(:,1));
% subplot(2,1,2);
% plot(mel_MA_from_inverse_DCT(:,1));
end
end
