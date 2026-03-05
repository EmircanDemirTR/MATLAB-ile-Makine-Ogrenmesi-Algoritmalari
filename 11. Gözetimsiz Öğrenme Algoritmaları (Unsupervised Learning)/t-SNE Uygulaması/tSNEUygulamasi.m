load wine_dataset;
X = wineInputs';     % Özellik matrisi (178x13) - TÜM ÖZELLİKLER
Y = wineTargets';    % Sınıf etiketleri (178x3)
[~, labels] = max(Y, [], 2);  % One-hot'tan normal etikete çevir


class_names = {'Sınıf 1', 'Sınıf 2', 'Sınıf 3'};
Y_categorical = categorical(labels, [1,2,3], class_names);


X_normalized = zscore(X);  % Z-score normalizasyonu (tüm özellikler)


fprintf('t-SNE hesaplanıyor...\n');
rng(42);  % Tekrarlanabilirlik için
Y_tsne = tsne(X_normalized, ...
    'Algorithm', 'barneshut', ...
    'NumDimensions', 2, ...
    'Perplexity', 30, ...
    'Standardize', false);

fprintf('t-SNE hesaplama tamamlandı.\n');


mdl = fitcknn(Y_tsne, Y_categorical, 'NumNeighbors', 3);
predictions = predict(mdl, Y_tsne);
accuracy = sum(predictions == Y_categorical) / length(Y_categorical) * 100;

fprintf('t-SNE üzerinde k-NN doğruluğu: %.1f%%\n', accuracy);


figure('Position', [100, 100, 1200, 500]);


subplot(1,2,1);
gscatter(Y_tsne(:,1), Y_tsne(:,2), Y_categorical, 'rgb', 'osd', 10);
title(sprintf('Wine Dataset t-SNE Sonucu\n(13 özellik → 2 boyut)'));
xlabel('t-SNE Boyut 1');
ylabel('t-SNE Boyut 2');
legend('Location', 'best');
grid on;


subplot(1,2,2);
gscatter(X_normalized(:,1), X_normalized(:,2), Y_categorical, 'rgb', 'osd', 10);
title('Orijinal Veri (İlk 2 Boyut)');
xlabel('Özellik 1 (Normalize)');
ylabel('Özellik 2 (Normalize)');
legend('Location', 'best');
grid on;


fprintf('\n=== t-SNE ANALİZ RAPORU ===\n');
fprintf('Kullanılan özellik sayısı: %d\n', size(X,2));
fprintf('Örnek sayısı: %d\n', size(X,1));
fprintf('Sınıf sayısı: %d\n', length(unique(labels)));
fprintf('t-SNE görselleştirme doğruluğu: %.1f%%\n', accuracy);