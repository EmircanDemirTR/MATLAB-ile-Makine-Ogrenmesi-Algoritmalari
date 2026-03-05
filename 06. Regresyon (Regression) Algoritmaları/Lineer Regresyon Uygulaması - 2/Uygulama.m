load("auto-mpg.mat");
mdl_weight = fitlm(autoMPG, 'mpg ~ weight');

disp(mdl_weight);
figure();
plot(mdl_weight);
xlabel("Agirlik");
ylabel("Yakit tuketimi");