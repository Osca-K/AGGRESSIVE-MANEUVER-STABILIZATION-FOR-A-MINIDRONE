clc;
clear;
close all;

% === Constants ===
m  = 0.506;
Ix = 8.11858e-5;
Iy = Ix;
Iz = 6.1223e-7;
g  = 9.81;
J  = 6e-5;
b  = 3.13e-5;
k  = 75e-7;

SumOmega0 = 0;

% === Linearized system matrix A2 ===
A2 = [0 1 0 0 0 0 0 0 0 0 0 0;
      0 0 0 0 0 0 0 0  g 0 0 0;
      0 0 0 1 0 0 0 0 0 0 0 0;
      0 0 0 0 0 0 -g 0 0 0 0 0;
      0 0 0 0 0 1 0 0 0 0 0 0;
      0 0 0 0 0 0 0 0 0 0 0 0;
      0 0 0 0 0 0 0 1 0 0 0 0;
      0 0 0 0 0 0 0 0 0 0 0 0;
      0 0 0 0 0 0 0 0 0 1 0 0;
      0 0 0 0 0 0 (-J*SumOmega0)/Iy 0 0 0 0 0;
      0 0 0 0 0 0 0 0 0 0 0 1;
      0 0 0 0 0 0 0 0 0 0 0 0];

% === Input matrix B ===
B = [0     0     0     0;
     0     0     0     0;
     0     0     0     0;
     0     0     0     0;
     0     0     0     0;
     1/m   0     0     0;
     0     0     0     0;
     0   1/Ix    0     0;
     0     0     0     0;
     0     0   1/Iy    0;
     0     0     0     0;
     0     0     0   1/Iz];

% === Output matrix C2 ===
C2 = [0 0 0 0 1 0 0 0 0 0 0 0;
      0 0 0 0 0 0 1 0 0 0 0 0;
      0 0 0 0 0 0 0 0 1 0 0 0;
      0 0 0 0 0 0 0 0 0 0 1 0];

% === Matrix D ===
D = zeros(4, 4);

% Time vector
t = 0:0.1:30;

% Labels
U_labels = {'U1', 'U2', 'U3', 'U4'};
Y_labels = {'Z [m]', 'Roll \phi [rad]', 'Pitch \theta [rad]', 'Yaw \psi [rad]'};

% System definition
sys = ss(A2, B, C2, D);

% Plotting step responses
figure;
set(gcf, 'Position', [100, 100, 1400, 900]);

for u = 1:4
    U = zeros(length(t), 4);
    U(:, u) = 1;

    [y, ~, ~] = lsim(sys, U, t);

    for y_idx = 1:4
        subplot_idx = (u - 1) * 4 + y_idx;
        subplot(4, 4, subplot_idx);
        plot(t, y(:, y_idx), 'b', 'LineWidth', 1.5);

        xlabel('Time [s]', 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');
        ylabel(Y_labels{y_idx}, 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'normal');

        if y_idx == 1
            title(['Step on ', U_labels{u}], ...
                'FontWeight', 'normal', 'FontName', 'Times New Roman', 'FontSize', 14);
        end

        grid on;
        ax = gca;
        % ax.FontSize = 9;
        % ax.FontWeight = 'bold';
        % ax.FontName = 'Times New Roman';  
    end
end
exportgraphics(gcf, 'StepResponses.jpeg', 'Resolution', 300);


