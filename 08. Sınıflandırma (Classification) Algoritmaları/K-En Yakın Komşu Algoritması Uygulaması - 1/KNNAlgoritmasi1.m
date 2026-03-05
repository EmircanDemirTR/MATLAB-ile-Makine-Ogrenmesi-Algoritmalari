load fisheriris;
X = meas;
Y = species;

rng(1);

cvp = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(cvp.training, :);
XTest = X(cvp.test, :);
YTrain = Y(cvp.training, :);
YTest = Y(cvp.test, :);

Mdl = fitcknn(XTrain, YTrain, 'NumNeighbors',5, 'Standardize',true);

predictedSpecies = predict(Mdl, XTest);

accuracy = sum(strcmp(predictedSpecies, YTest)) / numel(YTest);
disp(["Doğruluk Orani:", num2str(accuracy*100), '%']);