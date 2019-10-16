%input data_matrix rows are observations/frames
function frame_selection = VAD(data_matrix)
    sig_mag = abs(data_matrix);
    energy = sum(sig_mag,2);
    energy_threshold = 0.6*mean(energy);
    energy_frame_slection = find(energy<=energy_threshold);
    ZCR_vector = ZCR(data_matrix');
    crossing_rate_threshold = 0.8*mean(ZCR_vector);
    ZCR_frame_selection = find(ZCR_vector>=crossing_rate_threshold);
    frame_selection = intersect(energy_frame_slection,ZCR_frame_selection);



end 