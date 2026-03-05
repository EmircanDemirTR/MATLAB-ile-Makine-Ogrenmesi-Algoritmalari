clc; clear; close all; rng(7);

n = 200;
BMI_low  = randn(n,1)*2 + 22;     % düşük risk BMI (ortalama 22)
Chol_low = randn(n,1)*15 + 170;   % düşük risk kolesterol (ortalama 170)

BMI_high  = randn(n,1)*2.5 + 30;  % yüksek risk BMI (ortalama 30)
Chol_high = randn(n,1)*20 + 240;  % yüksek risk kolesterol (ortalama 240)

X  = [BMI_low Chol_low; BMI_high Chol_high];
Y  = [zeros(n,1); ones(n,1)];
Yc = categorical(Y, [0 1], {'DusukRisk','YuksekRisk'});


cvp = cvpartition(Yc,'HoldOut',0.3, 'Stratify', true);
Xtrain = X(training(cvp),:);
Ytrain = Yc(training(cvp),:);
Xtest  = X(test(cvp),:);
Ytest  = Yc(test(cvp),:);


mdl = fitcsvm(Xtrain, Ytrain, ...
    'KernelFunction','linear', ...
    'Standardize',true, ...
    'ClassNames',categories(Ytrain));


Yhat = predict(mdl, Xtest);
acc  = mean(Yhat == Ytest);
fprintf('Test doğruluk: %.3f\n', acc);


figure; gscatter(Xtrain(:,1), Xtrain(:,2), Ytrain, 'rb', 'ox'); hold on;
sv = mdl.SupportVectors;
plot(sv(:,1), sv(:,2), 'ko','MarkerSize',8,'LineWidth',1.2);


% Karar sınırı için grid
x1r = linspace(min(X(:,1))-2, max(X(:,1))+2, 200);
x2r = linspace(min(X(:,2))-20, max(X(:,2))+20, 200);
[x1g,x2g] = meshgrid(x1r,x2r);
[~,score] = predict(mdl, [x1g(:) x2g(:)]);
scoreGrid = reshape(score(:,2), size(x1g));

contour(x1g,x2g,scoreGrid,[0 0],'k','LineWidth',1.5);
contour(x1g,x2g,scoreGrid,[-0.5 0.5],'k--');

legend({'Dusuk Risk','Yuksek Risk','Destek Vektörleri','Karar Sınırı','Marjinler'}, ...
       'Location','best');
xlabel('Vücut Kitle İndeksi (BMI)');
ylabel('Kolesterol Seviyesi (mg/dL)');
title(sprintf('Sağlık Riski Tahmini — Test Doğruluk: %.3f', acc)); grid on; hold off;