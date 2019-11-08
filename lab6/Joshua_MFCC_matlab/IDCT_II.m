function IDCT_ouput = IDCT_II(x)
    IDCT_ouput = zeros(1,length(x));
    N = length(x);
    for n=0:N-1
        dct_sum = 0;
        for k=0:N-1
            if k == 0
                dct_sum = dct_sum+0.5*x(k+1)*cos((pi/(2*N))*k*(2*n+1));
            else 
                dct_sum = dct_sum+x(k+1)*cos((pi/(2*N))*k*(2*n+1));
            end 
        end
        IDCT_ouput(n+1) = dct_sum/N;
    end
    
end 


