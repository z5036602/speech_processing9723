function LL = calcHMMLL(data,model)

% function model = trainHMM(asrvectors,word,states,mixs)
% Uses randomised initial model parameters, diagonal covariance matrices
% data : speech file in matrix format (rows are feature vectors)
% model : trained model
%         model.prior : priors
%         model.mu : GMM means for each state
%         model.sigma : GMM covariances for each state
%         model.mixmat : GMM weights for each state
%         model.transmat : transition probabilities for the model
% LL : log-likelihood of training data on trained model

[r,c] = size(data);
if r>c, data = data'; end
LL = mhmm_logprob(data, model.prior, model.transmat, model.mu, model.sigma, model.mixmat);

