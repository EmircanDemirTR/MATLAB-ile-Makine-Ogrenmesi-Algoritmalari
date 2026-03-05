X = table2array(wine_data(:,2:end));
Y = categorical(table2array(wine_data(:,1)));

cv = cvpartition(size(X,1), 'HoldOut', 0.3);
idx = test(cv);
XTrain = X(~idx,:);
YTrain = Y(~idx);
XTest = X(idx,:);
YTest = Y(idx);

mdl = fitcknn(XTrain, YTrain, 'NumNeighbors',7, 'Distance', 'cosine');

YPred = predict(mdl, XTest);
accuracy = sum(YPred == YTest) / numel(YTest);
disp(["Doğruluk: ", num2str(accuracy*100)]);

C = confusionmat(YTest, YPred);
confusionchart(C, categories(Y));

% Çapraz Doğrulama
cp = cvpartition(Y, 'KFold', 5);
cv_mdl = fitcknn(X, Y, 'NumNeighbors',7, 'Distance', 'cosine', 'CrossVal','on','CVPartition',cp);
cv_error = kfoldLoss(cv_mdl);
disp(["Çapraz Doğrulama Hatası: ", num2str(cv_error*100)]);

new_data = [13.5, 1.8, 2.3, 20, 100, 2.5, 3.0, 0.3, 1.5, 5.5, 1.0, 3.5, 1000];
predicted_class = predict(mdl, new_data);
disp(["Yeni şarabın tahmin edilen sınıfı: ", char(predicted_class)]);