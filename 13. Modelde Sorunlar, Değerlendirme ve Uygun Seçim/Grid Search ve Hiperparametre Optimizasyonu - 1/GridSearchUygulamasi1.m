clc; clear; close all;

data = readtable('heart.csv');  
X = data(:,1:end-1);
y = table2array(data(:,end));

k = 5;
cvp = cvpartition(y,'KFold',k);

minLeafOptions = [1, 5, 10, 20, 50];
maxSplitOptions = [5, 10, 20, 50, 100];

bestAcc = 0;
bestParams = struct();

for leaf = minLeafOptions
    for split = maxSplitOptions
        acc = zeros(k,1);
        for i = 1:k
            model = fitctree(X(training(cvp,i),:), y(training(cvp,i)), ...
                        'MinLeafSize', leaf, 'MaxNumSplits', split);
            preds = predict(model, X(test(cvp,i),:));
            acc(i) = mean(preds == y(test(cvp,i)));
        end
        meanAcc = mean(acc);

        fprintf("Leaf=%d, Splits=%d => Acc=%.2f%%\n", leaf, split, meanAcc*100);

        if meanAcc > bestAcc
            bestAcc = meanAcc;
            bestParams.MinLeafSize = leaf;
            bestParams.MaxNumSplits = split;
        end
    end
end

fprintf("\nGrid Search En İyi Sonuç: Acc=%.2f%% | Leaf=%d, Splits=%d\n", ...
    bestAcc*100, bestParams.MinLeafSize, bestParams.MaxNumSplits);
