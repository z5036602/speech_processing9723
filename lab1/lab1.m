clear; clc
load('speech.mat');
fs = 8000;
%%
figure(1);
total_length = length(speech);
%sound(speech,fs);
fprintf('Total number of samples are: %i\n',total_length);
plot(speech);
title('Time domian speech signal');
%%
m = enframe(speech,256,256);
unvoiced_frame = m(15,:);
joshuaplot(unvoiced_frame,fs,'unvoiced');
%%
voiced_frame = m(6,:);
plot(voiced_frame);
joshuaplot(voiced_frame,fs,'voiced');
%%
recObj = audiorecorder;
disp('Start speaking.')
recordblocking(recObj, 5);
disp('End of Recording.');
%%
%play(recObj);
y = getaudiodata(recObj);
k = enframe(y,256,256);
plot(y);
%%
 voiced = k(66,:);
 unvoiced = k (145,:); 
joshuaplot(unvoiced,fs,'unvoiced');
joshuaplot(voiced,fs,'voiced');
%%
soundsc(y);





