load fisheriris;

data = array2table(meas, 'VariableNames', {'SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'});
data.Species = species;

cv = cvpartition(data.Species, 'HoldOut', 0.3);
trainIdx = training(cv);
testIdx = test(cv);
trainData = data(trainIdx, :);
testData = data(testIdx, :);

mdl = fitcnb(trainData{:,1:4},trainData.Species, 'DistributionNames','normal');

capraz_mdl = crossval(mdl, 'KFold', 5);
loss = kfoldLoss(capraz_mdl);
accuracy = 1-loss;
disp(['Çapraz Doğrulama Doğruluğu: ', num2str(accuracy)]);

precitedLabels = predict(mdl, testData{:,1:4});

confMat = confusionmat(testData.Species, precitedLabels);
disp(confMat);

figure();
gscatter(testData.SepalLength, testData.SepalWidth, precitedLabels, 'rgb', 'osd', [], 10);
xlabel('Sepal Length');
ylabel('Sepal Width');
legend('Setosa', 'Versicolor', 'Virginica');