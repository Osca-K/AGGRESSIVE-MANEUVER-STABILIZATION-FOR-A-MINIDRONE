% Define s as transfer function variable
s = tf('s');

% Transfer Functions:
TF_E = 1 / (0.506 * s^2);            % Elevation
TF_R = 1 / (8.12e-5 * s^2);          % Roll
TF_P = 1 / (8.12e-5 * s^2);          % Pitch
TF_Y = 1 / (6.12e-5 * s^2);          % Yaw

% Plot Bode plots
figure;
subplot(2,2,1);
bode(TF_E);
title('Elevation TF: 1/(0.506s^2)');
grid on;

subplot(2,2,2);
bode(TF_R);
title('Roll TF: 1/(8.12e-5 s^2)');
grid on;

subplot(2,2,3);
bode(TF_P);
title('Pitch TF: 1/(8.12e-5 s^2)');
grid on;

subplot(2,2,4);
bode(TF_Y);
title('Yaw TF: 1/(6.12e-5 s^2)');
grid on;
