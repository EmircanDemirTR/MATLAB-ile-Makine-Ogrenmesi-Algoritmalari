cancer_data = readtable("breast_cancer_bd.csv");
cancer_data = rmmissing(cancer_data);

X = table2array(cancer_data(:,2:10));
Y = categorical(table2array(cancer_data(:,11)));

cv = cvpartition(size(X,1), 'HoldOut', 0.3);
idx = test(cv);
XTrain = X(~idx,:);
YTrain = Y(~idx);
XTest = X(idx,:);
YTest = Y(idx);

mdl = fitcknn(XTrain, YTrain, 'NumNeighbors',5, 'Distance','cityblock', 'DistanceWeight','squaredinverse');

YPred = predict(mdl, XTest);
accuracy = sum(YPred == YTest) / numel(YTest);
disp(["Doğruluk: ", num2str(accuracy*100)]);

C = confusionmat(YTest, YPred);
confusionchart(C, categories(Y));

TP= C(2,2);
FN = C(2,1);
FP = C(1,2); % False Positives
TN = C(1,1); % True Negatives

sensitivity = TP / (TP + FN); % Duyarlılık -- Gerçek pozitiflerin ne kadarının yakalanbildiği
specificity = TN / (TN + FP); % Özgüllük Gerçek nefatiflerinin ne kadarının doğru yakalandığı
precision = TP / (TP+FP); % Hassasiyet --- Pozitif tahminlerin ne kadarının doğru olduğu

disp(["Hassasiyet", num2str(sensitivity)]);
disp(["Duyarlılık", num2str(specificity)]);
disp(["Özgüllük", num2str(precision)]);

% Test Verisiyle Deneme
test_datas = [...
    [2, 1, 1, 1, 2,1,3,1,1]; % Bening Tarzı
    [5,10,10,3,7,3,8,10,2] % Malignant Tarzı (Kötü)
    ];
% Predict the classes for the test data
testPredictions = predict(mdl, test_datas);

for i = 1:size(test_datas, 1)
    disp(["Test Verisi ", num2str(i), " tahmin: ", char(testPredictions(i))]);
end