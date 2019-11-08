sdir = 'F:\TIDIGITS\TRAIN\MAN\';
tdir = 'G:\MATLAB\R2006a\work\Labs\TIDIGITS\';
digits = {'0' '1' '2' '3' '4' '5' '6' '7' '8' '9'};
sdigits = {'O' '1' '2' '3' '4' '5' '6' '7' '8' '9'};

% for i=1:length(digits)
%     dos(['md ' tdir digits{i}]);
% end
sf = 2^15;
a = dir(sdir);
for i=1:length(digits)
    tfold = [tdir digits{i} '\'];
    for j=3:length(a)
        snamea = [sdigits{i} 'A.WAV'];
        snameb = [sdigits{i} 'B.WAV'];
        tnamea = ['man.' a(j).name '.' digits{i} 'a.raw'];
        tnameb = ['man.' a(j).name '.' digits{i} 'b.raw'];
        [x,fs] = readsph([sdir a(j).name '\' snamea]);
        rx = resample(x,16000,fs);
        srx = sf*rx;
        fid = fopen([tfold tnamea],'wb');
        fwrite(fid,srx,'short');
        fclose(fid);
        [x,fs] = readsph([sdir a(j).name '\' snameb]);
        rx = resample(x,16000,fs);
        srx = sf*rx;
        fid = fopen([tfold tnameb],'wb');
        fwrite(fid,srx,'short');
        fclose(fid);
    end
end