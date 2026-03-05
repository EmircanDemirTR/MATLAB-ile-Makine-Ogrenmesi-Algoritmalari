load("concreteData.mat");
predictors = 'Cement+BlastFurnaceSlag+FlyAsh+Water+Superplasticizer+CoarseAggregate+FineAggregate+Age';

mdl_tree_default = fitrtree(concreteData, ['CompressiveStrength ~', predictors]);
fprintf("\n\n Varsayılan Agacimiz:");
view(mdl_tree_default);

mdl_tree_tuned = fitrtree(concreteData, ['CompressiveStrength ~', predictors], 'MinLeafSize',50);
fprintf("\n\n Ayarlanmış Agacimiz:");
view(mdl_tree_tuned);