
clear
clc
close all

% m = 0.506; 
omega = logspace(-2, 2, 500); % frequenciess
% Re = -1 ./ (m * omega.^2);
% Im = zeros(size(omega));

% set(groot, 'DefaultAxesFontName', 'Times New Roman');
% set(groot, 'DefaultAxesFontSize', 14);
% set(groot, 'DefaultTextFontName', 'Times New Roman');
% set(groot, 'DefaultTextFontSize', 14);

% figure;
% plot(Re, Im, 'b-', 'LineWidth', 1);
% xlabel('Re');
% ylabel('Im');
% title('Nyquist Plot of TF(s) = 1 / (0.506 s^2)', 'FontWeight' , 'normal');
% grid on;
% xline(0, '--k'); 
% yline(0, '--k'); 


% constants for the system
m = 0.506; 
Ixx = 8.112e-5;
Iyy = 8.112e-5;
Izz = 6.112e-5;


set(groot, 'DefaultAxesFontName', 'Times New Roman');
set(groot, 'DefaultAxesFontSize', 14);
set(groot, 'DefaultTextFontName', 'Times New Roman');
set(groot, 'DefaultTextFontSize', 14);


%%Graphing all Nyquist for Elevation, Roll,Picthc and Yaw using the defined function
plotNyquist(m, '0.506',omega);  %Elevation

plotNyquist(Ixx, '8.112e^{-5}',omega); % Roll


plotNyquist(Iyy, '8.112e^{-5}',omega); %Pitch

plotNyquist(Izz, '6.112e^{-5}',omega); %Yaw

% Defining the function taking two parameters of constan, the strin to display n frequencies array
function plotNyquist(const, string_value, omega)
    figure;
    Re = -1 ./ (const * omega.^2);
    Im = zeros(size(omega));
    plot(Re, Im, 'b-', 'LineWidth', 1);
    xlabel('Re');
    ylabel('Im');
    title(['Nyquist Plot of TF(s) = 1 / (' string_value ' s^2)'], 'FontWeight', 'normal');
    grid on;
    xline(0, '--k');
    yline(0, '--k');
end


