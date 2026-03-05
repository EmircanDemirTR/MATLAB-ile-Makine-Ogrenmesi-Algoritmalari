clc; clear; close all;

data = readtable('heart.csv');  

X = data(:,1:end-1); 
y = table2array(data(:,end)); 

cv = cvpartition(y,'HoldOut',0.2);
XTrain = X(training(cv),:);
yTrain = y(training(cv));
XTest  = X(test(cv),:);
yTest  = y(test(cv));

tree = fitctree(XTrain,yTrain,'MaxNumSplits',5); 
yPred1 = predict(tree,XTest);
acc1 = mean(yPred1==yTest)*100;

ens = fitcensemble(XTrain,yTrain,'Method','Bag','NumLearningCycles',50);
yPred2 = predict(ens,XTest);
acc2 = mean(yPred2==yTest)*100;

fprintf('Karar Ağacı Doğruluk: %.2f%%\n',acc1);
fprintf('Ensemble (Bagging) Doğruluk: %.2f%%\n',acc2);

bar([acc1 acc2]); ylim([0 100]);
set(gca,'XTickLabel',{'Karar Ağacı','Bagging'});
ylabel('Doğruluk (%)'); title('Bias-Variance Dengesi');
