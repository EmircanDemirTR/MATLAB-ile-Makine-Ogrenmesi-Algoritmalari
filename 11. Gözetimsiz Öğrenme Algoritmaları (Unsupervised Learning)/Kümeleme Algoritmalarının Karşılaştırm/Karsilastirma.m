clc; clear; close all;

data = readtable('Wholesale customers data.csv');  % Dosya adı doğru olmalı
X = normalize([data.Fresh, data.Milk, data.Grocery, data.Frozen]);

% K-Means
[idx_kmeans, ~] = kmeans(X, 3, 'Replicates', 5);
sil_kmeans = mean(silhouette(X, idx_kmeans));

% Hiyerarşik Kümeleme
Z = linkage(pdist(X), 'ward');
idx_hier = cluster(Z, 'maxclust', 3);
sil_hier = mean(silhouette(X, idx_hier));

% DBSCAN
idx_dbscan = dbscan(X, 0.7, 5);
valid = idx_dbscan > 0;
sil_dbscan = mean(silhouette(X(valid,:), idx_dbscan(valid))) * any(valid);

% Sonuç
fprintf('\nSilhouette Skorları:\n');
fprintf('K-Means:       %.2f\n', sil_kmeans);
fprintf('Hiyerarşik:    %.2f\n', sil_hier);
fprintf('DBSCAN:        %.2f\n', sil_dbscan);

% Grafikler
subplot(1,3,1); gscatter(X(:,1),X(:,2),idx_kmeans); title('K-Means');
subplot(1,3,2); gscatter(X(:,1),X(:,2),idx_hier); title('Hierarchical');
subplot(1,3,3); gscatter(X(:,1),X(:,2),idx_dbscan); title('DBSCAN');
