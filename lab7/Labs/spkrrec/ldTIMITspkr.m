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
                  
                    if frames>=framelimit,
                        disp(['Reached ' num2str(framelimit) ' frames'])
                        pause;
                    end
                    frames = frames + 1;
                    
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
%% Q1
%Mixtures test, log-liklihood with different number of GMM mixtures
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
plot(mixutures,llh_record);

%% Q2
%Train a model using 5 utterances from one speaker, 32 mixtures 
%it tests with different number of iteration
five_utterances = [];
for speaker = 4:4
    for utterance = 1:5
        five_utterances = [five_utterances;spkrvectors{speaker}{utterance}]
    end 
end   

llh_record = []

for iteration = 1:10
         spkr10mod = emgmm(five_utterances,32,iteration) ;
         [~,llh] = latent_pospdf(five_utterances,spkr10mod);
         llh_record = [llh_record;llh];         
end 
 
plot (llh_record);
    
%% Q3
% Train a model using 5 utterances from one speaker, 8 mixtures and 
% iterations of the EM algorithm, then we test with 16,32,64,128
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

%% Q4
%train a model using same utt, and test with different utt and same utt
spkr10mod = emgmm(spkrvectors{10}{1},32,10) ;  
[~,llh_same] = latent_pospdf(spkrvectors{10}{1},spkr10mod);
[~,llh_diff] = latent_pospdf(spkrvectors{10}{2},spkr10mod);
disp('llh_same vs. llh_diff' )
disp( llh_same);
disp( llh_diff);
%% Q5 five utterance is from speaker 10, liklihood of all utterances, you will found out
% that the liklihood of data that trained on are higher than others 
five_utterances = [];
for speaker = 1:1
    for utterance = 1:5
        five_utterances = [five_utterances;spkrvectors{speaker}{utterance}]
    end 
end   
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

%% Q6Train a model using the first utterance from one speaker, 64 mixtures and 10
%utterance for that same speaker. Repeat, training on the first 2 utterances, the
%first 3 utterances , . . . , the first 9 utterances. Plot the log-likelihood against the
%number of utterances used to train the model
% it is reducing number of utterances to see the likelihood changes
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

plot(llh_record);
%%
%create 10 speaker GMM from 7 utterances from each it creates 10 GMM
speaker_models.models = cell(10,1);
for speakers = 1:10
    speaker_utterances = [];
    for utterance = 1:7
        speaker_utterances = [speaker_utterances;spkrvectors{speakers}{utterance}];
        
    end 
    speaker_models.models{speakers} = emgmm(speaker_utterances,32,10);
end 
%%
llh_record = [];
ground_truth = [];
for speakers = 1:10
    for utterance = 8:10
        for model_counter = 1:10
            [~,llh] = latent_pospdf(spkrvectors{speakers}{utterance},speaker_models.models{model_counter});
            disp(llh);
            llh_record = [llh_record;llh];
            if model_counter == speakers
                ground_truth = [ground_truth,true];
                
            else 
                ground_truth = [ground_truth,false];
            end 
        end 
        
    end 
   
end 
%%
threshold_trail = sort(llh_record);
predication = zeros(size(ground_truth));
error_rate = zeros(size(ground_truth));
false_acceptance_rate=zeros(size(ground_truth));
false_rejection_rate=zeros(size(ground_truth));

for q = 1:length(llh_record)
    predication = zeros(size(ground_truth));
    accept_index = find(llh_record>=threshold_trail(q));
    reject_index = find(llh_record<threshold_trail(q));
    predication(accept_index) = true;
    
    false_acceptance_rate(q) = sum(abs(predication(accept_index)-ground_truth(accept_index)))/length(accept_index);
    if length(reject_index) ~= 0
        false_rejection_rate(q) = sum(abs(predication(reject_index)-ground_truth(reject_index)))/length(reject_index);
    else 
        false_rejection_rate(q) = 0.001;
    end 
    disp(false_rejection_rate(q));
    if  false_rejection_rate(q) <= false_acceptance_rate(q)+1/300 || false_rejection_rate(q) >= false_acceptance_rate(q)-1/300
        equal_error_threshold = threshold_trail(q);
    
    end 
    number_of_misclassification = sum(abs(predication - ground_truth));
    error_rate(q) = (number_of_misclassification/length(llh_record))*100;
end 

threshold_from_acc = threshold_trail(error_rate == min(error_rate));
%%
figure;
plot (error_rate);
title('error rate');
figure;
plot(false_acceptance_rate,false_rejection_rate)
title('DET');
xlabel('false accpet')
xlim([0 1])
ylabel('false reject')
