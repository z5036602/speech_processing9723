clear;clc
mu1 = [-12 2];          % Mean of the 1st component
sigma1 = [4 0 ; 0 4];  % Covariance of the 1st component
mu2 = [-2 -1];       % Mean of the 2nd component
sigma2 = [1 0 ; 0 1];  % Covariance of the 2nd component
mu3 = [-6 -4];          % Mean of the 3rd component
sigma3 = [3 2; 2 3];  % Covariance of the 2nd component
mu4 = [-3 5];         % Mean of the 4th component
sigma4 = [2 1 ; 1 1];  % Covariance of the 2nd component

rng('shuffle')                  % For reproducibility
r1 = mvnrnd(mu1,sigma1,300);
r2 = mvnrnd(mu2,sigma2,300);
r3 = mvnrnd(mu3,sigma3,400);
%r4 = mvnrnd(mu4,sigma4,400);
X = [r1; r2;r3];

[gmm_model] = EM_with_logsumexp(X,3);

figure;
scatter(X(:,1),X(:,2),10,'.')   % Scatter plot with points of size 10
hold on
gm = gmdistribution(gmm_model.u,gmm_model.sigma,gmm_model.weights);
gmPDF = @(x,y)reshape(pdf(gm,[x(:) y(:)]),size(x));
fcontour(gmPDF,[-10 10 -10 10]);
title('Contour plot of fitted gaussian mixture on data(14 components)')

