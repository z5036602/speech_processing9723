%this function caculates the liklihood of data by using the pdf of 1-d gaussian 
%or multivariate gaussian, the function is similar to built-in function
%mvnpdf.m
%input: X-->data no restricitons on rows and columns
%       u-->mean vector of gaussian
%       sigma-->covariance-matrix of gaussian
%output: y --> probability
%%%%%TOO SLOW%%%logpdfmvn is better one and directly giving logliklihood
function y = pdfmvn(X,mu,sigma)
    %%%1-d
    if (iscolumn(X))
        assert(isscalar(mu),'u is not a scalar');
        assert(isscalar(sigma),'sigma is not a scalar');
        constant = 1/(sigma*sqrt(2*pi));
        X = X-mu;
        y = constant.*exp(-X.^2/(2*sigma^2)); 
    %%%2-d.For multiple data, row>1, we pick the diagonal of y as output
    elseif(ismatrix(X))
        dim = size(X,2);
        assert(size(mu,2)== dim,'u dim is not right');
        assert(size(sigma,2)== dim,'sigma dim is not right');
        assert(size(sigma,1)== dim,'sigma dim is not right');
        constant = 1/sqrt(det(sigma)*((2*pi)^dim));
        X = X-mu;
        U = X/sigma;             
        z = (-1/2)*(U*X');
        y = diag(constant.*exp(z));                             
            
    else 
        
        error('wrong input for pdfmvn');
        
    end
    
end 