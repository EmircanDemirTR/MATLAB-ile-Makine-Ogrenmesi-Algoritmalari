W = 3500; % Ağırlık 3500 lbs
H = 150; % Beygir gücü 150
C = 6; % Silindir sayısı 6
MY = 78; % Model yılı 1978

yeni_arac = table(W, H, C, categorical(MY),...
    'VariableNames',{'weight', 'horsepower', 'cylinders', 'modelYear'});

disp("Yeni aracımın özellikleri:");
disp(yeni_arac);

predictedMPG = predict(mdl_multi, yeni_arac);

fprintf('Tahmin edilen MPG: %.2f\n', predictedMPG);