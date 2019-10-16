%%% This script plots the formant contour and LPC spectrogram
clear;clc
[audio,fs]= audioread('sample3.wav'); % fs -->16k
audio = audio-mean(audio);
soundsc(audio,fs); %fs = 22k
duration = length(audio)/fs;
figure;
plot(audio);
title('audio time domain signal');
%%
window_length = 512;
incre_dura = 256;    
assert(window_length>=incre_dura, 'window length have to be greater than increment size');
formants_matrix = three_formants_matrix(audio,fs,window_length,incre_dura,'hamming');
t = linspace(0,duration,size(formants_matrix,1));
figure;
LPC_spectrogram(audio,fs,window_length,incre_dura,'hamming')
hold on
plot (t,formants_matrix(:,1),'r');
% % 
 hold on 
 plot (t,formants_matrix(:,2),'r');
 
 
 hold on
 plot (t,formants_matrix(:,3),'r');


