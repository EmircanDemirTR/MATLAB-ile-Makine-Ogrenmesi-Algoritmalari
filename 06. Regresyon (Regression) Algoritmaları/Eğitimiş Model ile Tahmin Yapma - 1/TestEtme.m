T = 25;   % Sıcaklık: 25 C
V = 60;   % Egzoz Vakumu: 60 cm Hg
AP = 1015;% Ortam Basıncı: 1015 mbar
RH = 80;  % Bağıl Nem: %80

yeni_kosullar = table(T, V, AP, RH,...
    'VariableNames', {'Temperature', 'ExhaustVacuum', 'AmbientPressure', 'RelativeHumidity'});

disp('Tahmin yapılacak yeni koşullar:');
disp(yeni_kosullar);

predictedEnergy = predict(mdl_full, yeni_kosullar);

fprintf('\nBelirtilen koşullar altında tahmin edilen enerji üretimi: %.2f MW\n', predictedEnergy);