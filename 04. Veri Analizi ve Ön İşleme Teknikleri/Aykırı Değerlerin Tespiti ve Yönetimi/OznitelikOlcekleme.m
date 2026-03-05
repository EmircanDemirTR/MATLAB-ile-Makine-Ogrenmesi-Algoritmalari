filename = 'HousingData.csv';
data = readtable(filename);

disp(head(data,5));

vars = {'RM', 'MEDV'};

% Aykırı Değer Tespiti - Çeyrekler Arası Açıklık
for i=1:length(vars)
    col = data.(vars{i});
    Q1 = quantile(col, 0.25);
    Q3 = quantile(col, 0.75);
    IQR = Q3 - Q1;

    lowerBound = Q1 - 1.5 * IQR;
    upperBound = Q3 + 1.5 * IQR;

    outliers = (col < lowerBound) | (col > upperBound);
    fprintf("%s değişkeninde %d adet aykırı değer bulundu.\n", vars{i}, sum(outliers));

    data.([vars{i} '_Outlier']) = outliers;
end

% 1. Yöntem - Aykırı Değerleri Kaldırma
data_removed = data(~data.RM_Outlier & ~data.MEDV_Outlier, :);
fprintf("\nAykırı değerler çıkarıldı: %d satır kaldı.\n", height(data_removed));

% 2. Yöntem - Uç Değerleri Sınırlandırma
data_winsor = data;

for i=1:length(vars)
    col = data.(vars{i});
    Q1 = quantile(col, 0.25);
    Q3 = quantile(col, 0.75);
    IQR = Q3 - Q1;

    lowerBound = Q1 - 1.5 * IQR;
    upperBound = Q3 + 1.5 * IQR;

    col(col < lowerBound) = lowerBound;
    col(col > upperBound) = upperBound;
end
disp("Winsorization uygulandı!");