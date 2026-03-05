clc; clear; close all; rng(42);

filename = "Wholesale customers data.csv";  
data = readtable(filename);

X = table2array(data(:, 3:end));

X_norm = normalize(X);

[coeff, score, ~, ~, explained] = pca(X_norm);
X_pca = score(:, 1:2);  % İlk 2 bileşen
fprintf('PCA ile açıklanan varyans: %.2f%%\n', sum(explained(1:2)));

maxK = 5; sil = zeros(maxK,1);
for k = 2:maxK
    idx = kmeans(X_pca, k, 'Replicates', 10);
    sil(k) = mean(silhouette(X_pca, idx));
end
[bestSil, bestK] = max(sil);
fprintf('En iyi küme sayısı: %d | Silhouette skoru: %.4f\n', bestK, bestSil);


[idx, C] = kmeans(X_pca, bestK, 'Replicates',10);


figure;
gscatter(X_pca(:,1), X_pca(:,2), idx);
hold on; plot(C(:,1), C(:,2), 'kx','MarkerSize',12,'LineWidth',2);
title(sprintf('PCA + K-Means Kümeleme (k = %d)', bestK));
xlabel('PCA 1'); ylabel('PCA 2'); grid on;
