clc; clear; close all;

data = readtable('heart.csv');  
X = data(:,1:end-1);
y = table2array(data(:,end));

k = 5;

%% Otomatik Grid Search
opts = struct('Optimizer','gridsearch', ...   % yöntem: grid search
              'Kfold',k, ...                 % çapraz doğrulama
              'ShowPlots',false, ...          % ilerleme grafiği gösterme
              'Verbose',1);                  % ekrana yazdır

mdl = fitctree(X, y, ...
    'OptimizeHyperparameters',{'MinLeafSize','MaxNumSplits'}, ...
    'HyperparameterOptimizationOptions',opts);

bestLeaf  = mdl.ModelParameters.MinLeaf;
bestSplit = mdl.ModelParameters.MaxSplits;

fprintf("\nOtomatik Grid Search En İyi Sonuç: Acc(CV)=%.2f%% | Leaf=%d, Splits=%d\n", ...
    100*(1 - resubLoss(mdl)), bestLeaf, bestSplit);
