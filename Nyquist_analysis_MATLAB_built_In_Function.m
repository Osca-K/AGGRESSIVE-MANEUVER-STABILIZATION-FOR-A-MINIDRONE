clear
clc
close all

% Script for ploting the pole-zero map of four transfer functions
m=0.506;
Ixx=8.12e-5;
Iyy=8.12e-5;
Izz=6.12e-5;

% Transfer Function for elevation, roll, pitch, and yaw 
TFe = tf(1, [m 0 0]);
TFr = tf(1, [Ixx 0 0]);
TFp = tf(1, [Iyy 0 0]);
TFy = tf(1, [Izz 0 0]);


set(groot, 'DefaultAxesFontName', 'Times New Roman');
set(groot, 'DefaultAxesFontSize', 14);
set(groot, 'DefaultTextFontName', 'Times New Roman');
set(groot, 'DefaultTextFontSize', 14);


w = logspace(-1, 2, 500); %Jyst for for simplisity and cleaness of the plot



% Nyquist for Elevation
figure;
nyquist(TFe, w);
grid on;
title('Nyquist Plot for Elevation', 'FontWeight', 'normal');

% Nyquist for Roll
figure;
nyquist(TFr, w);
grid on;
title('Nyquist Plot for Roll', 'FontWeight', 'normal');

% Nyquist for Pitch
figure;
nyquist(TFp, w);
grid on;
title('Nyquist Plot for Pitch', 'FontWeight', 'normal');

% Nyquist for Yaw
figure;
nyquist(TFy, w);
grid on;
title('Nyquist Plot for Yaw', 'FontWeight', 'normal');



