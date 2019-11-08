function [label,start,finish] = ldTIMITlab(fname,opt)

% ldTIMITlab
% 21/09/07

% Load TIMIT phone label file
% opt = 'w' => wideband sample indices (16kHz original data)
% opt = 'n' => narrowband sample indices (8kHz downsampled data)

%fname = 'C:\Research\data\TIMIT\TRAIN\DR1\FCJF0\SA1.PHN'; %test

fid=fopen(fname);
n = 1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    [start(n),finish(n),label{n}] = strread(tline,'%d%d%s');
    n = n + 1;
end
fclose(fid);
if opt=='n',
    start = round(start/2);
    finish = round(finish/2);
end
