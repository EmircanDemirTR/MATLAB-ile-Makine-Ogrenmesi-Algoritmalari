data = readtable("breast_cancer_bd.csv");

Y = categorical(data.Class);

X = data(:, 2:end-1);

cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv), :);
YTrain = Y(training(cv),:);
XTest = X(test(cv), :);
YTest = Y(test(cv),:);

mdl = fitcknn(XTrain, YTrain, 'NumNeighbors',5);

YPred = predict(mdl, XTest);

C = confusionmat(YTest, YPred);

% Sınıflar
TN = C(1,1);
FP = C(1,2);
FN = C(2,1);
TP = C(2,2);

Accuracy = (TP+TN) / sum(C(:));
Precision = TP / (TP+FP);
Recall = TP / (TP+FN);
F1Score = 2 *(Precision*Recall) / (Precision+Recall);

fprintf('Doğruluk: %.2f%%\n', Accuracy * 100);
fprintf('Kesinlik: %.2f%%\n', Precision * 100);
fprintf('Duyarlılık: %.2f%%\n', Recall * 100);
fprintf('F1 Score: %.2f\n', F1Score*100);