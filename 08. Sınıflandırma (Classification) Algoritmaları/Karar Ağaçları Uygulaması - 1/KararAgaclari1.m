load fisheriris;

X = meas;
Y = species;

oznitelik_isimleri = {'CanakYaprakUzunlugu', 'CanakYaprakGenisligi', 'TacYaprakUzunlugu', 'TacYaprakGenisligi'};
X_tablo = array2table(X, "VariableNames",oznitelik_isimleri);

cv = cvpartition(Y, 'HoldOut', 0.3);
XEgitim = X_tablo(cv.training, :);
YEgitim = Y(cv.training, :);

XTest = X_tablo(cv.test, :);
YTest = Y(cv.test, :);

fprintf("%d adet çiçek eğitim, %d adet çiçek test için ayrıldı.\n", height(XEgitim), height(XTest));


tree_model = fitctree(XEgitim, YEgitim);


tahminler = predict(tree_model, XTest);
figure('Name','Model Performansı');
confusionchart(YTest, tahminler);


figure('Name','Karar Ağacı Yapısı');
view(tree_model, 'Mode','graph');


yein_cicek_olcumleri = {5.8, 2.8, 4.9, 1.5};
yeni_cicek = cell2table(yein_cicek_olcumleri, 'VariableNames',oznitelik_isimleri);

tahmin = predict(tree_model, yeni_cicek);
fprintf('Yeni çiçeğin tahmin edilen türü: %s\n', tahmin{1});