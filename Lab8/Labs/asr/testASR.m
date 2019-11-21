% testASR 
trained = 0;

% Train models
if ~trained,
    for word = 1:10,
        [models{word},ll] = trainHMM(asrvectors,word,1:122,6,3);
    end
end

% Test
clear idx scores
fn = 1;
for filenum = 123:222
    for testword = 1:10,
        for mdl = 1:10,
            scores(testword,mdl) = calcHMMLL(asrvectors{testword}{filenum},models{mdl});
        end
    end
    [y,idx(fn,:)] = max(scores');
    fn = fn + 1;
end
[r,c] = size(idx);
err = (idx-1~=ones(r,1)*(0:9));
word_error_rate = sum(sum(err))/(r*c)