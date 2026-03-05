data = readtable('train.csv');
disp(head(data,5));

data.Sex = categorical(data.Sex);
data.Embarked = categorical(data.Embarked);
data.Pclass = categorical(data.Pclass);

% Binary Encoding (0-1)

cats = categories(data.Sex);
data.Sex_Binary = double(data.Sex == cats{2}); % 0-1
disp(table(data.Sex(1:10), data.Sex_Binary(1:10)));

% Label Encoding
[data.Embarked_Label, categoryNames] = grp2idx(data.Embarked);

encodingTable = table((1:numel(categoryNames))', categoryNames,...
    'VariableNames',{'Label', 'Category'});
disp(encodingTable);