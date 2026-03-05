data_table = readtable("heart.csv");
X=data_table(:, 1:end-1);
Y=categorical(data_table.target, [0,1], {'Saglikli', 'Hasta'});

cv = cvpartition(Y, 'HoldOut', 0.3, 'Stratify',true);
XEgitim = X(cv.training, :);
YEgitim = Y(cv.training);
XTest = X(cv.test, :);
YTest = Y(cv.test);

% Hiperparametre Optimizasyonu 
opts = struct('Optimizer', 'bayesopt',...
    'ShowPlots', true,...
    'CVPartition', cvpartition(YEgitim, 'KFold', 5), ...
    'AcquisitionFunctionName','expected-improvement-plus',...
    'MaxObjectiveEvaluations', 30);

optimized_tree = fitctree(XEgitim, YEgitim, 'OptimizeHyperparameters','all', 'HyperparameterOptimizationOptions',opts);

% Test Performansı
tahmin_opt = predict(optimized_tree, XTest);
dogruluk_opt = mean(tahmin_opt == YTest);

fprintf('Test Doğruluğu %.2f\n', dogruluk_opt*100);

figure();
confusionchart(YTest, tahmin_opt);
title('Optimize Edilmiş Ağacın Performansı');