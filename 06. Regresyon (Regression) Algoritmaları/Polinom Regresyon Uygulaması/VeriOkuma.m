filename = 'HousingData.csv';
bostonData = readtable(filename);

save("bostonData.mat", "bostonData");
head(bostonData);

x = bostonData.LSTAT;
y = bostonData.MEDV;
scatter(x,y);