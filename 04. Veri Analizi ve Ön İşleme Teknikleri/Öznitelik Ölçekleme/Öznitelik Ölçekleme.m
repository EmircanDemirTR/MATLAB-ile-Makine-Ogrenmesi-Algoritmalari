data = readtable('train.csv');
disp(head(data,5));

numericVars = {'Age', 'Fare'};

% Min-Max Normalizasyonu (0-1)
for i=1:length(numericVars)
    col = data.(numericVars{i});
    colMin = min(col,[],'omitnan');
    colMax = max(col,[],'omitnan');
    data.([numericVars{i} '_MinMax']) = (col - colMin) ./ (colMax - colMin);

    fprintf('%s -> [%.2f, %.2f] aralığından [0, 1] aralığında ölçeklendi..\n', numericVars{i}, colMin, colMax);
end

%  Z-Score Standardizasyonu
for i=1:length(numericVars)
    col = data.(numericVars{i});
    mu = mean(col, 'omitnan');
    sigma = std(col, 'omitnan');
    data.([numericVars{i} '_Zscore']) = (col - mu) ./sigma;

    fprintf('%s -> Ortalama: %.2f, Std: %.2f\n', numericVars{i}, mu, sigma);
end