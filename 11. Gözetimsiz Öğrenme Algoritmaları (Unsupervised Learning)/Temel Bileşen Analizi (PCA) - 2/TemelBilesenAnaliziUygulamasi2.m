clc; clear; close all; rng(1);

load fisheriris
X = meas;       
labels = species;  

X_norm = normalize(X);


[idx_raw, C_raw] = kmeans(X_norm, 3, 'Replicates',10);

figure;
gscatter(X_norm(:,1), X_norm(:,2), idx_raw);
hold on; plot(C_raw(:,1), C_raw(:,2), 'kx','LineWidth',2);
title('K-Means Kümeleme (PCA Yok)');
xlabel('Özellik 1 (Sepal Uzunluğu)');
ylabel('Özellik 2 (Sepal Genişliği)');


[coeff, score, ~, ~, explained] = pca(X_norm);
X_pca = score(:,1:2);

fprintf('İlk 2 PCA bileşeni toplam varyansın %.2f%% ini açıklıyor.\n', sum(explained(1:2)));


[idx_pca, C_pca] = kmeans(X_pca, 3, 'Replicates',10);

figure;
gscatter(X_pca(:,1), X_pca(:,2), idx_pca);
hold on; plot(C_pca(:,1), C_pca(:,2), 'kx','LineWidth',2);
title('K-Means Kümeleme (PCA Sonrası)');
xlabel('1. Temel Bileşen');
ylabel('2. Temel Bileşen');
