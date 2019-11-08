function model = emgmm(data,mixs,numiter)

% GMM parameter estimation using the EM algorithm
% Code based on Webb, A., "Statistical Pattern Recognition", Wiley, 2005
% data : matrix whose rows comprise feature vectors
% mixs : number of mixtures (pref. a power of two)
% numiter : number of iterations
% model : structure containing the model parameters
%         model.means : GMM mean vectors
%         model.covs : GMM variances (note: diagonal covariance matrix used)
%         model.weights : GMM weights
% Note that emgmm uses the LBG algorithm to initialise the GMM means

% Find initial estimate for means, covariances and weights

means = lbg(data,mixs);
covs = ones(mixs,1)*(std(data)).^2;
wts = ones(1,mixs)/mixs;

L = size(data,1);

for iter = 1:numiter,
    % E-step
    for m = 1:mixs,
        for l = 1:L,
            p(l,m) = exp(-1/2*sum((data(l,:)-means(m,:)).^2./covs(m,:)))/sqrt(prod(covs(m,:)));
        end
    end
    for l = 1:L,
        p(l,:) = wts.*p(l,:)/(wts*p(l,:)');
    end
    % M-step
    wts = sum(p)/L;
    for m = 1:mixs,
        means(m,:) = 1/L*sum(p(:,m)*ones(1,size(data,2)).*data)/wts(m);
    end
    for m = 1:mixs,
        for l = 1:L,
            cv(l,:) = (data(l,:)-means(m,:)).^2;
        end
        covs(m,:) = 1/L*sum(cv.*(p(:,m)*ones(1,size(data,2))))/wts(m);
        %covs(m,find(covs(m,:)>10)) = 10*ones(size(find(covs(m,:)>10)));
    end
end
model = struct('means',means,'covs',covs,'weights',wts);