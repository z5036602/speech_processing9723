clear; clc
load('speech.mat');
fs = 8000;
%%
figure(1);
total_length = length(speech);
sound(speech,fs);
fprintf('Total number of samples in speech are: %i\n',total_length);
plot(speech);
title('Time domian speech signal');
%%
m = enframe(speech,256,256);
unvoiced_frame = m(15,:);
figure;
plot(unvoiced_frame);
title('unvoiced frame time domain signal')
joshuaplot(unvoiced_frame,fs,'unvoiced');
%%
voiced_frame = m(9,:);
figure;
plot(voiced_frame);
title('voiced frame time domain signal')
joshuaplot(voiced_frame,fs,'voiced');
%%
%recObj = audiorecorder;
%disp('Start speaking.')
%recordblocking(recObj, 5);
%disp('End of Recording.');
%%
%play(recObj);
[y fs]= audioread('my_recording.wav');
k = enframe(y,256,256);
plot(y);
%%
 voiced = k(66,:);
 unvoiced = k (118,:); 
 figure;
 plot(voiced);
 title('voiced frame time domain signal')
 figure;
 plot(unvoiced);
 title('unvoiced frame time domain signal')
joshuaplot(unvoiced,fs,'unvoiced');
joshuaplot(voiced,fs,'voiced');
%%
soundsc(y);





