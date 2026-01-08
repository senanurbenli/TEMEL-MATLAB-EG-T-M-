clc; clear; close all;

% 1) Örnek görüntü (kendi görselinizle değiştirin)
I = imread('coins.png');      % gri örnek
BW = imbinarize(I);           % segmentasyon
BW = imfill(BW,'holes');
BW = bwareaopen(BW, 50);

% 2) En büyük nesneyi seç (öğretim için basit)
CC = bwconncomp(BW);
numPixels = cellfun(@numel, CC.PixelIdxList);
[~, idx] = max(numPixels);

objMask = false(size(BW));
objMask(CC.PixelIdxList{idx}) = true;

% 3) Özellik çıkar (shape özellikleri)
stats = regionprops(objMask, 'Area', 'Perimeter', 'Eccentricity', ...
                             'Solidity', 'Extent');

feat = [stats.Area, stats.Perimeter, stats.Eccentricity, stats.Solidity, stats.Extent];

% 4) Görselleştir
figure;
subplot(1,2,1); imshow(I); title('Orijinal');
subplot(1,2,2); imshow(objMask); title('Nesne Maskesi');

disp('Cikarilan ozellik vektoru:');
disp(feat);
