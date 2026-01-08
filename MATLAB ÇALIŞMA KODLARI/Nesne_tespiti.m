clc; clear; close all;
%% 1) Yüz Tespiti (Cascade) - En Kolay Başlangıç

I = imread("visionteam1.jpg");  % MATLAB örnek görseli

detector = vision.CascadeObjectDetector();  % varsayılan: face
bboxes = detector(I);                        % tespit: [x y w h]

Iout = insertShape(I, "Rectangle", bboxes, "LineWidth", 3);
imshow(Iout);
title("Yüz Tespiti (Cascade): Bounding Box");
