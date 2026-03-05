data = readtable("breast_cancer_bd.csv");
Y = categorical(data.Class);
X = data(:,2:end-1);

cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv), :);
YTrain = Y(training(cv),:);
XTest = X(test(cv), :);
YTest = Y(test(cv),:);

knnModel = fitcknn(XTrain, YTrain, 'NumNeighbors', 5);

YPred = predict(knnModel, XTest);

figure();
cm =confusionchart(YTest, YPred);
cm.Title = 'KNN için Karmaşıklık Matrisi';
cm.RowSummary = "row-normalized";
cm.ColumnSummary = "column-normalized";