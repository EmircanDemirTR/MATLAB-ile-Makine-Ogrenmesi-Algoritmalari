clc; clear; close all;
load carsmall;

data = table(MPG, Cylinders, Displacement, Horsepower, Weight, Acceleration, Model_Year, Origin,...
    'VariableNames',{'MPG', 'Cylinders', 'Displacement', 'Horsepower', 'Weight', 'Acceleration', 'Model_Year', 'Origin'});

disp(head(data,5));


missingCount = sum(ismissing(data));

missingTable = table(data.Properties.VariableNames', missingCount', 'VariableNames', {...
    'Değişken', 'Eksik_Sayısı'});

disp(missingTable);


% 2.1 Basit İstatistik Yöntemleri
% 2.1.1 Ortalama ile Doldurma
data_mean = data;
meanValue = mean(data.Horsepower, "omitnan");
data_mean.Horsepower(ismissing(data_mean.Horsepower)) = meanValue;
fprintf("Ortalama değer: %.2f\n", meanValue);

% 2.1.2 Medyan ile Doldurma
data_median = data;
medianValue = median(data.Horsepower, "omitnan");
data_median.Horsepower(ismissing(data_median.Horsepower)) = medianValue;
fprintf("Medyan değer: %.2f\n", medianValue);

% 2.1.3 Mod ile Doldurma
data_mode = data;
modeValue = mode(data.Horsepower(~ismissing(data.Horsepower)));
data_mode.Horsepower(ismissing(data_mode.Horsepower)) = modeValue;
fprintf("Mod değer: %.2f\n", modeValue);


% 2.1 İnterpolasyon Yöntemleri (Linear)

data_linear = data;
data_linear.Horsepower = fillmissing(data_linear.Horsepower, 'linear');