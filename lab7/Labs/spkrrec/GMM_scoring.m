%caculate the likelihood of data under the given GMM model as the score.
function score = GMM_scoring (mfcc_data,GMM_model)
     [~,llh_GMM] = latent_pospdf(mfcc_data,GMM_model);
     score =  llh_GMM;
end
