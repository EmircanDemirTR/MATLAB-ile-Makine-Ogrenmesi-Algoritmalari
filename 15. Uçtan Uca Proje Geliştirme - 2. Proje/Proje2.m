data = readtable("VeriSeti.xlsx");

%İl isimlerini ayrı yerde tutalım
il_isimleri = data.il;

% Kümeleme için sayısal verileri tutalım
numeric_data = data(:, 2:end);

X = table2array(numeric_data);

% Normalizasyon (Veri Ön İşleme)
X_normalized = zscore(X);

% Optimal Küme Sayısı Belirleme
disp("Optimal küme sayısı belirleniyor.");
eva = evalclusters(X_normalized, 'kmeans', 'silhouette', 'KList',[5:8]);
optimal_k = eva.OptimalK;
fprintf('Silhoutte analizine göre optimal küme sayısı: %d\n', optimal_k);

% Sonuç Görselleştirme
figure('Name','Küme Sayısı Değerlendirmesi', 'Position',[100,100,800,400]);
plot(eva);
title('Silhouette Değerlerine Göre Optimal Küme Sayısı');

% K-Means Kümeleme Algoritması
[idx, C] = kmeans(X_normalized, optimal_k, 'Replicates',5, 'MaxIter',200);

% Sonuçları Yorumlama ve Görselleştirme
% Küme Merkezlerini Analiz Etme
C_original_scale = zeros(size(C));
for i=1:size(X,2)
    C_original_scale(:,i) = C(:,i) * std(X(:,i)) + mean(X(:,i));
end

cluster_profiles = array2table(C_original_scale, 'VariableNames',numeric_data.Properties.VariableNames);
cluster_profiles.Cluster = (1:optimal_k)';
cluster_profiles = [cluster_profiles(:,end) cluster_profiles(:,1:end-1)];

disp('Her Kümenin Ortalama Profili (Orijinal Değerler)');
disp(cluster_profiles);

% PCA ile 2 Boyutta Görselleştirme
[coeff, score, latent] = pca(X_normalized);

figure('Name','İllerin Sosyoekonomik Kümelere Göre Dağılımı', 'Position',[100, 100, 1200, 800]);
gscatter(score(:,1), score(:,2), idx, [], 'o', 10);
hold on;
dx = 0.1; dy=0.1;
text(score(:,1)+dx, score(:,2)+dy, il_isimleri, 'FontSize',8);
hold off;


title('İllerin Sosyoekonomik Profil Kümelemesi (PCA ile 2D Görselleştirme)');
xlabel(sprintf('1. Temel Bileşen (Varyans: %.2f%%)', (latent(1)/sum(latent))*100));
ylabel(sprintf('2. Temel Bileşen (Varyans: %.2f%%)', (latent(2)/sum(latent))*100));
legend('Location','best');
grid on;


% Hangi İller Hangi Kümede Yer Alıyor?
for i=1:optimal_k
    fprintf('\n---Küme %d ---\n', i);
    iller_bu_kumede = il_isimleri(idx==i);
    disp(strjoin(iller_bu_kumede, ','));
end