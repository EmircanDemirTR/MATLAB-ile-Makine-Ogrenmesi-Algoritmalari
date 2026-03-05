clc; clear; close all; rng(42);

load carsmall 
valid_idx = ~isnan(MPG) & ~isnan(Weight) & ~isnan(Horsepower) & ~isnan(Acceleration);
X = [Weight(valid_idx), Horsepower(valid_idx), Acceleration(valid_idx)];
Y = MPG(valid_idx);  % Hedef: Mil/galon yakıt tüketimi

fprintf('Veri seti: %d araba, %d özellik\n', size(X,1), size(X,2));
fprintf('MPG aralığı: %.1f - %.1f mil/galon\n', min(Y), max(Y));

feature_names = {'Ağırlık (lbs)','Beygir Gücü (HP)','İvme (0-60mph)'};

cv = cvpartition(length(Y),'HoldOut',0.25);
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));
Xtest = X(test(cv),:);
Ytest = Y(test(cv));

rf_model = TreeBagger(80, Xtrain, Ytrain, ...
    'Method','regression', ...
    'OOBPrediction','on', ...
    'OOBPredictorImportance','on', ...
    'MinLeafSize', 5);

Yhat_train = predict(rf_model, Xtrain);
Yhat_test = predict(rf_model, Xtest);

r2_train = 1 - sum((Ytrain - Yhat_train).^2) / sum((Ytrain - mean(Ytrain)).^2);
r2_test = 1 - sum((Ytest - Yhat_test).^2) / sum((Ytest - mean(Ytest)).^2);

rmse_train = sqrt(mean((Ytrain - Yhat_train).^2));
rmse_test = sqrt(mean((Ytest - Yhat_test).^2));

fprintf('R² Eğitim: %.3f | R² Test: %.3f\n', r2_train, r2_test);
fprintf('RMSE Eğitim: %.2f | RMSE Test: %.2f (MPG)\n', rmse_train, rmse_test);

figure('Position', [100,100,1200,400]);

subplot(1,4,1);
scatter(Ytest, Yhat_test, 50, 'b', 'filled');
hold on; plot([min(Y) max(Y)], [min(Y) max(Y)], 'r--', 'LineWidth', 2);
xlabel('Gerçek MPG'); ylabel('Tahmin Edilen MPG');
title(sprintf('Test Seti\nR² = %.3f', r2_test)); grid on; axis equal;

subplot(1,4,2);
errors = Ytest - Yhat_test;
histogram(errors, 15, 'FaceColor', [0.7 0.7 0.9], 'EdgeColor', 'k');
xlabel('Tahmin Hatası (MPG)'); ylabel('Frekans');
title(sprintf('Hata Dağılımı\nRMSE = %.2f', rmse_test)); grid on;

subplot(1,4,3);
importance = rf_model.OOBPermutedPredictorDeltaError;
bar(importance, 'FaceColor', [0.2 0.6 0.8]);
set(gca, 'XTickLabel', feature_names);
title('Özellik Önemliliği'); ylabel('Önem Skoru'); xtickangle(45);

subplot(1,4,4);
oob_error = oobError(rf_model);
plot(1:length(oob_error), oob_error, 'g-', 'LineWidth', 2);
xlabel('Ağaç Sayısı'); ylabel('OOB MSE');
title('Model Yakınsama'); grid on;

yeni_araba = [3000, 150, 12];  % 3000 lbs, 150 HP, 12 sn ivme
tahmin_mpg = predict(rf_model, yeni_araba);
fprintf('Yeni araba tahmini: %.1f MPG\n', tahmin_mpg);

sgtitle(sprintf('Random Forest Araba Yakıt Tüketimi Tahmini — Test R² = %.3f', r2_test));