load("powerPlant.mat");
mdl_full = fitlm(powerPlant, 'EnergyOutput ~ Temperature + ExhaustVacuum + AmbientPressure + RelativeHumidity');

disp(mdl_full);
fprintf("\nModelin R-Kare Değeri: %.4f\n", mdl_full.Rsquared.Ordinary);