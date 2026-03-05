rng(1); % Tekrarlanabilirlik için
N = 100;
r1 = sqrt(rand(N,1));
t1 = 2*pi*rand(N,1);
data1 = [r1.*cos(t1), r1.*sin(t1)];

r2 = sqrt(3*rand(N,1)+1);
t2 = 2*pi*rand(N,1);
data2 = [r2.*cos(t2), r2.*sin(t2)];

X = [data1; data2];
Y = [ones(N,1); 2*ones(N,1)];


figure;
gscatter(X(:,1), X(:,2), Y);
title('Doğrusal Olarak Ayrılamayan Veri Seti');

Doğrusal (Linear) Kernel ile SVM 
svm_linear = fitcsvm(X, Y, 'KernelFunction', 'linear', 'Standardize', true);

d = 0.02;
[x1Grid, x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)), min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:), x2Grid(:)];
[~, scores] = predict(svm_linear, xGrid);

hold on;
contour(x1Grid, x2Grid, reshape(scores(:,2), size(x1Grid)), [0 0], 'k', 'LineWidth', 2);
title('Doğrusal Kernel ile Başarısız Sınıflandırma');
legend('Sınıf 1', 'Sınıf 2', 'Karar Sınırı');
hold off;

Gaussian (RBF) Kernel ile SVM
figure;
gscatter(X(:,1), X(:,2), Y);
title('Gaussian (RBF) Kernel ile Başarılı Sınıflandırma');

svm_rbf = fitcsvm(X, Y, 'KernelFunction', 'rbf', 'Standardize', true);
[~, scores_rbf] = predict(svm_rbf, xGrid);

hold on;
contour(x1Grid, x2Grid, reshape(scores_rbf(:,2), size(x1Grid)), [0 0], 'k', 'LineWidth', 2);
legend('Sınıf 1', 'Sınıf 2', 'Karar Sınırı');
hold off;

