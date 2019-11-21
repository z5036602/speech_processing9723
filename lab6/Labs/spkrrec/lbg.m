function C = lbg(data,csize)

% C = lbg(data,csize)
%
% LBG algorithm for codebook design
% data  : matrix with training vectors in rows
% csize : desired codebook size (must be a power of 2)
% C     : codebook with csize rows
%
% Reference:
% Linde, Y., Buzo, A., and Gray, R. M. (1980). 
% "An algorithm for vector quantiser design", 
% IEEE Trans. Commun., vol. COM-28, no. 1, pp. 84-95, January.

epsil = 0.005;
[L,N] = size(data);

% Initialization

C = mean(data); % codebook of size 1 is the centroid of training data
P = 0.1*std(data); % perturbation vector

% Iteration

for n = 1:log2(csize), % current codebook size: 2^n
   
   % Split codebook using perturbation vectors
   C = [C - ones(size(C,1),1)*P; C + ones(size(C,1),1)*P];
   disp(['Codebook split to size ' num2str(size(C,1))]);
   
   for m = 1:L, % quantize training data using current codebook
      min = 1e20;
      for k = 1:2^n,
         d = sqrt(mean((data(m,:)-C(k,:)).^2));
         if d<min, min = d; distn(m) = d; minidx(m) = k; end
      end
   end
   
   prevdistn = 1e20; currdistn = sum(distn) % total current distortion
   while (((prevdistn-currdistn)/currdistn)>epsil), % stopping criterion
      
      prevdistn = currdistn;
      
      % Each code vector is replaced by the average of the training 
      % vectors which were quantized by it
      for k = 1:2^n,
         temp = data(find(minidx==k),:);
         if isempty(temp),
            C(k,:) = zeros(1,N);
         else
            C(k,:) = mean(data(find(minidx==k),:));
         end
      end
      
      for m = 1:L, % quantize training data using current codebook
         min = 1e20;
         for k = 1:2^n,
         	d = sqrt(mean((data(m,:)-C(k,:)).^2));
            if d<min, min = d; distn(m) = d; minidx(m) = k; end
         end
      end
      
      currdistn = sum(distn) % total current distortion
      
   end
   
end
