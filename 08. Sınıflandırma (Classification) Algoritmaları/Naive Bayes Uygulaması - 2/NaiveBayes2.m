load ionosphere;

cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv),:);
YTrain = Y(training(cv),:);
XTest = X(test(cv), :);
YTest = Y(test(cv), :);

svmModel = fitcsvm(XTrain, YTrain, 'Standardize',true, 'KernelFunction','rbf');

YPred = predict(svmModel, XTest);
accuracy = sum(strcmp(YPred, YTest))/length(YTest);
fprintf('Accuracy of the SVM model: %.2f%%\n', accuracy * 100);

figure();
confusionchart(YTest, YPred);
title("Karmaşıklık Matrisi");

[C, order] = confusionmat(YTest, YPred);
disp('Sınıf Sırası:'); disp(order');

precision = diag(C)./sum(C,1)';
recall = diag(C)./sum(C,2);
f1Score = 2 * (precision .* recall) ./ (precision + recall);
disp('F1 Skoru:'); disp(f1Score);

performans_tablosu = table(order, precision,  recall, f1Score, 'VariableNames', {'Sınıf', 'Precision', 'Recall', 'F1_Skoru'});
disp(performans_tablosu);
