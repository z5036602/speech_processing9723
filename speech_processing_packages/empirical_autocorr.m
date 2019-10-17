
%this function only caculate the positive lag, so we keep one fixed
%and shift another to the right
function [acs] = empirical_autocorr(data)
    t = length(data);
   acs = zeros(1,t);
    u = 0;
   % caculating empirical autocorelation for each invidual data point
   for i = 1:t
       my_sum = 0;
       for k = 1:length(data)-i+1    
           my_sum = my_sum + (data(k)-u)*(data(k+i-1)-u);
       end 
       acs(i) = my_sum/length(data);
   end 
   
end