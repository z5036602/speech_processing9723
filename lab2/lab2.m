clear;clc
[audio,fs]= audioread('sample1.wav');
soundsc(audio,fs);
figure;
plot(audio);
title('audio time domain signal');
STFT_window_length = 128;
incre_dura = 4/1000;
figure;
subplot 311
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('large overlap small window')
STFT_window_length = 128;
incre_dura = 6/1000;
subplot 312

assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('small overlap small window')
subplot 313
STFT_window_length = 128;
incre_dura = 8/1000;
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('no overlap small window')


%%
figure;
STFT_window_length = 128;
incre_dura = 8/1000;
subplot 311
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('no overlap small window')
STFT_window_length = 256;
incre_dura = 16/1000;
subplot 312

assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('no overlap media window')
subplot 313
STFT_window_length = 512;
incre_dura = 32/1000;
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('np overlap large window')
%%
figure;
STFT_window_length = 512;
incre_dura = 26/1000;
subplot 311
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('small overlap large window')
STFT_window_length = 512;
incre_dura = 16/1000;
subplot 312

assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('meidum overlap media window')
subplot 313
STFT_window_length = 512;
incre_dura = 8/1000;
assert(STFT_window_length>=incre_dura*16000, 'window length have to be greater than increment size');
spectrogram(audio,fs,STFT_window_length,incre_dura);
title('large overlap large window')