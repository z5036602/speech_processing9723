%%%implementation of EM algorithm
%input:
%X --> data with no restriction on dimension and observations
%init --> numebr of gaussians we want
%output:
%gmm_model--> a struct stores number of components and paramters of model
function [gmm_model] = EM(varargin)
    if (nargin ~= 2 && nargin ~= 3) error('Wrong number of inputs');end
    if(nargin == 3) 
        X = varargin{1};
        init = varargin{2};
    end
    if(nargin == 2) 
       X = varargin{1};
       init = varargin{2};
           %%%initialisation process
    %initilise number of componentes
        gmm_model.num_of_components = init;
    %%%initialisation process
    %initilise number of componentes
        gmm_model.num_of_components = init;
    
    %randomly initilise gaussian means. We get maximum and minimum value
    %along all dimensions of all value, and randomly choose value within this
    %range as the value along each dimension of our mean.
        maximum_X = max(X,[],1);
        minimum_X = min(X,[],1);
        r = minimum_X+(maximum_X-minimum_X).*rand(init,size(X,2));
    
        gmm_model.u = r;
    end
  
    %%% initialise the covariance matrix by a constant times identity
    %%% matrix. This constant is caculated as difference between 
    %maximum and minimum value divided by
    %number of components.
    sigma = zeros(size(X,2),size(X,2),init);
    for k = 1:init
        sigma(:,:,k) = eye(size(X,2));
    end
    gmm_model.sigma = sigma;
    %%%initialise the weights,we assmue all weights are equal
    weights = (1/init)*ones(1,init);
    gmm_model.weights = weights;
    
    %%%EM process 
    %iteration = 500;               %%maximum num of iterations
    prev_llh_vec = [];             %%dynamic array for storing the log-liklihood of data after each iteration
    %similarity_hitted = 0;         %%flag for checking if EM hitted singularity
    for it = 1:20
        %%%update the parameter
        [gmm_model,prev_llh] = updation(X,gmm_model);
        %%%check if EM hitted the singularity
%         if singularity_flag == 1
%             similarity_hitted =1;
%         end
        %%%break at log-liklihood become steady
%          if it ~= 1 && prev_llh-prev_llh_vec(end)<1e-4 
%              break
%          end
        %%%store the log-liklihood to show it is maximised
        prev_llh_vec = [prev_llh_vec prev_llh];
        
    end 
%     
%     figure;
%     plot(1:length(prev_llh_vec),prev_llh_vec);



end 
