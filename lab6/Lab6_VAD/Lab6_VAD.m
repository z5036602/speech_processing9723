%input data_matrix rows are observations/frames
%WASTING TIMEEEEEE!!!!!
function [signal,number_of_selected_frames]= Lab6_VAD(data,fs)
    %data  = data-mean(data);
    data_matrix  = enframe(data, 40,40);
    
    sig_mag = abs(data_matrix);
    energy = sum(sig_mag,2);
    energy_threshold = 0.1*mean(energy);
    energy_frame_slection = find(energy>=energy_threshold);
%     ZCR_vector = ZCR(data_matrix');
%     crossing_rate_threshold = 1.1*mean(ZCR_vector);
%     ZCR_frame_selection = find(ZCR_vector<=crossing_rate_threshold);
    
    %frame_selection = intersect(energy_frame_slection,ZCR_frame_selection);
    %%%%
    %LPC sometimes select very few frames and cause the the obeservation
    %less than dimension.
%       LPC_coeff = LPC_voiced_unvoiced_detection(data_matrix);
%       LPC_coeff_selection = find(abs(LPC_coeff)>1.4);    
%       frame_selection = intersect(LPC_coeff_selection,energy_frame_slection);
     number_of_selected_frames = length(energy_frame_slection(1):energy_frame_slection(end));
     %if (number_of_selected_frames>13)
         signal = reshape(data_matrix(energy_frame_slection(1):energy_frame_slection(end),:).',1,[]);
%     else 
%         signal = reshape(data_matrix(1:end,:).',1,[]); 
%     end
end 