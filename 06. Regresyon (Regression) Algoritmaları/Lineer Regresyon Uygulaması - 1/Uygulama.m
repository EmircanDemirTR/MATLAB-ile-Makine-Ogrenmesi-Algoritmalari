load("powerPlant.mat");
mdl_temp = fitlm(powerPlant, 'EnergyOutput ~ Temperature');

disp(mdl_temp);
figure();

plot(mdl_temp);
title('Sıcaklığa Karşı Enerji Üretimi');
xlabel('Sıcaklık');
ylabel('Enerji Üretimi');