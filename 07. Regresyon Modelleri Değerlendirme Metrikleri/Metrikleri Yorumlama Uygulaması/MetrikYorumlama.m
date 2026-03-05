load carsmall;

X = [Weight, Horsepower];
Y = MPG;

validldx = ~isnan(sum(X,2)) & ~isnan(Y);
X = X(validldx,:);
Y = Y(validldx);

% Regresyon model kurulumu
mdl = fitlm(X,Y);
disp(mdl);

Y_pred = predict(mdl,X);

% Hata Metriklerini Hesaplama
errors = Y - Y_pred;

MAE = mean(abs(errors));
MSE = mean(errors.^2);
RMSE = sqrt(MSE);

% R2 Hesaplama
SS_res = sum(errors.^2);
SS_tot = sum((Y-mean(Y)).^2);
R2 = 1-(SS_res / SS_tot);

% Ekrana Yazdırma
fprintf("\n\nSONUÇLAR:\n\n");
fprintf("MAE = %.3f\n", MAE);
fprintf("MSE = %.3f\n", MSE);
fprintf("RMSE = %.3f\n", RMSE);
fprintf("R2 = %.3f\n", R2);


figure();
scatter(Y, Y_pred, 'filled');
xlabel("Gerçek Değerler (Y");
ylabel("Tahmin Edilen Değerler (Y_{pred})");
grid on;
refline(1,0);