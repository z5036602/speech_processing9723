% ldTIDIGITSasr
% 15/01/08

% Load TIDIGITS speech data for speech recognition
clear;clc
frame = 160; % 20ms after downsampling
order = 30;
[b1,a1] = cheby1(order,0.1,0.47);
basedir = '/Users/joshualiu/Desktop/speech_processing9723/lab6/Labs/';

assignpath(basedir)  % You only need to run this line once for every time you open MATLAB

database = 'TIDIGITS';
uttlimit = 100;
spkrlimit = 28;
framelimit = 1e9;

% for saving features
%fidn = fopen(['C:\work\2005 S2\wbe\' tt 'data'],'wb');
files = 1;
frames = 1;
word = 1;
spkridx = ones(1,spkrlimit);
D1 = dir([basedir database]);
[D2{1:size(D1,1)}] = deal(D1.name);
disp('Loading...');
for spkrDirNum = 4:13 %size(D3,1), % just first 10 speakers
    disp(['   ' D2{spkrDirNum}])
    D3 = dir([basedir database '/' D2{spkrDirNum}]);
    [D4{1:size(D3,1)}] = deal(D3.name);
    utt = 0;
    for fileNum = 3:size(D3,1)
        %disp(['      ' D6{fileNum}])
        if ~isempty(strfind(D4{fileNum},'.raw'))
            utt = utt + 1;
            fidt = fopen([basedir database '/' D2{spkrDirNum} '/' D4{fileNum}],'rb');
            y = fread(fidt,320000,'short');
            fclose(fidt);
            %soundsc(y,16000)
            y = y(513:end); % remove header (since wavread doesn't work)
           
            yn1 = filter(b1,a1,y);  %%%why????
            yn2 = yn1(1:2:end); %%% why ???
            noise_power = mean(yn2(1:10).^2);
            signal = 
            variance = noise_generator(yn2,10);
            noise = variance*randn(1,length(yn2))';
            yn2=yn2+noise;
             %yn2 = yn2-mean(yn2);
            %soundsc(yn2,8000);
             figure;
              subplot 211
             plot(yn2);          
            [yn2,my_length] = Lab6_VAD(yn2');
            %assert(my_length>13);
%              subplot 212
%              plot(yn2);

            
            [mfc] = Josh_MFCC_pitch (yn2,8000,160,80,300,3700,17,false);
             assert(size(mfc,1)>13);
%             x = [0 size(mfc,1)];
%             y = [0 4000];
%             clims = [-3 40];
%             imagesc(x,y,mfc,clims);
%             %h1 = axes ;
%             set(gca,'YDir','normal')
%             colorbar;
%             figure;
%             subplot(2,1,1);
%             plot(yn2);
%             subplot(2,1,2);
%             plot(mfc(:,1));
            %ras = rastaplp(yn2, 8000, 1, 12)';
            asrvectors{word}{utt} = mfc;
            data{word}{utt} = yn2;
            
            % Cepstral mean normalisation
            [r,c] = size(mfc);
%             asrvectors{word}{utt} = asrvectors{word}{utt} - ones(c,1)*mean(asrvectors{word}{utt});
            
            % Mean and variance normalisation
%             asrvectors{word}{utt} = (asrvectors{word}{utt} - ...
%             ones(c,1)*mean(asrvectors{word}{utt}))./(ones(c,1)*std(asrvectors{word}{utt}));
            
            % Cumulative distribution mapping
%             clear wmfc;
%             for dim = 1:r,
%                [sc,idx] = sort(mfc(dim,:));
%                wmfc(dim,idx) = norminv((0.5:c-0.5)/c,0,1);
%             end
%             asrvectors{word}{utt} = wmfc';
            
        end
        files = files + 1;
    end
    word = word + 1;
end
%total_files = files
% fclose(fidn); % for saving
