function delta_output = Deltas(MFCC_mat)
    delta_output = zeros(size(MFCC_mat));
    for j = 1:size(MFCC_mat,1)
        if j == 1 
            
            delta_output(j,:) = (MFCC_mat(j+1,:)+MFCC_mat(j+2,:))/10;
         
        elseif j == size(MFCC_mat,1)
            delta_output(j,:) = (-MFCC_mat(j-1,:)-MFCC_mat(j-2,:))/10;
            
        elseif j == 2
            delta_output(j,:) = (MFCC_mat(j+1,:)-MFCC_mat(j-1,:)+MFCC_mat(j+2,:))/10;
                
        elseif j == size(MFCC_mat,1)-1
            delta_output(j,:) = (MFCC_mat(j+1,:)-MFCC_mat(j-1,:)-MFCC_mat(j-2,:))/10;
        else 
        
            delta_output(j,:) = ((MFCC_mat(j+1,:)-MFCC_mat(j-1,:))+(MFCC_mat(j+2,:)-MFCC_mat(j-2,:)))/10;
        end
    end 



end