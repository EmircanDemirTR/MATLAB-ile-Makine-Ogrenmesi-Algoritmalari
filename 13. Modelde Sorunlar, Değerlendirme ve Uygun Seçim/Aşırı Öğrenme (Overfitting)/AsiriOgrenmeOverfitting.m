clc; clear; close all;

data = readtable('heart.csv');    % Örn: heart.csv, diabetes.csv vb.
X = data(:,1:end-1);              % Özellikler
y = table2array(data(:,end));     % Etiketler

cv = cvpartition(y,'HoldOut',0.3);
XTrain = X(training(cv),:); yTrain = y(training(cv));
XTest  = X(test(cv),:);     yTest  = y(test(cv));

treeModel = fitctree(XTrain,yTrain,'MaxNumSplits',100); 
trainAcc = mean(predict(treeModel,XTrain)==yTrain)*100;
testAcc  = mean(predict(treeModel,XTest)==yTest)*100;
fprintf('Derin Karar Ağacı → Eğitim: %.2f%% | Test: %.2f%%\n',trainAcc,testAcc);

ensModel = fitcensemble(XTrain,yTrain,'Method','Bag','NumLearningCycles',30);
trainAcc2 = mean(predict(ensModel,XTrain)==yTrain)*100;
testAcc2  = mean(predict(ensModel,XTest)==yTest)*100;
fprintf('Ensemble (Bagging) → Eğitim: %.2f%% | Test: %.2f%%\n',trainAcc2,testAcc2);

bar([trainAcc testAcc; trainAcc2 testAcc2]);
set(gca,'XTickLabel',{'Karar Ağacı','Ensemble'});
ylabel('Doğruluk (%)'); legend({'Eğitim','Test'}); title('Overfitting ve İyileştirme');
