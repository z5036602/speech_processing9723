function noise_power = noise_signal_estimation(audio_mat,filter_bank)
    noise_section = audio_mat(1:5,:);  
    noise_section = reshape(noise_section.',1,[]);
    
    noise_subband = zeros(size(filter_bank,1),length(noise_section));
    for i = 1:size(filter_bank,1)
        noise_subband (i,:) = filter(filter_bank(i,:),1,noise_section);
    end  
    noise_power = sum(noise_subband.^2,2)/size(noise_subband,2);
end 