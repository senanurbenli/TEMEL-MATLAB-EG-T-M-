%% ML_03_train_knn_tree_on_features.m (R2017a)
clc; clear; close all;

hasStats = license('test','statistics_toolbox');
if ~hasStats
    error('Statistics & ML Toolbox yok. fitcknn/fitctree calismaz.');
end

% Dataset yükle
T = readtable('features_dataset.csv');

X = [T.Area, T.Perimeter, T.Circularity, T.meanR, T.meanG, T.meanB];
Y = T.Label;

% Basit holdout ayırma
rng(1);
N = size(X,1);
idx = randperm(N);
nTrain = max(1, round(0.75*N));
tr = idx(1:nTrain);
te = idx(nTrain+1:end);

Xtr = X(tr,:); Ytr = Y(tr);
Xte = X(te,:); Yte = Y(te);

% kNN
K = 3;
MdlKNN = fitcknn(Xtr, Ytr, 'NumNeighbors', K, 'Standardize', true);

% Decision Tree
MdlTree = fitctree(Xtr, Ytr, 'MaxNumSplits', 10);

% Test performans
predK = predict(MdlKNN,  Xte);
predT = predict(MdlTree, Xte);

accK = mean(predK == Yte);
accT = mean(predT == Yte);

fprintf('Test acc kNN (K=%d): %.2f%%\n', K, 100*accK);
fprintf('Test acc Tree      : %.2f%%\n', 100*accT);

% Confusion matrix (basit)
disp('Confusion kNN: rows=true, cols=pred');
disp(confusionmat(Yte, predK));

disp('Confusion Tree: rows=true, cols=pred');
disp(confusionmat(Yte, predT));
