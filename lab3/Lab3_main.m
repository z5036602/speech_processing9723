clear;clc
[audio,fs]= audioread('sample1.wav'); % fs -->16k
audio = audio-mean(audio);
soundsc(audio,fs);
figure;
plot(audio-mean(audio));
title('audio time domain signal');


window_length = 400;
incre_dura = 16/1000;    %8 msec --> 128, 
assert(window_length>=incre_dura*16000, 'window length have to be greater than increment size');
my_fo = pitch_contour_overtime(audio,fs,window_length,incre_dura,50,320);
t = linspace(0,length(audio)/fs,length(my_fo));

figure;
subplot 211
plot(t,my_fo)
xlim([0 length(audio)/fs]);
subplot 212
spectrogram(audio,fs,window_length,incre_dura);
%%
clear;clc
[audio,fs]= audioread('sp07.wav'); % fs -->16k
audio = audio-mean(audio);
soundsc(audio,fs);
figure;
plot(audio-mean(audio));
title('audio time domain signal');


window_length = 400;
incre_dura = 16/1000;    %8 msec --> 128, 
assert(window_length>=incre_dura*16000, 'window length have to be greater than increment size');
my_fo = pitch_contour_overtime(audio,fs,window_length,incre_dura,50,320);
t = linspace(0,length(audio)/fs,length(my_fo));

figure;
subplot 211
plot(t,my_fo)
xlim([0 length(audio)/fs]);
subplot 212
spectrogram(audio,fs,window_length,incre_dura);
% f_0 = pitch(audio,fs, ...
%      'WindowLength',400, ...
%      'OverlapLength',(400-256), ...
%       'Range',[50 320], ...
%       'Method','NCF');