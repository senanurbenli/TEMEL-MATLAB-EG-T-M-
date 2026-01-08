clc; clear; close all;

cams = webcamlist;
if isempty(cams)
    error('Kamera bulunamadi. Support Package kurulu olmayabilir.');
end
cam = webcam(cams{1});

faceDetector = vision.CascadeObjectDetector();

h = figure;
while ishandle(h)
    frame = snapshot(cam);

    % 1) Yüz tespiti
    bboxes = step(faceDetector, frame);

    if isempty(bboxes)
        frame = insertText(frame, [20 20], 'Yuz algilanmadi', ...
            'FontSize', 20, 'BoxColor', 'red', 'TextColor', 'white');
        imshow(frame); title('Webcam - Yuz Tespiti + Segmentasyon');
        drawnow;
        continue;
    end

    % En büyük yüz
    areas = bboxes(:,3).*bboxes(:,4);
    [~, idx] = max(areas);
    bbox = bboxes(idx,:);

    % 2) ROI kırp
    faceROI = imcrop(frame, bbox);

    % 3) Segmentasyon (YCbCr cilt maskesi)
    YCBCR = rgb2ycbcr(faceROI);
    Cb = YCBCR(:,:,2);
    Cr = YCBCR(:,:,3);
    skinMask = (Cb >= 77 & Cb <= 127) & (Cr >= 133 & Cr <= 173);

    % 4) Temizle
    skinMask = imfill(skinMask, 'holes');
    skinMask = bwareaopen(skinMask, 150);

    % 5) ROI’ye maske uygula
    segFace = faceROI;
    for c = 1:3
        ch = segFace(:,:,c);
        ch(~skinMask) = 0;
        segFace(:,:,c) = ch;
    end

    % 6) Büyük görüntüye sonucu yerleştir + bbox çiz
    out = insertShape(frame, 'Rectangle', bbox, 'LineWidth', 3);

    % Segmentlenmiş ROI’yi sağ üst köşeye küçük pencere gibi koy
    small = imresize(segFace, 0.5);
    [sh, sw, ~] = size(small);
    out(1:sh, end-sw+1:end, :) = small;

    imshow(out);
    title('Webcam - Yuz Tespiti (BBox) + Segmentasyon (ROI)');
    drawnow;
end

clear cam;
