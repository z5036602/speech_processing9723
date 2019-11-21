%%this script requires speech processing toolbox self made in previous lab
% configure the path to the correct file location in your own computer
addpath('/Users/joshualiu/Desktop/speech_processing9723/speech_processing_packages')
clear;clc
% create a gamma_tome _filter bank p
fc = [50 150 250 350 450 570 700 840 1000 1170 1370 1600 1850 2150 2500 2900 3400];
fs = 8000;
n = [1:160];
p = gamma_tone(fc,fs,n);
%%%%%%
% plot magnitude reponse of the gamma_tone_filter bank
% figure;
% for k = 1:length(fc)
%      plot(20*log(abs(fft(p(k,:)))));
%      hold on 
% end  
% title('p')
% xlim([0,80])
 %%%%%%%%%
%%%
% plot the magnitude response of the sythesis_filter
% it should give us linear phase response and 0dB gain at center frequency
% of each filter
g = sythesis_filter (p);
figure;
q = [];
for i = 1 : size(p,1)
    q (i,:) = conv(p(i,:),g(i,:));
    normalization_factor = max(abs(fft(q (i,:))));
    q (i,:) = q (i,:)./normalization_factor;
    freqz(q (i,:));
    hold on 
end 
title('q = g * p ')

%% read in the speech data
[audio,fs]= audioread('speech.wav'); % fs -->16k
% plot the speech in time domain
figure(1);
total_length = length(audio);
sound(audio,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(audio);
title('Time domian speech signal');
%% Filter the speech signal (speech.wav) using the filter bank. This is done on a
%frame-by-frame basis, with 20ms frames. The initial condition was not set
%at this situation. Hence, the speech distorted
[total_speech,~] = denoise_banks(q,audio,160,160,'d',false,false); 
figure;
plot(total_speech);
soundsc(total_speech,fs)
%% The initial condition setted for each frame. The speech is not distorted
[total_speech,~] = denoise_banks(q,audio,160,160,'d',true,false);

figure;
plot(total_speech)
info = audiodevinfo;
player = audioplayer(total_speech, fs);
play(player);




%% reading in 10 dB noisy speech
[audio,fs]= audioread('noise10dB.wav'); % fs -->16k
% plot the speech in time domain
figure(1);
total_length = length(audio);
sound(audio,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(audio);
title('Time domian speech signal');
%% denoise 10 dB noisy speech
[total_speech,~] = denoise_banks(q,audio,160,160,'d',true,true,7);

figure;
plot(total_speech)
info = audiodevinfo;
player = audioplayer(total_speech, fs);
play(player);

%% read in 0 dB noisy speech
[audio,fs]= audioread('noise0dB.wav'); % fs -->16k
% plot the speech in time domain
figure(1);
total_length = length(audio);
sound(audio,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(audio);
title('Time domian speech signal');
%% denoise 0dB noise
[total_speech,~] = denoise_banks(q,audio,160,160,'d',true,true,5);

figure;
plot(total_speech)
info = audiodevinfo;
player = audioplayer(total_speech, fs);
play(player);