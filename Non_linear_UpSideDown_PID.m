clc;
clear;
close all;

%% Simulation Settings
tspan = 0:0.01:15;                          
initial_z = 5;                              % Start 5 meters above ground
initial_dz = 0;                             % Initial vertical speed
initial_dzroll = -pi;                             % Initial vupside down in roll

x0_pid = [0; 0; 0; 0; initial_z; initial_dz; initial_dzroll; 0; 0; 0; 0; 0; zeros(4,1)];  
% Desired setpoints for [Z, Roll, Pitch, Yaw]
setpoint = [5.6; 0.0; 0.0; 0.0];            % Hover at 5.6 meters

% PID Gains for Z, Roll, Pitch, Yaw
PID_gains = struct(...
    'Z',     [5.28, 4.65, 3.4],'Roll',  [5.46e-4, 8.48e-4, 7.47e-4], ...
    'Pitch', [5.46e-4, 8.48e-4, 7.47e-4], 'Yaw',   [4.11e-4, 6.39e-4, 5.63e-4] ...
);

% Controlled states
state_indices = [5, 7, 9, 11];  % Z, Roll, Pitch, Yaw
state_labels = {'Z [m]', 'Roll [rad]','Pitch [rad]', 'Yaw [rad]'};

%% Simulate with PID Controller
[t_pid, state_pid] = ode45(@(t, x) quadrotorDynamicsPID(t, x, setpoint, PID_gains), tspan, x0_pid);

%% Plot Controlled States (Z, Roll, Pitch, Yaw)
fig1 = figure('Name', 'Controlled States (Z, Roll, Pitch, Yaw)', ...
              'NumberTitle', 'off', ...
              'Position', [100, 100, 1000, 600]);

for i = 1:4
    subplot(2,2,i, 'Parent', fig1);
    response = state_pid(:, state_indices(i));  
    plot(t_pid, response, 'b', 'LineWidth', 1.5); hold on;
    yline(setpoint(i), 'r--', 'LineWidth', 1.2);
    xlabel('Time [s]');
    ylabel(state_labels{i});
    title(['Response: ' state_labels{i}], 'FontWeight', 'bold');
    legend('System Output', 'Setpoint');
    grid on;
end

%% Plot All 12 States of the Quadrotor
fig2 = figure('Name', 'All 12 States of Quadrotor', ...
              'NumberTitle', 'off', ...
              'Position', [150, 150, 1200, 700]);

state_names = {
    'X [m]', 'X Velocity [m/s]', ...
    'Y [m]', 'Y Velocity [m/s]', ...
    'Z [m]', 'Z Velocity [m/s]', ...
    'Roll [rad]', 'Roll Rate [rad/s]', ...
    'Pitch [rad]', 'Pitch Rate [rad/s]', ...
    'Yaw [rad]', 'Yaw Rate [rad/s]'
};

for i = 1:12
    subplot(3, 4, i, 'Parent', fig2);
    plot(t_pid, state_pid(:, i), 'b', 'LineWidth', 1.5);
    xlabel('Time [s]');
    ylabel(state_names{i});
    title(state_names{i}, 'FontWeight', 'bold');
    grid on;
end

%% Quadrotor Dynamics with PID Controller
function dx = quadrotorDynamicsPID(~, x, setpoint, gains)
 
    state = x(1:12);
    integrator = x(13:16);

  
    m = 0.506; g = 9.81;
    Ix = 8.1185e-5; Iy = Ix; Iz = 6.12233e-5; J = 6e-5;
    SumOmega = 0;

    
    z = state(5); dz = state(6);
    roll = state(7); droll = state(8);
    pitch = state(9); dpitch = state(10);
    yaw = state(11); dyaw = state(12);


    err = [setpoint(1) - z;
           setpoint(2) - roll;
           setpoint(3) - pitch;
           setpoint(4) - yaw];

    derr = [-dz; -droll; -dpitch; -dyaw];

    % PID controller outputs
    U1 = m * (g + gains.Z(1)*err(1) + gains.Z(2)*integrator(1) + gains.Z(3)*derr(1));
    U2 = gains.Roll(1)*err(2) + gains.Roll(2)*integrator(2) + gains.Roll(3)*derr(2);
    U3 = gains.Pitch(1)*err(3) + gains.Pitch(2)*integrator(3) + gains.Pitch(3)*derr(3);
    U4 = gains.Yaw(1)*err(4) + gains.Yaw(2)*integrator(4) + gains.Yaw(3)*derr(4);

   
    dx = zeros(16,1);

    % Translational dynamics
    dx(1) = state(2);
    dx(2) = (cos(roll)*sin(pitch)*cos(yaw) + sin(roll)*sin(yaw)) * (U1 / m);
    dx(3) = state(4);
    dx(4) = (cos(roll)*sin(pitch)*sin(yaw) - sin(roll)*cos(yaw)) * (U1 / m);
    dx(5) = state(6);
    dx(6) = -g + (U1 / m) * cos(roll) * cos(pitch);

    % Rotational dynamics
    dx(7)  = state(8);
    dx(8)  = ((Iz - Iy)*dpitch*dyaw - J*dpitch*SumOmega + U2) / Ix;

    dx(9)  = state(10);
    dx(10) = ((Ix - Iz)*droll*dyaw - J*droll*SumOmega + U3) / Iy;

    dx(11) = state(12);
    dx(12) = ((Iy - Ix)*droll*dpitch + U4) / Iz;

    % Integrator state updates
    dx(13:16) = err;
end
