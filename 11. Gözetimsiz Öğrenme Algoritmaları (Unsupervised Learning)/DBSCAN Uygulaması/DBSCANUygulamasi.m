data = readtable('Mall_Customers.csv', 'VariableNamingRule', 'preserve');
genre_numeric = double(strcmp(data.Genre, 'Male'));

age = data.Age;
income = data.("Annual Income (k$)");
spending = data.("Spending Score (1-100)");

age_squared = age.^2;                           % Yaş karesi
income_spending_ratio = income ./ spending;     % Gelir/Harcama oranı
spending_efficiency = spending ./ income;       % Harcama verimliliği
age_income_interaction = age .* income;         % Yaş-Gelir etkileşimi
wealth_score = income + spending;               % Zenginlik skoru
purchase_power = income .* spending / 100;      % Satın alma gücü

X = [genre_numeric, age, income, spending, age_squared, ...
     income_spending_ratio, spending_efficiency, age_income_interaction, ...
     wealth_score, purchase_power];

X(~isfinite(X)) = 0;

X_norm = normalize(X, 'range');

epsilon = 0.25;
minpts = 8;
labels = dbscan(X_norm, epsilon, minpts);

kume_sayisi = numel(unique(labels(labels~=-1)));
gurultu_sayisi = sum(labels == -1);

fprintf('Kullanılan özellik sayısı: 10\n');
fprintf('Küme sayısı: %d\n', kume_sayisi);
fprintf('Gürültü noktası: %d\n', gurultu_sayisi);
fprintf('Kümelenmiş nokta: %d\n', sum(labels ~= -1));

if kume_sayisi > 1
    valid_idx = labels ~= -1;
    sil_score = mean(silhouette(X_norm(valid_idx,:), labels(valid_idx)));
    fprintf('Silhouette Skoru (Doğruluk): %.3f\n', sil_score);
else
    fprintf('Tek küme - Silhouette hesaplanamadı\n');
end

figure('Position', [100, 100, 1000, 800]);
subplot(2,2,1);
gscatter(X_norm(:,3), X_norm(:,4), labels);
xlabel('Gelir (Norm)'); ylabel('Harcama (Norm)');
title('Gelir vs Harcama'); grid on;

subplot(2,2,2);
gscatter(X_norm(:,2), X_norm(:,4), labels);
xlabel('Yaş (Norm)'); ylabel('Harcama (Norm)');
title('Yaş vs Harcama'); grid on;

subplot(2,2,3);
gscatter(X_norm(:,9), X_norm(:,10), labels);
xlabel('Zenginlik Skoru (Norm)'); ylabel('Satın Alma Gücü (Norm)');
title('Zenginlik vs Satın Alma Gücü'); grid on;

subplot(2,2,4);
gscatter(X_norm(:,6), X_norm(:,7), labels);
xlabel('Gelir/Harcama Oranı (Norm)'); ylabel('Harcama Verimliliği (Norm)');
title('Finansal Oranlar'); grid on;

sgtitle(sprintf('DBSCAN - 10 Özellik, %d Küme, Doğruluk: %.3f', kume_sayisi, sil_score));


fprintf('\n=== KÜME ANALİZİ ===\n');
clusters = unique(labels(labels~=-1));
for c = clusters'
    cluster_mask = labels == c;
    fprintf('Küme %d (%d kişi): Yaş %.1f, Gelir %.1f, Harcama %.1f\n', ...
        c, sum(cluster_mask), ...
        mean(age(cluster_mask)), mean(income(cluster_mask)), mean(spending(cluster_mask)));
end