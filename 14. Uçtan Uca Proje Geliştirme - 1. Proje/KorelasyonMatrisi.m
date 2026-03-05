data = readtable("Finansal_Veriseti_Doldurulmus.csv", 'VariableNamingRule','preserve');
numData = data(:,2:end);

for i = 1:width(numData)
    col = numData.(i);   % sütunu geçici değişkene al
    
    if iscell(col) || isstring(col) || ischar(col)
        % Virgül varsa noktaya çevir, sonra double'a çevir
        col = str2double(strrep(string(col), ',', '.'));
    end
    
    numData.(i) = col
end

X = table2array(numData);

corrMatrix = corr(X, 'Rows','complete');

varNames = numData.Properties.VariableNames;

idxAltin = find(strcmp(varNames, 'Altin'));
corrWithAltin = corrMatrix(:, idxAltin);

% Korelasyon tablosu
T = table(varNames', corrWithAltin, 'VariableNames', {'Degisken','Altin_Korelasyonu'})

% Korelasyon Isı Haritası
figure;
heatmap(varNames, varNames, corrMatrix, 'Colormap', jet, 'ColorbarVisible','on');
title('Korelasyon Matrisi (Tüm Değişkenler)');

% Altın ile Korelasyon Bar Grafiği
figure;
bar(corrWithAltin);
set(gca,'XTickLabel',varNames,'XTickLabelRotation',45);
ylabel('Korelasyon Katsayısı');
title('Altın ile Değişkenlerin Korelasyonu');
grid on;
