clear all;
addpath('C:\Users\Joshua Liu\Desktop\DP\mfcc');
prompt = 'Enter the file name: ';
fileName = input(prompt,'s');
[x,fs]= audioread(fileName);
FrameLen = 400;     % frame size
inc = 160;           % frame increment
%%%kaldi
f_low = 20;
f_high = 7800;
bank_number = 23;
MY_MFC = Josh_MFCC(x,fs,FrameLen,inc,f_low,f_high,bank_number); 

