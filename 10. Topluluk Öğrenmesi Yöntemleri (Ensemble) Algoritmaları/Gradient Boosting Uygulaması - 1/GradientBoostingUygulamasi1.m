clc; clear; close all; rng(42);

load ionosphere  % MATLAB'ın radar sinyali veri seti
X = X;  % 34 radar özelliği (frekans bantları)
Y = categorical(Y);  % İyi/Kötü radar sinyali

fprintf('Veri seti: %d radar sinyali, %d özellik\n', size(X,1), size(X,2));
fprintf('Sınıflar: %s\n', strjoin(categories(Y), ', '));

feature_names = {'Frekans-1','Frekans-2','Frekans-3','Frekans-4'};
X_selected = X(:,1:4);  % İlk 4 özellik

cvp = cvpartition(Y,'HoldOut',0.3, 'Stratify', true);
Xtrain = X(training(cvp),:);  % Tüm özellikler eğitim için
Ytrain = Y(training(cvp),:);
Xtest = X(test(cvp),:);
Ytest = Y(test(cvp),:);

Xtrain_vis = X_selected(training(cvp),:);  % Görselleştirme için
Xtest_vis = X_selected(test(cvp),:);

% 3) Gradient Boosting modeli (AdaBoost)
gb_model = fitcensemble(Xtrain, Ytrain, ...
    'Method','AdaBoostM1', ...
    'NumLearningCycles',100, ...
    'Learners','tree', ...
    'LearnRate',0.1);

Yhat_train = predict(gb_model, Xtrain);
Yhat_test = predict(gb_model, Xtest);

train_accuracy = sum(Yhat_train == Ytrain) / length(Ytrain);
test_accuracy = sum(Yhat_test == Ytest) / length(Ytest);

fprintf('Eğitim Doğruluğu: %.3f | Test Doğruluğu: %.3f\n', train_accuracy, test_accuracy);

figure('Position', [100,100,1200,400]);

% Veri dağılımı (ilk 2 frekans bandı)
subplot(1,4,1);
gscatter(Xtrain_vis(:,1), Xtrain_vis(:,2), Ytrain, 'rb', 'ox', 8);
xlabel('Frekans Bandı 1'); ylabel('Frekans Bandı 2');
title('Radar Sinyali Özellikleri'); legend('Location','best'); grid on;

% Karmaşıklık matrisi
subplot(1,4,2);
confusionchart(Ytest, Yhat_test);
title(sprintf('Test Sonuçları\nDoğruluk: %.3f', test_accuracy));

% Özellik önemliliği (ilk 8 özellik)
subplot(1,4,3);
importance = predictorImportance(gb_model);
bar(importance(1:8), 'FaceColor', [0.8 0.4 0.2]);
feature_labels = arrayfun(@(x) sprintf('F-%d', x), 1:8, 'UniformOutput', false);
set(gca, 'XTickLabel', feature_labels);
title('En Önemli 8 Özellik'); ylabel('Önem Skoru'); xtickangle(45);

% Öğrenme eğrisi
subplot(1,4,4);
train_loss = resubLoss(gb_model, 'Mode', 'Cumulative');
plot(1:length(train_loss), train_loss, 'r-', 'LineWidth', 2);
xlabel('Boosting İterasyonu'); ylabel('Eğitim Hatası');
title('Model Öğrenme Eğrisi'); grid on;

% 6) Tahmin
yeni_sinyal = X(1,:);  % İlk sinyali örnek olarak al
yeni_sinyal(1:4) = [0.5, -0.2, 0.8, -0.3];  % Bazı değerleri değiştir
[tahmin, skor] = predict(gb_model, yeni_sinyal);
fprintf('Yeni radar sinyali → %s (%.2f güven)\n', string(tahmin), max(skor));

sgtitle(sprintf('Gradient Boosting Radar Sinyali Sınıflandırması — Test Doğruluk: %.3f', test_accuracy));