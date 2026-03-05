clc; clear; close all;

data = readtable('bank.csv','Delimiter',';');
features = [data.age, data.balance, data.duration, data.campaign];
names = {'Yaş','Bakiye','Süre','Kampanya'};
features = rmmissing(features);
X = normalize(features,'range');

% Optimal k Belirleme (Silhouette ile)
max_k = 6; sils = zeros(1,max_k);
for k=2:max_k
    idx = kmeans(X,k,'Replicates',10,'Display','off');
    sils(k) = mean(silhouette(X,idx));
end
[~,opt_k] = max(sils);

[idx,C,sumd] = kmeans(X,opt_k,'Replicates',10,'Display','final');
data.Cluster = idx; avg_sil = mean(silhouette(X,idx));


figure;
gscatter(X(:,1),X(:,2),idx); hold on;
plot(C(:,1),C(:,2),'kx','MarkerSize',12,'LineWidth',2);
xlabel(names{1}); ylabel(names{2}); 
title(sprintf('K-Means Sonuçları (k=%d, Sil=%.3f)',opt_k,avg_sil));


fprintf('\n=== SONUÇLAR ===\n');
fprintf('Toplam veri: %d\nOptimal k=%d\nSilhouette=%.3f\nWCSS=%.2f\n',...
        size(X,1),opt_k,avg_sil,sum(sumd));
summary = groupsummary(data,'Cluster','mean',{'age','balance','duration','campaign'});
disp(summary);
