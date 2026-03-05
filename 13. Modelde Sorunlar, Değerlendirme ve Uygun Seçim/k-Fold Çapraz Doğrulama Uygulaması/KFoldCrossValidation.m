clc; clear; close all;

data = readtable('heart.csv');  
X = data(:,1:end-1);
y = table2array(data(:,end));

cv_simple = cvpartition(y,'HoldOut',0.2);
XTrain = X(training(cv_simple),:);
yTrain = y(training(cv_simple));
XTest  = X(test(cv_simple),:);
yTest  = y(test(cv_simple));

modelTree = fitctree(XTrain,yTrain,'MinLeafSize',50,'MaxNumSplits',5);
predTree  = predict(modelTree,XTest);
accTree_simple = mean(predTree == yTest);

modelEns = fitcensemble(XTrain,yTrain,'Method','Bag','NumLearningCycles',10);
predEns  = predict(modelEns,XTest);
accEns_simple = mean(predEns == yTest);

fprintf('=== K-Fold YOK (Tek Train-Test Ayrımı) ===\n');
fprintf('Karar Ağacı Doğruluk: %.2f%%\n', accTree_simple*100);
fprintf('Ensemble Doğruluk: %.2f%%\n\n', accEns_simple*100);


%% 3. K-FOLD
k = 10;
cvp = cvpartition(y,'KFold',k);
accTree = zeros(k,1);
accEns  = zeros(k,1);

for i = 1:k
    % Karar Ağacı
    mTree = fitctree(X(training(cvp,i),:), y(training(cvp,i)), ...
                 'MinLeafSize',50,'MaxNumSplits',5);
    pTree = predict(mTree, X(test(cvp,i),:));
    accTree(i) = mean(pTree == y(test(cvp,i)));
    
    % Ensemble
    mEns = fitcensemble(X(training(cvp,i),:), y(training(cvp,i)), ...
        'Method','Bag','NumLearningCycles',10);
    pEns = predict(mEns, X(test(cvp,i),:));
    accEns(i) = mean(pEns == y(test(cvp,i)));
end

fprintf('=== K-Fold VAR (10-Fold Çapraz Doğrulama) ===\n');
fprintf('Karar Ağacı Ortalama Doğruluk: %.2f%%\n', mean(accTree)*100);
fprintf('Ensemble Ortalama Doğruluk: %.2f%%\n', mean(accEns)*100);
