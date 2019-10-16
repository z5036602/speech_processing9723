%%% This script let us inspect the frequency response of voiced speech frame
%%% & unvoice speech frame
%% load the speech data into matlab
clear; clc
load('speech.mat');
fs = 8000;

%% plot the speech in time domain
figure(1);
total_length = length(speech);
sound(speech,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(speech);
title('Time domian speech signal');
%% plot time doamin and freq/phase response of unvoiced frame
m = enframe(speech,256,256);
unvoiced_frame = m(15,:);
figure;
plot(unvoiced_frame);
title('unvoiced frame time domain signal')
joshuaplot(unvoiced_frame,fs,'unvoiced');
%% plot time doamin and freq/phase response of voice frame
voiced_frame = m(9,:);
figure;
plot(voiced_frame);
title('voiced frame time domain signal')
joshuaplot(voiced_frame,fs,'voiced');
%% recorded my voice
%recObj = audiorecorder;
%disp('Start speaking.')
%recordblocking(recObj, 5);
%disp('End of Recording.');
%% loading my voice
%play(recObj);
[y fs]= audioread('my_recording.wav');
k = enframe(y,256,256);
figure;
plot(y);
%% plot time doamin and freq/phase response of voiced frame (my_voice)
 voiced = k(66,:);
 unvoiced = k (118,:); 
 figure;
 plot(voiced);
 title('voiced frame time domain signal')
 joshuaplot(voiced,fs,'voiced');
%% plot time doamin and freq/phase response of unvoiced frame (my_voice)
 figure;
 plot(unvoiced);
 title('unvoiced frame time domain signal')
joshuaplot(unvoiced,fs,'unvoiced');
%%
soundsc(y);





