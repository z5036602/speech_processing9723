% ldTIMITspkr
% 21/09/07

% Load TIMIT speech data for speaker recognition

frame = 160; % 20ms after downsampling
order = 30;
[b1,a1] = cheby1(order,0.1,0.47);
basedir = '/Users/joshualiu/Desktop/speech_processing9723/lab7/Labs/';
assignpath(basedir)
database = 'TIMIT';
tt = '';
uttlimit = 100;
spkrlimit = 28;
framelimit = 1e9;

% for saving features
%fidn = fopen(['C:\work\2005 S2\wbe\' tt 'data'],'wb');
files = 1;
frames = 1;
spkrs = 1;
spkridx = ones(1,spkrlimit);
D1 = dir([basedir database '/' tt]);
[D2{1:size(D1,1)}] = deal(D1.name);
disp('Loading...');
for mainDirNum = 3:3, %size(D1,1), % DR1 only
    disp(D2{mainDirNum})
    D3 = dir([basedir database '/' tt '/' D2{mainDirNum}]);
    [D4{1:size(D3,1)}] = deal(D3.name);
    for spkrDirNum = 3:12, %size(D3,1), % just first 10 speakers
        disp(['   ' D4{spkrDirNum}])
        D5 = dir([basedir database '/' tt '/' D2{mainDirNum} '/' D4{spkrDirNum}]);
        [D6{1:size(D5,1)}] = deal(D5.name);
        utt = 0;
        for fileNum = 3:size(D5,1),
            %disp(['      ' D6{fileNum}])
            if ~isempty(findstr(D6{fileNum},'.WAV'))
                utt = utt + 1;
                % Extract phone labels for this file
                [label,start,finish] = ldTIMITlab([basedir database '/' tt '/' D2{mainDirNum} '/' D4{spkrDirNum} '/' D6{fileNum}(1:end-3) 'PHN'],'n');
                fidt = fopen([basedir database '/' tt '/' D2{mainDirNum} '/' D4{spkrDirNum} '/' D6{fileNum}],'rb');
                y = fread(fidt,320000,'short');
                fclose(fidt);
                y = y(513:end); % remove header (since wavread doesn't work)
                yn1 = filter(b1,a1,y);
                yn2 = yn1(1:2:end);
                yn2 = yn2(end-finish(end)+1:end);
                
                % MFCC / RASTA
                mfc = melfcc(yn2, 8000, 'lifterexp', -22, 'nbands', 17, ...
                'dcttype', 3, 'maxfreq',4000, 'fbtype', 'htkmel', 'sumpower', 0);
                %ras = rastaplp(yn2, 8000, 1, 12)';
                spkrvectors{spkrs}{utt} = mfc';

                % Other feature vectors
                for n = start(2):frame:finish(end-1)-frame, % leave off initial and trailing silence
                    %xn = yn2(n:n+frame-1);

                    % Feature extraction
                    %a = lpc(xn,10); % LP as placeholder
                    %lsf = poly2lsf(a); % LSF as placeholder

                    % Append feature vector to phone matrix
                    %spkrvectors{spkrs}(spkridx(spkrs),:) = lsf; %a(2:11);
                    %spkridx(spkrs) = spkridx(spkrs) + 1;

                    % fwrite(fidh,H,'float'); % saving output
                    if frames>=framelimit,
                        disp(['Reached ' num2str(framelimit) ' frames'])
                        pause;
                    end
                    frames = frames + 1;
                    % for sanity checking
                    %subplot(3,1,1), plot(xn);
                    %subplot(3,1,2), plot(20*log10(1./abs(polyval(a,exp(j*(0:100)/100*pi)))));
                    %subplot(3,1,3), plot([Hn H]);
                    %pause;
                end
            end
            files = files + 1;
        end
        if spkrs>=spkrlimit,
            disp(['Reached ' num2str(spkrlimit) ' speakers'])
            break;
        end
        spkrs = spkrs + 1;
    end
    if spkrs>=spkrlimit,
        break; % messy, but need to break out of two for loops
    end
end
disp('Ended');
%%
%spkr10mod = emgmm(spkrvectors{1}{2},32,10) ;  % this speaker has a bug
%[~,llh] = latent_pospdf(spkrvectors{10}{10},spkr10mod);
%%
load('mystery.mat');
llh_record = [];
counter = 1;
mixutures = [];
for m = 1:7
    k = 2.^m;
    mixutures(counter) = k;
    spkr10mod = emgmm(mystery,k,10);
    [~,llh] = latent_pospdf(mystery,spkr10mod);
    llh_record(counter) =llh;
    counter = counter + 1;
end 
%%
plot(mixutures,llh_record);

%%
five_utterances = [];
for speaker = 10:10
    for utterance = 1:5
        five_utterances = [five_utterances;spkrvectors{speaker}{utterance}]
    end 
end   


%%
llh_record = []

for iteration = 1:10
         spkr10mod = emgmm(five_utterances,32,iteration) ;
         [~,llh] = latent_pospdf(five_utterances,spkr10mod);
         llh_record = [llh_record;llh];
        
         
         
end 
 
plot (llh_record);
    
%% Q3
%spkr10mod = emgmm(five_utterances,8,iteration) ;
llh_record = [];  %%mixture increase, one guassian will overfit a point and have low likelihood
mixutures_number = [];
counter = 1;
for m = 1:7
    k = 2.^m;
    mixutures_number(counter) = k;
    spkr10mod = emgmm(five_utterances,k,10) ;
    [~,llh] = latent_pospdf(five_utterances,spkr10mod);
    llh_record(counter) = llh;
    counter = counter + 1;
end 
plot(mixutures_number,llh_record);

%%
spkr10mod = emgmm(spkrvectors{10}{1},32,10) ;  
[~,llh_same] = latent_pospdf(spkrvectors{10}{1},spkr10mod);
[~,llh_diff] = latent_pospdf(spkrvectors{10}{2},spkr10mod);
%%
%disp('same utt:' + llh_same);
spkr10mod = emgmm(five_utterances,128,10);
llh_record = zeros(100,1);
counter = 1;
for speaker = 1:10
    
    for utterance = 1:10 
        [~,llh] = latent_pospdf(spkrvectors{speaker}{utterance},spkr10mod);
        llh_record(counter) = llh;
        counter = counter + 1;
    end 
end 
plot (llh_record);

%%
%spkr10mod = emgmm(spkrvectors{10}{1},16,10) ;  
utterances = [];
llh_record = [];
speaker = 1;
for utter_ending_point = 1:9
    for utterance = 1:utter_ending_point
        utterances = [utterances;spkrvectors{speaker}{utterance}];
    end 
    spkr10mod = emgmm(utterances,32,10) ;  % this speaker has a bug
    [~,llh] = latent_pospdf(spkrvectors{10}{1},spkr10mod);
    llh_record = [llh_record;llh];

end 
%%
plot(llh_record);
%%
