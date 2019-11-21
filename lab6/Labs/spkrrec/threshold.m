%create 10 speaker GMM from 7 utterances from each
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
title('error_rate');
figure;
plot(false_acceptance_rate,false_rejection_rate)
title('DET');
xlabel('false accpet')
xlim([0 1])
ylabel('false reject')