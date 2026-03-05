data = readtable("Finansal_Veriseti_Doldurulmus.csv", 'VariableNamingRule','preserve');

numData = data(:,2:end);
for i = 1:width(numData)
    if iscell(numData.(i)) || isstring(numData.(i))
        numData.(i) = str2double(strrep(string(numData.(i)), ',', '.'));
    end
end

numData = rmmissing(numData); 

y = numData.Altin;
X = removevars(numData, {'Altin'});

cv = cvpartition(length(y),'HoldOut',0.2);
Xtrain = X(training(cv),:);
ytrain = y(training(cv),:);
Xtest  = X(test(cv),:);
ytest  = y(test(cv),:);


% Random Forest (Bagging)
rfModel = fitrensemble(Xtrain, ytrain, ...
                       'Method','Bag', ...
                       'NumLearningCycles',300, ...
                       'Learners','tree');
yPredRF = predict(rfModel, Xtest);

MSE_RF = mean((ytest - yPredRF).^2);
RMSE_RF = sqrt(MSE_RF);
R2_RF = corr(ytest,yPredRF)^2; % 'Rows','complete' artık gereksiz olmalı


gbModel = fitrensemble(Xtrain, ytrain, ...
                       'Method','LSBoost', ...
                       'NumLearningCycles',300, ...
                       'Learners','tree');
yPredGB = predict(gbModel, Xtest);

MSE_GB = mean((ytest - yPredGB).^2);
RMSE_GB = sqrt(MSE_GB);
R2_GB = corr(ytest,yPredGB)^2;


fprintf('Random Forest: R2=%.4f, RMSE=%.4f\n', R2_RF, RMSE_RF);
fprintf('Gradient Boosting: R2=%.4f, RMSE=%.4f\n', R2_GB, RMSE_GB);


% Gerçek vs Tahmin - Random Forest
figure;
scatter(ytest, yPredRF, 'filled');
xlabel('Gerçek Altın Fiyatı'); ylabel('Tahmin (RF)');
title(sprintf('Random Forest Tahminleri (R^2=%.3f)', R2_RF));
grid on; refline(1,0);

% Gerçek vs Tahmin - Gradient Boosting
figure;
scatter(ytest, yPredGB, 'filled');
xlabel('Gerçek Altın Fiyatı'); ylabel('Tahmin (GB)');
title(sprintf('Gradient Boosting Tahminleri (R^2=%.3f)', R2_GB));
grid on; refline(1,0);

% Özellik Önemleri (Random Forest)
figure;
imp = predictorImportance(rfModel);
bar(imp);
set(gca,'XTickLabel',rfModel.PredictorNames,'XTickLabelRotation',45);
ylabel('Önem Skoru');
title('Random Forest - Özellik Önemleri');
grid on;