load ionosphere;
X = X(1:100,:);
Y = Y(1:100);

svm_optimized = fitcsvm(X, Y, 'KernelFunction','rbf',...
    'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus', 'ShowPlots', true, 'Verbose', 1));

cv_loss = kfoldLoss(crossval(svm_optimized));
fprintf("Çapraz Doğrulama Hatası: %f\n", cv_loss);

disp(svm_optimized.HyperparameterOptimizationResults);