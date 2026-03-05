load fisheriris;

X = meas(1:100, 3:4);
Y = species(1:100);

figure();
gscatter(X(:,1), X(:,2), Y);
xlabel('Petal Length');
ylabel('Petal Width');
title('Fisher Iris Dataset');
grid on;

mdl = fitclinear(X, Y, 'Learner','logistic');
Y_pred = predict(mdl, X);
Y_categorical = categorical(Y);

accuracy = sum(Y_pred == Y_categorical) / length(Y);
fprintf('Kod ile eğitilen modelin doğruluk oranı: %.2f\n', accuracy*100);