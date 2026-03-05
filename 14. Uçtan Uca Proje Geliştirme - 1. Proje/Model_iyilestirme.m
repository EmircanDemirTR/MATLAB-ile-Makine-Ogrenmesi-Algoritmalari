clear; clc; close all;

data = readtable("Finansal_Veriseti_Doldurulmus.csv", 'VariableNamingRule','preserve');
fprintf('Aylık veri seti yüklendi. Veri boyutu: %d satır.\n', height(data));

numData = data(:,2:end); 

for i = 1:width(numData)
    if iscell(numData.(i)) || isstring(numData.(i))
        numData.(i) = str2double(strrep(string(numData.(i)), ',', '.'));
    end
end

numData = rmmissing(numData);

y = numData.Altin;
X = removevars(numData, {'Altin'});
originalPredictorNames = X.Properties.VariableNames;


% Parametreler
lag_period = 1; % 1 AYLIK gecikme
ma_window = 3;  % 3 AYLIK hareketli ortalama

% Gecikmeli (Lagged) Değerler
for i = 1:length(originalPredictorNames)
    predictorName = originalPredictorNames{i};
    newColName = sprintf('%s_lag%d', predictorName, lag_period);
    tempCol = [NaN(lag_period, 1); X.(predictorName)(1:end-lag_period)];
    X.(newColName) = tempCol;
end

% Hareketli Ortalama (Moving Average) Değerleri
for i = 1:length(originalPredictorNames)
    predictorName = originalPredictorNames{i};
    newColName = sprintf('%s_ma%d', predictorName, ma_window);
    X.(newColName) = movmean(X.(predictorName), [ma_window-1 0]);
end

fprintf('Yeni özellikler eklendi. Toplam özellik sayısı: %d\n', width(X));


combined_data = [table(y) X];
cleaned_data = rmmissing(combined_data);
y = cleaned_data.y;
X = removevars(cleaned_data, {'y'});


cv = cvpartition(length(y),'HoldOut',0.2);
Xtrain = X(training(cv),:);
ytrain = y(training(cv),:);
Xtest  = X(test(cv),:);
ytest  = y(test(cv),:);


fprintf('Random Forest modeli için hiperparametre optimizasyonu başlıyor...\n');
fprintf('Bu işlem birkaç dakika sürebilir.\n');

optimizedRF = fitrensemble(Xtrain, ytrain, ...
                           'Method','Bag', ...
                           'Learners','tree',...
                           'OptimizeHyperparameters','auto', ...
                           'HyperparameterOptimizationOptions',...
                           struct('AcquisitionFunctionName','expected-improvement-plus', 'ShowPlots', false, 'Verbose', 1));


yPredRF = predict(optimizedRF, Xtest);
MSE_RF = mean((ytest - yPredRF).^2);
RMSE_RF = sqrt(MSE_RF);
R2_RF = corr(ytest, yPredRF)^2;
fprintf('\n--- Optimizasyon Sonrası Sonuçlar ---\n');
fprintf('Optimized Random Forest: R2=%.4f, RMSE=%.4f\n', R2_RF, RMSE_RF);

figure;
scatter(ytest, yPredRF, 'filled');
xlabel('Gerçek Aylık Altın Fiyatı'); ylabel('Tahmin (Optimize RF)');
title(sprintf('Optimize Edilmiş Aylık Tahminler (R^2=%.3f)', R2_RF));
grid on; refline(1,0);


fprintf('Final model tüm veri seti kullanılarak eğitiliyor...\n');

bestParams = optimizedRF.HyperparameterOptimizationResults.XAtMinObjective;
fprintf('En iyi parametreler bulundu: NumLearningCycles=%d, MinLeafSize=%d\n', ...
        bestParams.NumLearningCycles, bestParams.MinLeafSize);

treeLearner = templateTree('MinLeafSize', bestParams.MinLeafSize);

finalRFModel = fitrensemble(X, y, ...
                            'Method','Bag', ...
                            'Learners', treeLearner, ...
                            'NumLearningCycles', bestParams.NumLearningCycles);

fprintf('Model eğitildi. Diske kaydediliyor...\n');

saveLearnerForCoder(finalRFModel, 'Final_Gold_RF_Model_Monthly.mat');

fprintf('Model "Final_Gold_RF_Model_Monthly.mat" adıyla başarıyla kaydedildi.\n');