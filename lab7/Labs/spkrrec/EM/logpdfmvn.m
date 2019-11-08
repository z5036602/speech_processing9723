function y = logpdfmvn(X, mu, Sigma)
    X = X';
    mu = mu';
    d = size(X,1);
    X = bsxfun(@minus,X,mu);
    [U,~]= chol(Sigma);
    Q = U'\X;
    q = dot(Q,Q,1);  
    c = d*log(2*pi)+2*sum(log(diag(U)));   
    y = -(c+q)/2;
end