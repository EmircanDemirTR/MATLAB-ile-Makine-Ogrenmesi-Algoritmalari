load ionosphere;

cv = cvpartition(size(X,1), 'HoldOut', 0.3);
idx = test(cv);
X_train = X(~idx,:);
Y_train = Y(~idx);
X_test = X(idx,:);
Y_test = Y(idx);

K_values = [1, 3, 5, 7];
accuracies = zeros(length(K_values), 1);

for i = 1:length(K_values)
    mdl = fitcknn(X_train, Y_train, 'NumNeighbors', K_values(i), 'Distance', 'minkowski', 'Exponent', 2);
    Y_pred = predict(mdl, X_test);
    accuracies(i) = sum(strcmp(Y_pred, Y_test)) / numel(Y_test);
    disp(['K=', num2str(K_values(i)), ' için Doğruluk: ', num2str(accuracies(i) * 100), '%']);
end

% En iyi K ile confusion matrix (örneğin K=3)
mdl_best = fitcknn(X_train, Y_train, 'NumNeighbors', 3, 'Distance', 'minkowski', 'Exponent', 2);
Y_pred_best = predict(mdl_best, X_test);
C = confusionmat(Y_test, Y_pred_best);
confusionchart(C, unique(Y));