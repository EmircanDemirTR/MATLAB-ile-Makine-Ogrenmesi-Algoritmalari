load fisheriris;

irisData = array2table(meas, 'VariableNames',{'SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'});

irisData.Species = species; % Tür bilgisi, sınıflandırma problemleminde kullanılacak.

head(irisData);

view(trainedModel.RegressionTree, 'Mode','graph');