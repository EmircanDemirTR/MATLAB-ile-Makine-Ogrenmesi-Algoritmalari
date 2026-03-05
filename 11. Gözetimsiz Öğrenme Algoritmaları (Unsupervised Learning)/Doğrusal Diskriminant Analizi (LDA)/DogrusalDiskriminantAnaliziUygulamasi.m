clc; clear; close all; rng(42);

filename = 'wine.csv';
opts = detectImportOptions(filename);
opts.VariableNamesLine = 0;
opts.VariableNames = ["Class", "Alcohol", "MalicAcid", "Ash", "Alcalinity", ...
    "Magnesium", "TotalPhenols", "Flavanoids", "NonflavanoidPhenols", ...
    "Proanthocyanins", "ColorIntensity", "Hue", "OD280_OD315", "Proline"];
data = readtable(filename, opts);

X = table2array(data(:, 2:end));
y = data.Class;

cv = cvpartition(y, 'HoldOut', 0.3);
X_train = X(training(cv), :);
y_train = y(training(cv));
X_test  = X(test(cv), :);
y_test  = y(test(cv));

ldaModel = fitcdiscr(X_train, y_train);

y_pred = predict(ldaModel, X_test);

accuracy = sum(y_pred == y_test) / length(y_test) * 100;
fprintf('Test Doğruluğu: %.2f%%\n', accuracy);

[W, ~] = lda2D(X_train, y_train);         % özel fonksiyon (aşağıda tanımlı)
X_lda2 = X_train * W;

figure;
gscatter(X_lda2(:,1), X_lda2(:,2), y_train, 'rgb', 'o^s');
xlabel('LDA 1'); ylabel('LDA 2');
title('LDA Görselleştirme (Eğitim Verisi)');
legend('Sınıf 1','Sınıf 2','Sınıf 3','Location','best');

function [W, classMeans] = lda2D(X, y)
    classes = unique(y);
    nClasses = length(classes);
    overallMean = mean(X);
    
    Sw = zeros(size(X,2));
    Sb = zeros(size(X,2));
    classMeans = zeros(nClasses, size(X,2));
    
    for i = 1:nClasses
        Xi = X(y==classes(i), :);
        classMean = mean(Xi);
        classMeans(i,:) = classMean;
        Sw = Sw + cov(Xi) * (size(Xi,1) - 1);
        Sb = Sb + (classMean - overallMean)' * (classMean - overallMean) * size(Xi,1);
    end
    
    [V, ~] = eigs(Sb, Sw, 2);  % En büyük 2 özvektör
    W = V;
end
