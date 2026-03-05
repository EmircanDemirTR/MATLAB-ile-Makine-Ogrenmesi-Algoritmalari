load ionosphere;
Y_kategorik = categorical(Y);


cv = cvpartition(Y_kategorik, 'HoldOut', 0.3);
XEgitim = X(cv.training, :);
YEgitim = Y_kategorik(cv.training, :);
XTest = X(cv.test, :);
YTest = Y_kategorik(cv.test, :);


complex_tree = fitctree(XEgitim, YEgitim);

tahminler1 = predict(complex_tree, XTest);
dogruluk1 = mean(tahminler1 == YTest);
fprintf("Testin Doğruluğu: %.4f\n", dogruluk1);


yaprak_sayisi1 = sum(complex_tree.IsBranchNode == 0);
fprintf("Ağaçtaki Yaprak Sayısı: %d\n", yaprak_sayisi1);

% Budanmış Ağaç
simple_tree = fitctree(XEgitim, YEgitim, 'MinLeafSize',15);
tahminler2 = predict(simple_tree, XTest);
dogruluk2 = mean(tahminler2 == YTest);
fprintf("Budanmış Ağacın Test Doğruluğu: %.4f\n", dogruluk2);


yaprak_sayisi2 = sum(simple_tree.IsBranchNode == 0);
fprintf("Ağaçtaki Yaprak Sayısı: %d\n", yaprak_sayisi2);

% Ağaçları Görsel Olarak Karşılaştırma
figure('Name','Ağaç Yapılarının Karşılaştırılması');
subplot(1,2,1);
view(complex_tree, "Mode",'graph');
subplot(1,2,2);
view(simple_tree, "Mode",'graph');