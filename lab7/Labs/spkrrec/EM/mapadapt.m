function [gmm_model] = mapadapt(X,UBM_model)
    
    
    [N,mean,~,~] = sufficient_statistics_extraction(X,UBM_model);
    r = 16;
    alpha = N./(N+r);
    alpha = repmat(alpha',1,13);
    m =UBM_model.u .* (1 - alpha) + mean .* alpha; 
    gmm_model.sigma = UBM_model.sigma;
    gmm_model.weights = UBM_model.weights;
    gmm_model.u = m;
    gmm_model.num_of_components = UBM_model.num_of_components;
end