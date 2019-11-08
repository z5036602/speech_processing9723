clear all;
prompt = 'Enter the file name: ';
fileName = input(prompt,'s');
[x,fs]= audioread(fileName);
x = x / max(abs(x)); %normalize input signal with amplitude between -1 and 1
%settings

FrameLen = 256;     % frame size
inc = 20;           % frame increment
amp1 = 0.3;          % begining threshold energy highest limit
amp2 = 0.3;           % begining threshold energy lowest limit
zcr2 = 0.8;           % begining threshold zero crossing rate lowest limit
record = zeros(10,1);
decord = zeros(10,1);
k = 1;
i = 1;
m = 1;
number = 0;
minsilence = 20;   % shortest no-voice time to conclude that the signal finishes
minlen  = 50;     % shortest time for the voice to conclude that it is a signal
status  = 0;      % initial signal status
count   = 0;      % signal sequence length
silence = 0;      % no-voice length
 
%calcuate the zero crossing rate
tmp1  = enframe(x(1:end-1), FrameLen,inc);
tmp2  = enframe(x(2:end)  , FrameLen,inc);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 - tmp2)>0.02;
zcr   = sum(signs.*diffs,2);%虽然没搞懂上边的原理，但是可以推测存的是各桢的过零率。上边计算过零率的放到后边分析，这里只要了解通过这几句得到了信号各帧的过零率值，放到zcr矩阵中。
 
%计算短时能量
%amp = sum((abs(enframe(filter([1 -0.9375], 1, x), FrameLen, inc))).^2, 2);%不知道这里的filter是干啥的？但的出来的是各贞的能量了。
amp = sum((abs(enframe( x, FrameLen, inc))).^2, 2);%通过把filter给去掉，发现结果差不多，所以个人感觉没必要加一个滤波器，上边出现的enframe函数放到后边分析。这里知道是求出x各帧的能量值就行。
 
%调整能量门限
amp1 = min(amp1, max(amp)/20);
amp2 = min(amp2, max(amp)/8);%min函数是求最小值的，没必要说了。
 
%开始端点检测
for n=1:length(zcr)%从这里开始才是整个程序的思路。Length（zcr）得到的是整个信号的帧数。
   goto = 0;
   switch status
   case {0,1}                   % 0 = 静音, 1 = 可能开始
      if amp(n) > 0.1 && zcr(n)>3     % 确信进入语音段
         x1 = n; % 记录语音段的起始点
         status  = 2;
         silence = 0;
         count   = count + 1;
      elseif amp(n) > amp2 && zcr(n) > zcr2 % 可能处于语音段
         status = 1;
         count  = count + 1;
      else                       % 静音状态
         status  = 0;
         count   = 0;
      end
   case 2,                       % 2 = 语音段
      if amp(n) > 0.09 && zcr(n) > 3
          if  length(zcr) - n < minsilence+3
              count = count + minsilence-1;
              status = 3;   

          else
             
             count = count + 1;
             silence = 0;
          end
         
      else                       % 语音将结束
         silence = silence+1;      
         if silence < minsilence % 静音还不够长，尚未结束
            count  = count + 1;
         elseif count < minlen   % 语音长度太短，认为是噪声
            status  = 0;
            silence = 0;
            count   = 0;
         else                    % 语音结束
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
      count = 0;
      number = number + 1;
   end
   
end

subplot(3,1,1);
plot(x);
axis([1 length(x) -1 1]);
ylabel('Speech');

for i = 1:number
    test1 = record(i);
    test2 = decord(i);
    line([test1*inc test1*inc], [-1 1], 'Color', 'red');
    line([test2*inc test2*inc], [-1 1], 'Color', 'red');
end                                                   
 
subplot(3,1,2);
plot(amp);
axis([1 length(amp) 0 max(amp)]);
ylabel('Energy');
for i = 1:number
    test1 = record(i);
    test2 = decord(i);
    line([test1 test1], [min(amp),max(amp)], 'Color', 'red');
    line([test2 test2], [min(amp),max(amp)], 'Color', 'red');
end    
 
subplot(3,1,3);
plot(zcr);
axis([1 length(zcr) 0 max(zcr)]);
ylabel('ZCR');
for i = 1:number
    test1 = record(i);
    test2 = decord(i);
    line([test1 test1], [min(zcr),max(zcr)], 'Color', 'red');
    line([test2 test2], [min(zcr),max(zcr)], 'Color', 'red');
end

range = [];
for m = 1:number
    range = [range decord(m)-record(m)];
end
range