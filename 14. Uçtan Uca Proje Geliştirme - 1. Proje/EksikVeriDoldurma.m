data = readtable("Finansal_Veriseti.csv", 'VariableNamingRule','preserve');

data.Properties.VariableNames

data.("Korku_Endeksi_VIX") = str2double(strrep(string(data.("Korku_Endeksi_VIX")), ',', '.'));

data.("Korku_Endeksi_VIX") = fillmissing(data.("Korku_Endeksi_VIX"), 'linear');

% önceki gözlemin değerini alıyoruz (forward fill).
data.("Korku_Endeksi_VIX") = fillmissing(data.("Korku_Endeksi_VIX"), 'previous');

writetable(data,"Finansal_Veriseti_Doldurulmus.csv");