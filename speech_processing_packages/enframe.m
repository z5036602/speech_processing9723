function f=enframe(x,win,inc) % win = framelength inc = fram step
%ENFRAME split signal up into (overlapping) frames: one per row. F=(X,WIN,INC)
nx=length(x);
len = win;
if (nargin < 3)
   inc = len;
end
nf = fix((nx-len+inc)/inc);
f=zeros(nf,len);
indf= inc*(0:(nf-1))';
inds = (1:len);
f(:) = x(indf(:,ones(1,len))+inds(ones(nf,1),:));



