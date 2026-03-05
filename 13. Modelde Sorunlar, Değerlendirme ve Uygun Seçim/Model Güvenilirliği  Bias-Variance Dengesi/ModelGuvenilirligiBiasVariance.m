load carsmall
X = Horsepower;
Y = MPG;


valid = ~isnan(X) & ~isnan(Y);
X = X(valid);
Y = Y(valid);


rng(42);
cv = cvpartition(length(X), 'HoldOut', 0.3);
Xtrain = X(training(cv));
Ytrain = Y(training(cv));
Xtest  = X(test(cv));
Ytest  = Y(test(cv));


degrees = [1, 4, 10];   % lineer, orta, aşırı karmaşık
xline = linspace(min(X), max(X), 200)';

figure;
for i = 1:length(degrees)
    d = degrees(i);
    
    p = polyfit(Xtrain, Ytrain, d);
    yhat_train = polyval(p, Xtrain);
    yhat_test  = polyval(p, Xtest);
    yhat_line  = polyval(p, xline);
    
    mse_test  = mean((Ytest - yhat_test).^2);
    
    subplot(1, length(degrees), i);
    scatter(Xtrain, Ytrain, 'bo'); hold on;
    scatter(Xtest, Ytest, 'ro');
    plot(xline, yhat_line, 'k-', 'LineWidth', 2);
    title(sprintf('Polinom Derecesi = %d\nTest MSE=%.2f',d, mse_test));
    xlabel('Horsepower'); ylabel('MPG');
    legend('Train','Test','Model','Location','best');
    grid on;
end
