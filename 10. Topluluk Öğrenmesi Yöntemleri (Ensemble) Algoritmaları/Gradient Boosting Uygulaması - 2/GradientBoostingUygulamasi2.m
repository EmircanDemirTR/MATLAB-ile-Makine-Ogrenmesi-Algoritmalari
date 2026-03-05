rng(42);
data = readtable('student-mat.csv', 'Delimiter', ';');

% "yes/no" sütunlarını 1/0'a dönüştürelim
vars = data.Properties.VariableNames;
for i = 1:length(vars)
    if iscellstr(data.(vars{i})) || isstring(data.(vars{i}))
        unique_vals = unique(data.(vars{i}));
        % Eğer sadece "yes" ve "no" içeriyorsa dönüştür
        if all(ismember(unique_vals, ["yes","no"]))
            data.(vars{i}) = double(strcmp(data.(vars{i}), "yes"));
        end
    end
end

% Sayısal olan sütunları seçme
numeric_cols = varfun(@isnumeric, data, 'OutputFormat', 'uniform');
data_numeric = data(:, numeric_cols);

X = table2array(data_numeric(:, 1:end-1));  % Son sütun hariç
Y = table2array(data_numeric(:, end));      % G3 (final notu)

fprintf('Veri: %d öğrenci, %d özellik\n', size(X,1), size(X,2));

cv = cvpartition(length(Y),'HoldOut',0.25);
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv));
Xtest = X(test(cv),:);
Ytest = Y(test(cv));

% Gradient Boosting modeli
fprintf('Gradient Boosting modeli eğitiliyor...\n');
gb_model = fitrensemble(Xtrain, Ytrain, ...
    'Method','LSBoost', ...
    'NumLearningCycles',100, ...
    'LearnRate',0.1);

Yhat = predict(gb_model, Xtest);
r2 = 1 - sum((Ytest - Yhat).^2) / sum((Ytest - mean(Ytest)).^2);
rmse = sqrt(mean((Ytest - Yhat).^2));
fprintf('Test R²: %.3f | RMSE: %.2f puan\n', r2, rmse);

figure('Position', [100,100,800,300]); % biraz daha dar olabilir

subplot(1,2,1);
scatter(Ytest, Yhat, 'filled', 'MarkerFaceColor', [0.2 0.6 0.8]);
hold on; plot([0 20], [0 20], 'r--', 'LineWidth', 2);
xlabel('Gerçek Final Notu'); ylabel('Tahmin Final Notu');
title(sprintf('Test Sonuçları\nR² = %.3f', r2)); 
grid on; axis equal; xlim([0 20]); ylim([0 20]);

subplot(1,2,2);
loss = resubLoss(gb_model, 'Mode', 'Cumulative');
plot(loss, 'g-', 'LineWidth', 2);
xlabel('Boosting İterasyonu'); ylabel('Eğitim Hatası');
title('Model Öğrenme Eğrisi'); grid on;