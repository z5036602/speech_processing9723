%%% The script performs pitch tracking
% load the sample speech and plot the speech 
clear;clc
[audio,fs]= audioread('sample1.wav'); % fs -->16k
audio = audio-mean(audio);
soundsc(audio,fs);
figure;
plot(audio-mean(audio));
title('audio time domain signal');
%pitch contour and spectrogram of first speech sample 
window_length = 400;
incre_dura = 400-144;    %8 msec --> 128, 
assert(window_length>=incre_dura, 'window length have to be greater than increment size');
my_fo = pitch_contour_overtime(audio,fs,window_length,incre_dura,50,320,'hamming');
[f_matlab_standard,idx] = pitch(audio,fs, ...
            'Method','NCF', ...
            'WindowLength',400, ...
            'OverlapLength',144, ...
            'Range',[50,320]);
        
figure;
t = linspace(0,length(audio)/fs,length(my_fo));
spectrogram(audio,fs,window_length,incre_dura,'hamming');
hold on
xlim([0 length(audio)/fs]);
plot(t,my_fo,'r-')
%%
%pitch contour and spectrogram of second speech sample 
clear;clc
[audio,fs]= audioread('sp07.wav'); % fs -->16k
audio = audio-mean(audio);
soundsc(audio,fs);
figure;
plot(audio-mean(audio));
title('audio time domain signal');


window_length = 400;
incre_dura = 400-144;    %8 msec --> 128, 
assert(window_length>=incre_dura, 'window length have to be greater than increment size');
my_fo = pitch_contour_overtime(audio,fs,window_length,incre_dura,50,320,'blackman');

t = linspace(0,length(audio)/fs,length(my_fo));
figure;
spectrogram(audio,fs,window_length,incre_dura,'hamming');
xlim([0 length(audio)/fs]);
hold on 
plot(t,my_fo,'r-')