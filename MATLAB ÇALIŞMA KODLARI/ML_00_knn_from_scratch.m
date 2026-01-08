%% ML_00_knn_from_scratch.m (R2017a)
% fitcknn yoksa bile kNN mantigini gostermek icin

clc; clear; close all;
rng(1);

% Oyuncak veri
N=60;
X1 = randn(N,2) + [2 2];
X2 = randn(N,2) + [-2 -2];
X  = [X1; X2];
Y  = [ones(N,1); 2*ones(N,1)];

K = 5;

% Bir test noktasi
xq = [0 0];

% kNN from scratch
d = sqrt(sum((X - xq).^2, 2));   % Euclidean distance
[~,ord] = sort(d,'ascend');
nn = ord(1:K);
yhat = mode(Y(nn));

fprintf('Query xq=[%.1f %.1f] -> predicted class = %d (K=%d)\n', xq(1), xq(2), yhat, K);

figure;
gscatter(X(:,1),X(:,2),Y); hold on;
plot(xq(1), xq(2), 'kx', 'MarkerSize',12,'LineWidth',2);
plot(X(nn,1), X(nn,2), 'ko', 'MarkerSize',10,'LineWidth',2);
title('kNN from scratch: query + neighbors');
hold off;
