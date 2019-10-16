%%% This script shows us effect of different window size,window shape,
%%% increment on the spectrogram of audio.
%% loading audio sample, plot it on time domain
clear;clc
[audio,fs]= audioread('sample1.wav');
soundsc(audio,fs);
figure;
plot(audio);
title('audio time domain signal');
%% different overlap testing at small window size

%large overlap small window
STFT_window_length = 128;
incre_dura = 64;
figure;
subplot 311
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('large overlap small window')

% small overlap small window
STFT_window_length = 128;
incre_dura = 96;
subplot 312
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('small overlap small window')

% no overlap small window
STFT_window_length = 128;
incre_dura = 128;
subplot 313
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('no overlap small window')

%% Different window size testing no over lap

% no overlap small window
figure;
STFT_window_length = 128;
incre_dura = 128;     %8 msec == 128 samples
subplot 311
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('no overlap small window')

%no overlap media window
STFT_window_length = 256;  
incre_dura = 256;       %16 msec == 256 samples
subplot 312
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('no overlap media window')

%no overlap large window
STFT_window_length = 512;
incre_dura = 512;       %32 msec == 512 samples
subplot 313
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('np overlap large window')

%% different overlap testing at medium window size

%small overlap media window
figure;
STFT_window_length = 512;
incre_dura = 416;
subplot 311
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('small overlap media window')

%meidum overlap media window
STFT_window_length = 512;
incre_dura = 256;
subplot 312
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('meidum overlap media window')

%large overlap media window
STFT_window_length = 512;
incre_dura = 128;
subplot 313
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('large overlap media window')
%% different window shape testing

%hamming
figure;
STFT_window_length = 512;
incre_dura = 256;
subplot 411
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'hamming');
title('hamming')

%hanning
STFT_window_length = 512;
incre_dura = 256;
subplot 412
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'hanning');
title('hanning')

%blackman
subplot 413
STFT_window_length = 512;
incre_dura = 256;
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'blackman');
title('balckman')

%rect
subplot 414
STFT_window_length = 512;
incre_dura = 256;
assert(STFT_window_length>=incre_dura, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura,'d');
title('rect')