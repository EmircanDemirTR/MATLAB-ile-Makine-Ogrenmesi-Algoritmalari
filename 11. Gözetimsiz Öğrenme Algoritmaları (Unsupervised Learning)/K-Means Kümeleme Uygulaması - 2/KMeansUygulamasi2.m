data = readtable('Wholesale customers data.csv');
X = data{:, 3:end};
X_normalized = zscore(X);
fprintf('Veri hazırlama tamamlandı.\n\n');


ortalama_siluet_skorlari = zeros(1, 14); 
k_degerleri = 2:15;

for i = 1:length(k_degerleri)
    k = k_degerleri(i);
    
    idx = kmeans(X_normalized, k, 'MaxIter', 1000, 'Replicates', 5);
    
    siluet_degerleri = silhouette(X_normalized, idx);
    ortalama_siluet_skorlari(i) = mean(siluet_degerleri);
    
    fprintf('   k = %d için Ortalama Siluet Skoru: %f\n', k, ortalama_siluet_skorlari(i));
end
close(gcf);


figure;
plot(k_degerleri, ortalama_siluet_skorlari, 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Küme Sayısı (k)');
ylabel('Ortalama Siluet Skoru');
title('Farklı K Değerleri İçin Siluet Skoru Optimizasyonu');
grid on;


[en_yuksek_skor, en_iyi_index] = max(ortalama_siluet_skorlari);
en_iyi_k = k_degerleri(en_iyi_index);

fprintf('\nAnaliz tamamlandı. En yüksek silüet skoruna sahip k değeri bulundu.\n');
fprintf('   -> En İyi k Değeri: %d\n', en_iyi_k);
fprintf('   -> En Yüksek Ortalama Siluet Skoru: %f\n\n', en_yuksek_skor);



fprintf('Adım 3: En iyi k = %d değeri ile final kümeleme yapılıyor...\n', en_iyi_k);

% En iyi k değeri ile K-Means'i tekrar çalıştırıyoruz
[idx, C] = kmeans(X_normalized, en_iyi_k, 'MaxIter', 1000, 'Replicates', 5);


C_original = C .* std(X) + mean(X);
fprintf('\nFinal Küme Merkezleri (Her Kategorideki Ortalama Harcama):\n');
feature_names = data.Properties.VariableNames(3:end);
disp(array2table(C_original, 'VariableNames', feature_names, 'RowNames', strcat('Küme ', string(1:en_iyi_k))));