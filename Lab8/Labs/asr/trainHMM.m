function [model,LL] = trainHMM(asrvectors,word,files,states,mixs)

% function model = trainHMM(asrvectors,word,states,mixs)
% Uses randomised initial model parameters, diagonal covariance matrices
% asrvectors : cell array of speech data in matrix form (rows are feature vectors)
%              asrvectors{n}{m} is the m'th utterance of the n'th word
% word : (integer > 0) index of the word the model is to be trained for
% files : (vector of integer > 0) indices of the files the model is to be
%         trained on
% states : number of states
% mixs : number of Gaussian mixtures per state
% model : trained model
%         model.prior : priors
%         model.mu : GMM means for each state
%         model.sigma : GMM covariances for each state
%         model.mixmat : GMM weights for each state
%         model.transmat : transition probabilities for the model
% LL : log-likelihood of training data on trained model

for file = files,
    data{file} = asrvectors{word}{file}';
end

% Initialise the HMM parameters
[dim,L] = size(data{1}); % L is not used
prior0 = ones(states,1)/states; %normalise(rand(states,1));
transmat0 = ones(states,states)/states; %mk_stochastic(rand(states,states));
[mu0, sigma0] = mixgauss_init(states*mixs, data{1}, 'diag');
mu0 = reshape(mu0, [dim states mixs]);
sigma0 = reshape(sigma0, [dim dim states mixs]);
mixmat0 = ones(states,mixs)/mixs; %mk_stochastic(rand(states,mixs));

% Perform HMM training
[ll_trace, model.prior, model.transmat, model.mu, model.sigma, model.mixmat] ... 
= mhmm_em(data, prior0, transmat0, mu0, sigma0, mixmat0,'cov_type','diag');

% Return a log likelihood for the training data
LL = mhmm_logprob(data, model.prior, model.transmat, model.mu, model.sigma, model.mixmat);

