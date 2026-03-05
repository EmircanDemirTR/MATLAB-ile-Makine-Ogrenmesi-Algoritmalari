load("auto-mpg.mat");

autoMPG.modelYear = categorical(autoMPG.modelYear);

mdl_multi = fitlm(autoMPG, 'mpg ~ weight + horsepower + cylinders + modelYear');

disp(mdl_multi);