% ldTIDIGITSasr
% 15/01/08
p = genpath('/Users/joshualiu/Desktop/speech_processing9723/lab6/');
addpath(p);
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
            
% Remove low-energy portions
%             ind = find(yn2>10);
%             yn2 = yn2(ind(1):ind(end));


            % creating noise
            ns = sqrt(mean(yn2.^2)/10)*randn(size(yn2));
            colored_noise = filter (b1,a1,ns);
            colored_noise = colored_noise/(10/13.5);
            % add 10 db noise
            snr_ratio_pure = snr(yn2,ns);
            snr_ratio_colored = snr(yn2,colored_noise);
            
            %yn2 = yn2+colored_noise;
            
            %yn2 = yn2+ns;
            %yn2 = yn2 + sqrt(mean(yn2.^2)/10)*randn(size(yn2));
            %yn2 = yn2 + sqrt(mean(yn2.^2))*randn(size(yn2));
           % [yn2,my_length] = VAD(yn2');
          
%%%%%for checking the correctness of VAD          
            %soundsc(yn2,8000);
%             figure;
%             subplot 211
%             plot(yn2);     
 %           [yn2,my_length] = VAD(yn2');
%             subplot 212
%             plot(yn2);
%%%%%%%%%%%%
            
            [mfc] = Josh_MFCC_pitch (yn2,8000,160,80,300,3700,17,true);
             assert(size(mfc,1)>13);
%%%%%%%%    imagesc the mfcc
%             x = [0 size(mfc,1)];
%             y = [0 4000];
%             clims = [-3 40];
%             imagesc(x,y,mfc,clims);
%             %h1 = axes ;
%             set(gca,'YDir','normal')
%             colorbar;
%%%%mfcc first coefficient plot for checking correctness of MFCC, the first
%%%%coefficient should be closed the energy of the signal
%             figure;
%             subplot(2,1,1);
%             plot(yn2);
%             subplot(2,1,2);
%             plot(mfc(:,1));
%%%%%%
            %ras = rastaplp(yn2, 8000, 1, 12)';
            asrvectors{word}{utt} = mfc;
            data{word}{utt} = yn2;
            
           %%%%%Cepstral mean normalisation
            [r,c] = size(mfc');
          %  asrvectors{word}{utt} = asrvectors{word}{utt} - ones(c,1)*mean(asrvectors{word}{utt});
            
           %%%%%Mean and variance normalisation
            % asrvectors{word}{utt} = (asrvectors{word}{utt} - ...
            % ones(c,1)*mean(asrvectors{word}{utt}))./(ones(c,1)*std(asrvectors{word}{utt}));
            
           %%%%%Cumulative distribution mapping have problems
 %            [r,c] = size(mfc);
%              clear wmfc;
%              for dim = 1:r,
%                 [sc,idx] = sort(mfc(dim,:));
%                 wmfc(dim,idx) = norminv((0.5:c-0.5)/c,0,1);
%              end
%              asrvectors{word}{utt} = wmfc;
            
        end
        files = files + 1;
    end
    word = word + 1;
end
%total_files = files
% fclose(fidn); % for saving
