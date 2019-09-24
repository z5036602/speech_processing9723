clear;clc
[audio,fs]= audioread('sample1.wav');
soundsc(audio,fs);
figure;
plot(audio);
title('audio time domain signal');
STFT_window_length = 300;
incre_dura = 10/1000;
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);