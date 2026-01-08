%I = imread('rice.png');
%imshow(I);
%title('Orijinal Goruntu');

%BW = imbinarize(I);
%BW = imfill(BW, 'holes');
%BW = bwareaopen(BW, 100);

%imshow(BW);
%title('Pirincler Segmentasyonu');
clc; clear; close all;

% 1) Renkli görseli oku
I = imread('kup.jpg');   % kendi dosya adınızı yazın
imshow(I); title('Orijinal RGB');

% 2) HSV'ye çevir
HSV = rgb2hsv(I);
H = HSV(:,:,1);  % Hue (renk)
S = HSV(:,:,2);  % Saturation (doygunluk)
V = HSV(:,:,3);  % Value (parlaklik)

% 3) Segmentasyon: ÖRNEK olarak KIRMIZI renk aralığı
% Kırmızı hue aralığı 0'a yakın ve 1'e yakın bölgede olur (wrap-around)
%mask = (H < 0.05 | H > 0.95) & S > 0.35 & V > 0.20;
mask = (H > 0.25 & H < 0.45) & S > 0.30 & V > 0.20;%yeşil maske
mask2 = (H > 0.55 & H < 0.75) & S > 0.30 & V > 0.20;%mavi maske

% 4) Maske temizleme (morfoloji)
mask = imfill(mask, 'holes');
mask = bwareaopen(mask, 200);


% 5) Maskeyi görüntüye uygula (segmentlenmiş çıktı)
out = I;
for c = 1:3
    ch = out(:,:,c);
    ch(~mask) = 0;
    out(:,:,c) = ch;
end

% 6) Gösterimler
figure;
subplot(1,3,1); imshow(I);    title('RGB');
subplot(1,3,2); imshow(mask); title('Maske (Segment)');
subplot(1,3,3); imshow(out);  title('Segmentlenmis Goruntu');
