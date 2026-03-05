data = readtable("heart.csv");

X = data(:, 1:end-1);
Y= data.target;

rng(1);
cv = cvpartition(Y, 'HoldOut', 0.2);
trainIdx = training(cv);
testIdx = test(cv);

X_train = X(trainIdx, :);
Y_train = Y(trainIdx);
X_test = X(testIdx, :);
Y_test = Y(testIdx, :);

fprintf("Eğitim verisi boyutu: %d\n", length(Y_train));
fprintf("Test verisi boyutu: %d\n", length(Y_test));

% Lojistik Regresyon Modeli Kuralım
% fitglm = Generalized Linear Model
model = fitglm(X_train, Y_train, 'Distribution','binomial'); % Sonucun 1 ya da 0 olduğu durumlarda

probabilites = predict(model, X_test);
Y_pred = double(probabilites > 0.5);

figure();
cm = confusionchart(Y_test, Y_pred);
cm.Title = "Kalp Hastalığı Tahmin Performansı";
cm.RowSummary = "row-normalized";
cm.ColumnSummary = 'column-normalized';

accuracy = sum(Y_pred == Y_test)/length(Y_test);
fprintf("Doğruluk Oranı: %.2f\n", accuracy*100);