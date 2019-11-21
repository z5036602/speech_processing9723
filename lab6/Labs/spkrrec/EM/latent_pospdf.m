%   Given the model and a data point,this function can caculate the posterior 
%   pabability of p(z|x u sigma) for ***all the observations***.

%   p(z|x u sigma)= pi_k*N(x|theta_k)/ sum_{j}(pi_j*N(x|theta_j)). 
%   it gives us for each datapoint x_i the measure of: 
%   "prabability that a given data belongs to a certain class/probability of x_i over all classes" 
%   this function is similar to matlab built-in function "posterior()"

%   For convenience this function also ouputs the total log-likelihood wich is
%   essentially the log of sum_{j}(pi_j*N(x|theta_j))(the mariginal
%   likelihood of the X)
%input: x-->data (no restrictions on observtions and dimensions)
%       gmm_model-->a struct stores number of components and parameters of the model
%                 
%output:gamma-->posteriror probability matrix, the row represents
%               observations,cololumn corresponds to probability belongs to
%               each gaussian distribution.
%       llh --> total log liklihood of data given current updated model



function [gamma,llh] = latent_pospdf(x,gmm_model)
    %%%extract the value from model struct and assert the input correctness
    u = gmm_model.u;
    sigma = gmm_model.sigma;
    weights = gmm_model.weights;
    num_of_components = gmm_model.num_of_components;
    assert(isvector(weights),'models weights input are wrong');
    assert(num_of_components==length(weights),'components number not equal wights number');
    assert(ismatrix(sigma(:,:,1)),'sigma dimension is wrong');
    
    %%%caculates the pi_k*N(x|theta_k), 
    %the caculation here is matrixlised.Given the data matrix, row
    %represents each observation, columns represents dimension.
    %The caculated output has row represents each observation, 
    %columns represents different gaussian clusters .
    
    
    num_of_observations = size(x,1);
    log_Num = zeros(num_of_observations,num_of_components);
    for m = 1:num_of_components
         log_Num(:,m) = logpdfmvn(x,u(m,:),sigma(:,:,m));
    end
    log_Num = log_Num+log(weights);
    log_DEN = log(sum(exp(log_Num),2));
    %log_DEN = logsumexp(log_Num,2);
   
    gamma = exp(log_Num-log_DEN);
    
    %%%caculates the log-likelihood
    llh = sum(log_DEN)/num_of_observations; % loglikelihood
   
end

