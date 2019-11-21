function [N,mean,variance,llh] = sufficient_statistics_extraction(X,gmm_model_old)
    [gamma_matrix,llh] = latent_pospdf(X,gmm_model_old);
     num_of_components = gmm_model_old.num_of_components;
    %%%caculate the posterior probability gamma given data.
    num_of_observations = size(X,1);
    %%%update the paramters
    %%%https://subjects.ee.unsw.edu.au/elec9782/elec9782-B-lec4.pdf
    %%%page 15.
    N = sum(gamma_matrix,1)+realmin;
    mean = (gamma_matrix'*X)./N';
    variance = zeros(size(X,2),size(X,2),num_of_components);
    for m = 1:num_of_components
        sigma_sum=0;
        for n = 1:num_of_observations
            U = X(n,:)'*X(n,:);  
            sigma_sum=sigma_sum+gamma_matrix(n,m)*U;                    
                 
        end
        variance(:,:,m) =sigma_sum/N(m);
    
       
    end



end