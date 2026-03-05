Fnames = {'Speed','Hour'};
X2_train = Ttrain(:, Fnames);
X2_test  = Ttest(:,  Fnames);


mdl_lin = fitcsvm(X2_train, Ytrain, ...
    'KernelFunction','linear','Standardize',true, ...
    'ClassNames',categories(Ytrain));

mdl_poly = fitcsvm(X2_train, Ytrain, ...
    'KernelFunction','polynomial','PolynomialOrder',3, ...
    'Standardize',true, 'ClassNames',categories(Ytrain));

mdl_rbf = fitcsvm(X2_train, Ytrain, ...
    'KernelFunction','rbf','Standardize',true, ...
    'ClassNames',categories(Ytrain));


% Grid
x1r = linspace(min(T.(Fnames{1}))-5, max(T.(Fnames{1}))+5, 250);   % Speed
x2r = linspace(min(T.(Fnames{2}))-1, max(T.(Fnames{2}))+1, 250);   % Hour
[x1g,x2g] = meshgrid(x1r, x2r);
gridX = table(x1g(:), x2g(:), 'VariableNames', Fnames);


function plotKernel(mdl, sc, x1g, x2g, Xtest, Ytest, fname, titleText)
    % Pozitif sınıf skorunu seç
    classNames = string(mdl.ClassNames);
    posIdx = find(classNames == "1",1);
    if isempty(posIdx), [~,posIdx] = max(mean(sc,1)); end
    S = reshape(sc(:,posIdx), size(x1g));

    figure;
    contourf(x1g,x2g,S,20,'LineStyle','none'); hold on;
    colormap(parula); colorbar;
    % Karar sınırı
    contour(x1g,x2g,S,[0 0],'k','LineWidth',2);
    % Noktalar → kırmızı 'o' (hafif), neon yeşil 'x' (ağır)
    gscatter(Xtest.(fname{1}), Xtest.(fname{2}), Ytest, ...
             [1 0 0; 0 1 0.2], 'ox', 10, 'on');  % boyutu 10 yaptım
    xlabel(fname{1}); ylabel(fname{2});
    title(titleText);
    legend('Karar Bölgesi','Karar Sınırı','Hafif Kaza','Ağır Kaza','Location','bestoutside');
    grid on; hold off;
end


% Tahmin skorları
[~,sc_lin ] = predict(mdl_lin,  gridX);
[~,sc_poly] = predict(mdl_poly, gridX);
[~,sc_rbf ] = predict(mdl_rbf,  gridX);


plotKernel(mdl_lin,  sc_lin,  x1g,x2g,X2_test,Ytest,Fnames,'Lineer Kernel (Speed & Hour)');
plotKernel(mdl_poly, sc_poly, x1g,x2g,X2_test,Ytest,Fnames,'Polynomial Kernel (order=3)');
plotKernel(mdl_rbf,  sc_rbf,  x1g,x2g,X2_test,Ytest,Fnames,'RBF Kernel (Speed & Hour)');

