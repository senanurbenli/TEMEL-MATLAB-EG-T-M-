clc; clear; close all;

%% Veri (daha zor ayirilabilir)
rng(2);
N = 80;
t = linspace(0,2*pi,N)';

X1 = [cos(t) sin(t)] + 0.20*randn(N,2);      % ic halka
X2 = 2*[cos(t) sin(t)] + 0.20*randn(N,2);    % dis halka

X = [X1; X2];
Y = [ones(N,1); 2*ones(N,1)];

%% RBF SVM
SVM = fitcsvm(X, Y, 'KernelFunction', 'rbf', 'Standardize', true);

%% Grid
xMin = min(X(:,1)) - 1; xMax = max(X(:,1)) + 1;
yMin = min(X(:,2)) - 1; yMax = max(X(:,2)) + 1;

[xGrid, yGrid] = meshgrid(linspace(xMin,xMax,250), linspace(yMin,yMax,250));
XGrid = [xGrid(:) yGrid(:)];

predGrid = predict(SVM, XGrid);
predGrid = reshape(predGrid, size(xGrid));

%% Cizim
figure;
gscatter(X(:,1), X(:,2), Y, 'rb', 'oo', 8); hold on;
contour(xGrid, yGrid, double(predGrid), [1.5 1.5], 'k', 'LineWidth', 2);
title('SVM (RBF Kernel) - Dogrusal Olmayan Karar Siniri');
xlabel('Ozellik-1'); ylabel('Ozellik-2');
grid on;
