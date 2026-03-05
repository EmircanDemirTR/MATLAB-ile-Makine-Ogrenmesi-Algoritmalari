data = readtable("breast_cancer_bd.csv");
Y = categorical(data.Class);
X = data(:,2:end-1);

cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv), :);
YTrain = Y(training(cv), :);
XTest = X(test(cv), :);
YTest = Y(test(cv), :);

svmModel = fitcsvm(XTrain, YTrain,...
    'KernelFunction','linear',...
    'Standardize',true,...
    'ClassNames',categorical([2,4]));

svmModel = fitPosterior(svmModel, XTrain, YTrain);
[~, scores] = predict(svmModel, XTest);

[Xroc, Yroc, ~, AUC] = perfcurve(YTest, scores(:,2), categorical(4));

figure;
plot(Xroc, Yroc, 'b-', 'LineWidth',2);
hold on;
plot([0 1], [0 1], 'r--');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title(['ROC Curve (AUC = ' num2str(AUC) ')']);
grid on;

disp(['AUC Değeri: ' num2str(AUC)]);