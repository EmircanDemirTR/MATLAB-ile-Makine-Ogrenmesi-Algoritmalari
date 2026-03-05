filename = 'auto-mpg.csv';
data = readtable(filename, 'TreatAsMissing','?');

autoMPG = rmmissing(data);

autoMPG.carName = [];
save("auto-mpg.mat", "autoMPG");

head(autoMPG);