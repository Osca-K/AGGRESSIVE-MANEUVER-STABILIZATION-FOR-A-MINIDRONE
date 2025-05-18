
clear
clc
close all

a = 0.506; % Choose any positive value of a
omega = logspace(-2, 2, 500); % frequency from small to large
Re = -1 ./ (a * omega.^2);
Im = zeros(size(omega));

set(groot, 'DefaultAxesFontName', 'Times New Roman');
set(groot, 'DefaultAxesFontSize', 14);
set(groot, 'DefaultTextFontName', 'Times New Roman');
set(groot, 'DefaultTextFontSize', 14);

figure;
plot(Re, Im, 'b-', 'LineWidth', 2);
xlabel('Re');
ylabel('Im');
title('Nyquist Plot of TF(s) = 1 / (0.506 s^2)', 'FontWeight' , 'normal');
grid on;
xline(0, '--k'); % Imaginary axis
yline(0, '--k'); % Real axis
