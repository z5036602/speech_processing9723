function [total_speech,sub_bands] = denoise_banks(filter_bank,x,length,incre_dura,win,initial_condition,denoise,u)
    incre = incre_dura;
    window_matrix = enframe(x,length,incre);
    %estimate the noise power in each filter bank from 1:10 frames
    subband_noise_power = noise_signal_estimation(window_matrix,filter_bank);
    
    switch win
        case 'hamming'
            my_window = hamming(length);
        case 'hanning'
            my_window = hann(length);
        case 'balckman'
            my_window = blackman(length);
        otherwise
            my_window = rectwin(length);
    end
    
    for k = 1:size(window_matrix,1)
        window_matrix(k,:) = window_matrix(k,:).*transpose(my_window);
    end
    
    one_bank_of_signal=zeros(size(filter_bank,1),size(window_matrix,2));
    output = zeros(size(window_matrix));
    
    if initial_condition == false
        for k = 1:size(window_matrix,1)
            for i = 1:size(filter_bank,1)
                one_bank_of_signal (i,:) = filter(filter_bank(i,:),1,window_matrix(k,:));
        
            end  
            output(k,:) = sum(one_bank_of_signal,1);
        end 
    else 
        initial_cond_vector = zeros(size(filter_bank,1),size(filter_bank,2)-1);
        
        for k = 1:size(window_matrix,1)
            % caculate power of signals in that frame
%             frame_power = power_of_signal(window_matrix(k,:));
%             signal_power =  frame_power-subband_noise_power;
            
            
            
            
            for i = 1:size(filter_bank,1)
%                 switch denoise
%                     case true
%                         K = (signal_power(i)/(signal_power(i)+u*subband_noise_power(i)));
%                     case false
%                         K = 1; 
%                 end    
                
                [y,zf] = filter(filter_bank(i,:),1,window_matrix(k,:),initial_cond_vector(i,:));
                one_bank_of_signal(i,:) = y;
                initial_cond_vector(i,:) = zf;
                
                frame_power = power_of_signal(y);
                signal_power =  frame_power-subband_noise_power(i);
                
                 switch denoise
                    case true
                        K = (signal_power/(signal_power+u*subband_noise_power(i)));
                    case false
                        K = 1; 
                 end  
                one_bank_of_signal(i,:) = K*y;
            end  
            output(k,:) = sum(one_bank_of_signal,1);
        end 
        
    end 
    sub_bands = output;
    total_speech = reshape(output.',1,[]);
end 