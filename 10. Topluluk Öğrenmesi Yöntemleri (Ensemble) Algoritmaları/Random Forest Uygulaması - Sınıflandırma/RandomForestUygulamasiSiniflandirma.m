clc; clear; close all; rng(42);

load fisheriris
X = meas; 
Y = species;

fprintf('Veri seti: %d örnek, %d özellik, %d sınıf\n', ...
        size(X,1), size(X,2), length(unique(Y)));

cvp = cvpartition(Y,'HoldOut',0.3, 'Stratify', true);
Xtrain = X(training(cvp),:);
Ytrain = Y(training(cvp),:);
Xtest  = X(test(cvp),:);
Ytest  = Y(test(cvp),:);

% Random Forest modeli (100 ağaç)
rf_model = TreeBagger(100, Xtrain, Ytrain, ...
    'Method','classification', ...
    'OOBPrediction','on', ...
    'OOBPredictorImportance','on', ...
    'MinLeafSize', 1);

Yhat = predict(rf_model, Xtest);
Yhat_cat = categorical(Yhat, categories(categorical(Ytest)));
Ytest_cat = categorical(Ytest);
acc = mean(Yhat_cat == Ytest_cat);
fprintf('Test doğruluk: %.3f\n', acc);

figure('Position', [100,100,1200,400]);

% Veri dağılımı (sepal özellikleri)
subplot(1,4,1);
gscatter(Xtrain(:,1), Xtrain(:,2), Ytrain, 'rgb', 'osd', 8);
xlabel('Sepal Uzunluk (cm)'); ylabel('Sepal Genişlik (cm)'); 
title('Sepal Özellikleri'); legend('Location','best'); grid on;

% Veri dağılımı (petal özellikleri)
subplot(1,4,2);
gscatter(Xtrain(:,3), Xtrain(:,4), Ytrain, 'rgb', 'osd', 8);
xlabel('Petal Uzunluk (cm)'); ylabel('Petal Genişlik (cm)'); 
title('Petal Özellikleri'); legend('Location','best'); grid on;

subplot(1,4,3);
confusionchart(Ytest_cat, Yhat_cat);
title(sprintf('Test Sonuçları\nDoğruluk: %.3f', acc));

subplot(1,4,4);
importance = rf_model.OOBPermutedPredictorDeltaError;
feature_names = {'Sepal Uzun.','Sepal Gen.','Petal Uzun.','Petal Gen.'};
bar(importance, 'FaceColor', [0.2 0.6 0.8]);
set(gca, 'XTickLabel', feature_names);
title('Özellik Önemliliği'); ylabel('Önem Skoru'); xtickangle(45);

yeni_iris = [5.8, 3.0, 4.3, 1.3];  % örnek ölçümler
tahmin = predict(rf_model, yeni_iris);
fprintf('Yeni iris [%.1f, %.1f, %.1f, %.1f cm] → %s\n', ...
        yeni_iris, tahmin{1});

sgtitle(sprintf('Random Forest İris Sınıflandırması — Test Doğruluk: %.3f', acc));



