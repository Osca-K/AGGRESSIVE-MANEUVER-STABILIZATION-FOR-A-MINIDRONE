clc;
clear;
close all;

m  = 0.506;
Ix = 8.11858e-5;
Iy = Ix;
Iz = 6.1223e-7;
g  = 9.81;
J  = 6e-5;
SumOmega0 = 0;

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


C2 = [0 0 0 0 1 0 0 0 0 0 0 0;   
      0 0 0 0 0 0 1 0 0 0 0 0;   
      0 0 0 0 0 0 0 0 1 0 0 0;  
      0 0 0 0 0 0 0 0 0 0 1 0];  

D = zeros(4, 4); 

sys = ss(A2, B, C2, D);


PD = struct(...
    'Z',     struct('Kp',2.307, 'Kd', 1.406), ...
    'Roll',  struct('Kp', 8.48e-4, 'Kd', 5.46e-4), ...
    'Pitch', struct('Kp', 8.48e-4, 'Kd', 5.46e-4), ...
    'Yaw',   struct('Kp', 6.39e-4, 'Kd', 4.11e-4) ...
);

dt = 0.01;
T = 15;
t = 0:dt:T;


x0 = zeros(12,1);
x0(5)  = 5;       % Initial z position [m]
x0(7)  = -pi;       % Initial z velocity [m/s]

x = x0;

x_hist = zeros(length(t), 12);
u_hist = zeros(length(t), 4);


x_hist(1, :) = x';

setpoint = [5.6; 0; 0; 0];  % [Z, Roll, Pitch, Yaw]


prev_error = setpoint - C2*x;


for k = 2:length(t)
    y = C2 * x;             
    error = setpoint - y;   
    d_error = (error - prev_error) / dt;

    % PD control 
    u = zeros(4,1);
    u(1) = PD.Z.Kp*error(1) + PD.Z.Kd*d_error(1);
    u(2) = PD.Roll.Kp*error(2) + PD.Roll.Kd*d_error(2);
    u(3) = PD.Pitch.Kp*error(3) + PD.Pitch.Kd*d_error(3);
    u(4) = PD.Yaw.Kp*error(4) + PD.Yaw.Kd*d_error(4);

   
    dx = A2*x + B*u;
    x = x + dx * dt;

    x_hist(k, :) = x';
    u_hist(k, :) = u';
    prev_error = error;
end


figure;
titles = {'Z [m]', 'Roll φ [rad]', 'Pitch θ [rad]', 'Yaw ψ [rad]'};
output_indices = [5 7 9 11];  % Z, Roll, Pitch, Yaw

for i = 1:4
    subplot(2,2,i);
    plot(t, x_hist(:, output_indices(i)), 'b', 'LineWidth', 1.5); hold on;
    yline(setpoint(i), 'r--');
    title(titles{i});
    xlabel('Time [s]');
    ylabel(titles{i});
    grid on;
end


figure;
state_titles = {...
   'x [m]', 'ẋ [m/s]', ...
    'y [m]', 'ẏ [m/s]', ...
    'z [m]', 'ż [m/s]', ...
    'Roll [rad]', 'Roll Rate [rad/s]', ...
    'Pitch [rad]', 'Pitch Rate [rad/s]', ...
    'Yaw [rad]', 'Yaw Rate [rad/s]'};

for i = 1:12
    subplot(4,3,i);
    plot(t, x_hist(:, i), 'b', 'LineWidth', 1.2);
    xlabel('Time [s]');
    ylabel(state_titles{i});
    title(['State ' num2str(i)]);
    grid on;
end
sgtitle('All State Variables Over Time');
