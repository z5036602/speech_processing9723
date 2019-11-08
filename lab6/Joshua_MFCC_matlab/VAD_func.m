function [y1 y2] = VAD(x)

x = x / max(abs(x)); %normalize input signal with amplitude between -1 and 1

%settings
FrameLen = 256;     % frame size
inc = 40;           % frame increment
amp1 = 2.5;          % begining threshold energy highest limit
amp2 = 2;           % begining threshold energy lowest limit
zcr1 = 10;          % begining threshold zero corssing rate highest limit
zcr2 = 5;           % begining threshold zero crossing rate lowest limit
record = zeros(10,1);
decord = zeros(10,1);
k = 1;
minsilence = 6;   % shortest no-voice time to conclude that the signal finishes
minlen  = 15;     % shortest time for the voice to conclude that it is a signal
status  = 0;      % initial signal status
count   = 0;      % signal sequence length
silence = 0;      % no-voice length
 
%calcuate the zero crossing rate
tmp1  = enframe(x(1:end-1), FrameLen,inc);
tmp2  = enframe(x(2:end)  , FrameLen,inc);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 - tmp2)>0.02
zcr   = sum(signs.*diffs,2);
 
amp = sum((abs(enframe( x, FrameLen, inc))).^2, 2);
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);
 
for n=1:length(zcr)
   goto = 0;
   switch status
   case {0,1}                   
      if amp(n) > amp1        
         x1 = max(n-count-1,1)+2; 
         status  = 2;
         silence = 0;
         count   = count + 1;
      elseif amp(n) > amp2 || zcr(n) > zcr2 
         status = 1;
         count  = count + 1;
      else                       
         status  = 0;
         count   = 0;
      end
   case 2,                       
      if amp(n) > amp2 ||zcr(n) > zcr2
          if n == length(zcr) - 6
              count = count + 5;
              status = 3;
          else
             count = count + 1;
          end
         
      else                       
         silence = silence+1;
         if silence < minsilence 
            count  = count + 1;
         elseif count < minlen   
            status  = 0;
            silence = 0;
            count   = 0;
         else                    
            status  = 3;
         end
      end
   case 3,
      record(k) = x1;
      count = count-silence/2;
      x2 = x1 + count -1;
      decord(k) = x2;
      k = k + 1;
      status = 0;
      silence = 0;
   end
   
end

y1 = record;
y2 = decord;
end