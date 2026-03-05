cancer_data = readtable("breast_cancer_bd.csv");
if iscell(cancer_data.BareNuclei)
    cancer_data.BareNuclei = str2double(strrep(cancer_data.BareNuclei, '?', 'NaN'));
end

cancer_data = rmmissing(cancer_data);

X = table2array(cancer_data(:,2:10));
Y = categorical(table2array(cancer_data(:,11)));

X = (X-mean(X))./std(X);

figure();
histogram(Y);
title('Kanser Sınıf Dağılımı');
xlabel('Sınıflar (2:İyi huylu, 4:Kötü huylu)');
ylabel('Örnek Sayısı');

cv = cvpartition(Y, 'HoldOut', 0.3);
XTrain = X(training(cv),:);
YTrain = Y(training(cv),:);
XTest = X(test(cv),:);
YTest = Y(test(cv));

NBModel = fitcnb(XTrain, YTrain);

YPred = predict(NBModel, XTest);
% Modelin doğruluğunu değerlendirelim
accuracy = sum(YPred == YTest) / length(YTest);
fprintf('Model Doğruluğu: %.2f%%\n', accuracy * 100);

confusionchart(YTest, YPred);
title('Karmaşıklık Matrisi');

[C, order] = confusionmat(YTest, YPred);

precision = diag(C) ./ sum(C, 1)';
recall = diag(C) ./ sum(C, 2);
f1Score = 2 * (precision .* recall) ./ (precision + recall);

metricsTable = table(order, precision, recall, f1Score, 'VariableNames', {'Class', 'Precision', 'Recall', 'F1Score'});
disp(metricsTable);