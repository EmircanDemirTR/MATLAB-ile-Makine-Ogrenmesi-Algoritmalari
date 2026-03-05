clc; clear; close all;

data = readtable('heart.csv');  
X = data(:,1:end-1); 
y = table2array(data(:,end)); 

cv = cvpartition(y,'HoldOut',0.3);
XTrain = X(training(cv),:);  yTrain = y(training(cv));
XTest  = X(test(cv),:);      yTest  = y(test(cv));

model_simple = fitctree(XTrain,yTrain,'MaxNumSplits',2);

ypred_train = predict(model_simple,XTrain);
ypred_test  = predict(model_simple,XTest);
trainAcc = mean(ypred_train==yTrain)*100;
testAcc  = mean(ypred_test==yTest)*100;

fprintf("Basit Model (Underfit) → Eğitim: %.2f%% | Test: %.2f%%\n", ...
         trainAcc,testAcc);

model_better = fitctree(XTrain,yTrain,'MaxNumSplits',20);
ypred2 = predict(model_better,XTest);
acc2   = mean(ypred2==yTest)*100;

fprintf("İyileştirilmiş Model → Test: %.2f%%\n",acc2);
