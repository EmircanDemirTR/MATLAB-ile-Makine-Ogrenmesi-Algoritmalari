data = readtable('train.csv');
disp(head(data,5));

data.MSZoning = categorical(data.MSZoning);

cats = categories(data.MSZoning);
numCats = numel(cats);

for i = 1 : numCats
    colName = ['MSZoning ' char(cats{i})];
    data.(colName) = double(data.MSZoning == cats{i});
end

disp(data(1:10, end-numCats+1:end));