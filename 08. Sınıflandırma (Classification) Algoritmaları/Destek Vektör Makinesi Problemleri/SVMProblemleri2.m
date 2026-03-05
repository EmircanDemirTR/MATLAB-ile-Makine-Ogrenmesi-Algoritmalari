rng(1);
X = [randn(200,2); randn(20,2)+5];
Y = [ones(200,1); 2*ones(20,1)];

figure;
gscatter(X(:,1), X(:,2), Y);
title("Dengesiz Veri Seti");

svm_standart = fitcsvm(X,Y,'Standardize',true);
cost_matrix = [0 1; 10 0];
svm_cost = fitcsvm(X,Y,'Standardize',true, 'Cost',cost_matrix);