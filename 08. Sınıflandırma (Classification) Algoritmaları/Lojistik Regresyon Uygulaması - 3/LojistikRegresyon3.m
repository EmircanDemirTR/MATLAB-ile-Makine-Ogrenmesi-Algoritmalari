load fisheriris;

X = meas;
Y = species;

mdl = fitmnr(X, Y);

new_flower = [6.5, 2.8, 5.0, 1.6];

[predicted_label, probabality_scores] = predict(mdl, new_flower);

fprintf("Modelin Tahmini: %s\n", predicted_label{1});
fprintf("Modelin Güven Skorları (Olasılıkları):\n");
class_names = mdl.ClassNames;

for i=1 : length(class_names)
    fprintf('- %s: %.4f (%%%().2f\n)', class_names{i}, probabality_scores(i), probabality_scores(i)*100);
end

Y_pred_all = predict(mdl, X);
figure();
cm = confusionchart(Y, Y_pred_all);
cm.Title = 'Tüm Veri Üzerindeki Model Performansı:';