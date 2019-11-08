function output = DCT_II(x)
    output = zeros(1,length(x));
    N = length(x);
    for k=0:N-1
        dct_sum = 0;
        for n=0:N-1
            dct_sum = dct_sum+x(n+1)*cos((pi/(2*N))*k*(2*n+1));
         
        end
        output(k+1) = 2*dct_sum;
    end
    
end 