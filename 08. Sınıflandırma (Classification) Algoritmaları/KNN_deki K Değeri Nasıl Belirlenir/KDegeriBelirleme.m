load fisheriris;

X = meas;
Y = species;

cv = cvpartition(Y, 'HoldOut', 0.3);

XEgitim = X(cv.training, :);
YEgitim = Y(cv.training, :);

XTest = X(cv.test, :);
YTest = Y(cv.test, :);

% MANUEL K DEĞERİ
k_degerleri = 1:20;

dogruluk_oranlari = [];

fprintf("Manuel K Değeri Belirleme\n")
for k = k_degerleri
    mdl = fitcknn(XEgitim, YEgitim, 'NumNeighbors', k);
    predictions = predict(mdl, XTest);
    dogruluk = mean(strcmp(predictions, YTest));
    dogruluk_oranlari = [dogruluk_oranlari, dogruluk];
    fprintf('K = %d, Doğruluk Oranı = %.2f\n', k, dogruluk);
end

% OTOMATİK HİPERPARAMETRE OPTİMİZASYONU

optimized_mdl = fitcknn(X, Y, 'OptimizeHyperparameters','auto', 'HyperparameterOptimizationOptions',...
    struct('AcquisitionFunctionName', 'expected-improvement-plus', 'ShowPlots', false, 'Verbose', 0));

en_iyi_k_degeri = optimized_mdl.NumNeighbors;

fprintf("\nBulunan en iyi K değeri: %d\n", en_iyi_k_degeri);