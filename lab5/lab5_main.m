clear;clc
fc = [50 150 250 350 450 570 700 840 1000 1170 1370 1600 1850 2150 2500 2900 3400];
fs = 8000;
n = [1:160];
p = gamma_tone(fc,fs,n);

% figure;
% for k = 1:length(fc)
%      plot(20*log(abs(fft(p(k,:)))));
%      hold on 
% end  
% title('p')
 
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


  

%%
[audio,fs]= audioread('speech.wav'); % fs -->16k
% plot the speech in time domain
figure(1);
total_length = length(audio);
sound(audio,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(audio);
title('Time domian speech signal');
%%
[total_speech,~] = denoise_banks(q,audio,160,160,'d',false,false);
figure;
plot(total_speech);
soundsc(total_speech,fs)
%%
[total_speech,~] = denoise_banks(q,audio,160,160,'d',true,false);

figure;
plot(total_speech)
info = audiodevinfo;
player = audioplayer(total_speech, fs);
play(player);




%% Denoise

[audio,fs]= audioread('noise10dB.wav'); % fs -->16k
% plot the speech in time domain
figure(1);
total_length = length(audio);
sound(audio,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(audio);
title('Time domian speech signal');
%%
[total_speech,~] = denoise_banks(q,audio,160,160,'d',true,true,5);

figure;
plot(total_speech)
info = audiodevinfo;
player = audioplayer(total_speech, fs);
play(player);

%%

[audio,fs]= audioread('noise0dB.wav'); % fs -->16k
% plot the speech in time domain
figure(1);
total_length = length(audio);
sound(audio,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(audio);
title('Time domian speech signal');
%%
[total_speech,~] = denoise_banks(q,audio,160,160,'d',true,true,5);

figure;
plot(total_speech)
info = audiodevinfo;
player = audioplayer(total_speech, fs);
play(player);