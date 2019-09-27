clear;clc
[audio,fs]= audioread('sample1.wav'); % fs -->16k
audio = audio-mean(audio);
%soundsc(audio,fs);
figure;
plot(audio-mean(audio));
title('audio time domain signal');


window_length = 256;
incre_dura = 16/1000;    %8 sec --> 128, 
figure;
assert(window_length>=incre_dura*16000, 'window length have to be greater than increment size');
pitch_contour_overtime(audio,fs,window_length,incre_dura)