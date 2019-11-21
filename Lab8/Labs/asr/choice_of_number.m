function likelihood_list = choice_of_number (asrvectors,test)

    model = cell(10,1);
    likelihood_list = zeros(10,1);
    
    for digits = 1:10
        model{digits} = trainHMM(asrvectors,digits,1:10,5,3); 
    end
    counter = 1;
    for model_counter = 1:10 
        likelihood_list(counter) = calcHMMLL(test,model{model_counter});
        counter = counter + 1;
    end

end