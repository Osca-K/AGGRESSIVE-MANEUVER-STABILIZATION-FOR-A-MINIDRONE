close all;
clc
clear



m = 0.506;
Ixx = 8.12e-5;
Iyy = 8.12e-5;
Izz = 6.12e-5;

w = logspace(-1, 2, 500);   


mag = 20 * log10(1 ./ (m * w.^2));  % dB

% phases for each frequencies
phase = -180 * ones(size(w));

% Elevation
figure;

% Magnitude plot 
subplot(2, 1, 1);
semilogx(w, mag, 'b', 'LineWidth', 2);
grid on;
ylabel('Magnitude (dB)', 'FontName', 'Times New Roman','FontSize', 12, 'FontWeight', 'normal');
title('Bode Plot of TF(s) = 1 / (0.506 * s^2)', 'FontName', 'Times New Roman','FontSize', 12, 'FontWeight', 'normal');
set(gca, 'FontName', 'Times New Roman','FontSize', 12, 'FontWeight', 'normal');  

% Phase plot )
subplot(2, 1, 2);
semilogx(w, phase, 'r', 'LineWidth', 2);
grid on;
xlabel('Frequency (rad/s)', 'FontName', 'Times New Roman','FontSize', 12, 'FontWeight', 'normal');
ylabel('Phase (degrees)', 'FontName', 'Times New Roman','FontSize', 12, 'FontWeight', 'normal');
set(gca, 'FontName', 'Times New Roman','FontSize', 12, 'FontWeight', 'normal');  
