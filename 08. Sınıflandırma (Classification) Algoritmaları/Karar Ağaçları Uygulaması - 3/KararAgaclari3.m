data_table = readtable("bodyfat.csv");

y = data_table.BodyFat;
x_tablo = data_table(:,{'Age', 'Weight', 'Height', 'Neck', 'Chest', 'Abdomen', 'Hip', 'Thigh', 'Knee',...
    'Ankle', 'Biceps', 'Forearm', 'Wrist'});

Y_kategorik = categorical(y > median(y), [false,true], {'Düşük', 'Yüksek'});

oznitelik_isimleri = x_tablo.Properties.VariableNames;

% Veriyi Eğitim ve Test Datası Olarak Ayırma
cv = cvpartition(Y_kategorik, 'HoldOut', 0.3);

XEgitim = x_tablo(cv.training,:);
YEgitim = Y_kategorik(cv.training,:);
XTest = x_tablo(cv.test,:);
YTest = Y_kategorik(cv.test,:);
fprintf("%d adet kişi eğitim, %d adet kişi test için ayrıldı.", height(XEgitim), height(XTest));

% Model Eğitme
tree_model = fitctree(XEgitim, YEgitim);
tahminler = predict(tree_model, XTest);

figure();
confusionchart(YTest, tahminler);

dogruluk = sum(tahminler == YTest) / numel(YTest);
fprintf("\nDoğruluk oranı: %.2f%%\n", dogruluk * 100);


onem_puanlari = predictorImportance(tree_model);
figure('Name', 'Öznitelik Önem Düzeyleri');
barh(onem_puanlari);
yticks(1:length(oznitelik_isimleri));
yticklabels(oznitelik_isimleri);
xlabel('Önem Puanı');
ylabel('Öznitelikler');
title('Vücut Yağ Oranı Tahmininde Öznitelik Önemi');
grid on;