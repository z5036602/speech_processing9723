%%%this function update the parameters by expectation maximisation
%   when EM hit the singularity, similar to sklearn,small noise $1e-6 * Identity matrix$ 
%   will be added with covariance matrix to prevent singularity.
%   the formula used here is from https://subjects.ee.unsw.edu.au/elec9782/elec9782-B-lec4.pdf
%   slide 15.
%input:
%   X -- > data 
%   gmm_model_old-->a struct stores original model parameters
%output:
%   gmm_model_new-->a struct stores new model parameters 
%   singularity_flag --> report whether the EM hit the singularity point

function [gmm_model_new,llh] = updation(X,gmm_model_old)
    %%%extract the parameters from model struct and assert the input correctness
    u_old = gmm_model_old.u;
    num_of_components = gmm_model_old.num_of_components;
    assert(size(u_old,1)==num_of_components,'number of means does not agree on num of components');
    assert(size(u_old,2)==size(X,2),'means dimension does not agree on num of components');
    %%%caculate the posterior probability gamma given data.
    num_of_observations = size(X,1);
    [gamma_matrix,llh] = latent_pospdf(X,gmm_model_old);
    
    %%%update the paramters
    %%%https://subjects.ee.unsw.edu.au/elec9782/elec9782-B-lec4.pdf
    %%%page 15.
    N_k = sum(gamma_matrix,1);
    
    u_new = (gamma_matrix'*X)./N_k';
    sigma_new = zeros(size(X,2),size(X,2),num_of_components);
    for m = 1:num_of_components
        sigma_sum=0;
        for n = 1:num_of_observations
            U = (X(n,:)-u_old(m,:))'*(X(n,:)-u_old(m,:));  
            sigma_sum=sigma_sum+gamma_matrix(n,m)*U;                    
                 
        end
        sigma_new(:,:,m) =sigma_sum/N_k(m)+eye(size(sigma_sum,2))*(1e-6);
     
    end
    weights = N_k/num_of_observations;
    
    %%%construct the new model struct with updated parameters
    gmm_model_new.u = u_new;
    gmm_model_new.sigma = sigma_new;
    gmm_model_new.weights = weights;
    gmm_model_new.num_of_components = gmm_model_old.num_of_components;
end