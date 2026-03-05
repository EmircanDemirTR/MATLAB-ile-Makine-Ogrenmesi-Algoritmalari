load carsmall;

data = table(MPG, Cylinders, Displacement, Horsepower, Weight, Acceleration, Model_Year, Origin,...
    'VariableNames',{'MPG', 'Cylinders', 'Displacement', 'Horsepower', 'Weight', 'Acceleration', 'Model_Year', 'Origin'});

disp(head(data,5));


missingCount = sum(ismissing(data));

missingTable = table(data.Properties.VariableNames', missingCount', 'VariableNames', {...
    'Değişken', 'Eksik_Sayısı'});

disp(missingTable);


data_listwise = rmmissing(data);
fprintf("Listwise deletion sonrası: %d satır\n", height(data_listwise));

data_pairwise = data(~ismissing(data.Horsepower), :);
fprintf("Pairwise deletion sonrası: %d satır", height(data_pairwise));