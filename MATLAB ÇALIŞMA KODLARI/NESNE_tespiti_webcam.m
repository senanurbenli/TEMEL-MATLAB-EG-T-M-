clc; clear; close all;

% Kamerayı bul ve aç
cams = webcamlist;
cam = webcam(cams{1});

% Yüz dedektörü
detector = vision.CascadeObjectDetector();

h = figure;
while ishandle(h)
    frame = snapshot(cam);

    % Yüzleri bul
    bboxes = step(detector, frame);

    if ~isempty(bboxes)
        % Yüz VARSA → kutu çiz
        frame = insertShape(frame, 'Rectangle', bboxes, 'LineWidth', 3);
    else
        % Yüz YOKSA → yazı yaz
        frame = insertText(frame, [20 20], ...
            'Yuz algilanmadi', ...
            'FontSize', 20, ...
            'BoxColor', 'red', ...
            'TextColor', 'white');
    end

    imshow(frame);
    title('Gercek Zamanli Yuz Tespiti');
    drawnow;
end

clear cam;
