function filter_bank = sythesis_filter (filter_bank)
    for i =1:size(filter_bank,1)
        filter_bank(i,:) = flip(filter_bank(i,:));
    end 
end 