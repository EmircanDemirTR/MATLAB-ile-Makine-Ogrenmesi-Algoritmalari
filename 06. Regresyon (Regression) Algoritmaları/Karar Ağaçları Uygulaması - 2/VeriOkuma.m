filename = 'concrete_data.csv';
concreteData = readtable(filename);

concreteData.Properties.VariableNames = {'Cement', 'BlastFurnaceSlag', 'FlyAsh', 'Water', 'Superplasticizer', 'CoarseAggregate'...
    ,'FineAggregate', 'Age', 'CompressiveStrength'};

save("concreteData.mat", "concreteData");
head(concreteData);