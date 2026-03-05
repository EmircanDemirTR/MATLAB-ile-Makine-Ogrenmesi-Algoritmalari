load fisheriris;
data = zscore(meas);

Z = linkage(data, 'ward');

% Dendrogram çizimi
figure;
title("Hiyerarşik Kümeleme Dendrogramı");
xlabel('Veri Noktaları');
ylabel('Mesafe');

% Kümeleme
T = cluster(Z, 'maxclust', 3);

% Sonuçları Görselleştirme
figure;
gscatter(meas(:,1), meas(:,2), T);
title("Hiyerarşik Kümeleme Sonuçları");
xlabel('Sepal Length');
ylabel('Sepal Width');
legend('Küme 1', 'Küme 2', 'Küme 3');

% Küme Atamalarını Gösterelim ilk 10 örnek için
disp("İlk 10 veri noktasının küme atamaları");
disp(T(1:10));