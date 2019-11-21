% ldTIDIGITSasr
% 15/01/08

% Load TIDIGITS speech data for speech recognition
clear;clc
frame = 160; % 20ms after downsampling
order = 30;
[b1,a1] = cheby1(order,0.1,0.47);
basedir = '/Users/joshualiu/Desktop/speech_processing9723/Lab8/Labs/';

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
             ind = find(yn2>10);
             yn2 = yn2(ind(1):ind(end));
           
            [mfc] = Josh_MFCC_pitch (yn2,8000,160,80,300,3700,17,false);
             assert(size(mfc,1)>13);

            asrvectors{word}{utt} = mfc;
            data{word}{utt} = yn2;
            
            % Cepstral mean normalisation
            [r,c] = size(mfc');
         
            

        end
        files = files + 1;
    end
    word = word + 1;
end
%total_files = files
% fclose(fidn); % for saving


%%
%Lab8_Q_1
%liklihood vs states. so accuracy will saturate as states increased
likelihood_list = zeros(1,9);
counter = 1;
for states = 1:10
    m1 = trainHMM(asrvectors,4,1:10,states,3);
    likli_sum = 0;
    for utt = 1:80
        likli_sum = likli_sum+calcHMMLL(asrvectors{4}{utt},m1);
    end
    likelihood_list(counter) = likli_sum;
    counter = counter + 1;
end

figure;
x = 1:20;
plot(x,likelihood_list);
title('log lilihood of the speech vs. number of states')
%%
%Lab8_Q_2
%liklihood vs states. so accuracy will barely changes mixtures in creased
likelihood_list = zeros(1,9);
counter = 1;
for Mixtures = 1:10
    m1 = trainHMM(asrvectors,7,1:10,5,Mixtures);
    likli_sum = 0;
    for utt = 1:80
        likli_sum = calcHMMLL(asrvectors{7}{utt},m1)+likli_sum;
    end
    likelihood_list(counter) = likli_sum;
    counter = counter + 1;
end

figure;
x = 1:10;
plot(x,likelihood_list);
title('log lilihood of the speech vs. number of Mixtures')
%% another likelihood of training vs testing.
%Lab8_Q_3
likelihood_list_for_training_data = zeros(1,10);
m1 = trainHMM(asrvectors,7,1:10,5,3); 
for utt = 1:10
    likelihood_list_for_training_data(utt)=calcHMMLL(asrvectors{7}{utt},m1);
end
likelihood_list_for_training_data = sum(likelihood_list_for_training_data);

likelihood_list_for_test_data = [];
%length(asrvectors{3})
for utt = 11:20
    likelihood_list_for_test_data=[likelihood_list_for_test_data,calcHMMLL(asrvectors{7}{utt},m1)];
end

likelihood_list_for_test_data = sum(likelihood_list_for_test_data);
disp('training vs. test')
disp(likelihood_list_for_training_data)
disp(likelihood_list_for_test_data)

%%
%Lab8_Q_4
%give utterance, number predication
likelihood_list = choice_of_number (asrvectors,asrvectors{4}{20});
position = find(likelihood_list == max(likelihood_list));
disp(position-1)
