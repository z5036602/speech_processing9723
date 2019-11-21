function DCT_output = joshua_dct(x)
    lx=length(x);
    X=[x zeros(1,N-lx)];
    CN=zeros(N);
    for n=0:N-1
        for k=0:N-1
            if k==0
                CN(k+1,n+1)=sqrt(1/N);
            else
                CN(k+1,n+1)=sqrt(2/N)*cos(pi*(n+0.5)*k/N);
            end;
        end;
    end;
    c=CN*X.';

end 