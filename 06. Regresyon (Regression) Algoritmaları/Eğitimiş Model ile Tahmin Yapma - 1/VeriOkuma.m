powerPlant = readtable('Folds5x2_pp.xlsx');
powerPlant.Properties.VariableNames = ...
    {'Temperature','ExhaustVacuum','AmbientPressure','RelativeHumidity','EnergyOutput'};

save("powerPlant.mat", "powerPlant");
disp("Veri başarıyla oluşturuldu.");

head(powerPlant);