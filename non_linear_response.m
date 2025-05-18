clc;
clear;
close all;

%% Simulation Settings
tspan = 0:0.1:30;                 % Time vector
x0 = zeros(12, 1);                % Initial state (all zeros)
step_inputs = {'U1', 'U2', 'U3', 'U4'};  % Input modes

state_indices = [5, 7, 9, 11];  % Z, Roll (φ), Pitch (θ), Yaw (ψ)
state_labels = {'Z [m]', 'Roll \phi [rad]', ...
                'Pitch \theta [rad]', 'Yaw \psi [rad]'};

state_data = cell(1, 4);
for i = 1:4
    [~, state_data{i}] = ode45(@(t, x) quadrotorDynamics(t, x, step_inputs{i}), tspan, x0);
end

%% Plotting (with flipped Z axis)
figure;
set(gcf, 'Position', [100, 100, 1400, 900]);

for input_idx = 1:4
    for output_idx = 1:4
        subplot_idx = (input_idx - 1) * 4 + output_idx;
        subplot(4, 4, subplot_idx);

        data = state_data{input_idx}(:, state_indices(output_idx));
        if output_idx == 1
            data = -data;  
        end

        plot(tspan, data, 'b', 'LineWidth', 1.5);

        xlabel('Time [s]', 'FontName', 'Times New Roman', 'FontSize', 9);
        ylabel(state_labels{output_idx}, 'FontName', 'Times New Roman', 'FontSize', 9);
        grid on;

        if output_idx == 1
            title(step_inputs{input_idx}, 'FontWeight', 'normal', ...
                  'FontName', 'Times New Roman', 'FontSize', 9);
        end

        ax = gca;
        ax.FontSize = 9;
        ax.FontName = 'Times New Roman';
    end
end

%% Quadrotor Dynamics Function
function dx = quadrotorDynamics(~, x, inputMode)
    % --- Constants ---
    m = 0.506;            % Mass [kg]
    g = 9.81;             % Gravity [m/s^2]
    Ix = 8.1185e-5;       % Moment of inertia X [kg*m^2]
    Iy = Ix;              % Moment of inertia Y [kg*m^2]
    Iz = 6.12233e-5;      % Moment of inertia Z [kg*m^2]
    J = 6e-5;             % Motor inertia
    SumOmega = 0;         % No gyroscopic effect in this model

    % --- Step Inputs ---
    U1 = 0; U2 = 0; U3 = 0; U4 = 0;
    step_val = 1;         % Step magnitude

    switch inputMode
        case 'U1'
            U1 = step_val;   % Thrust step (Z motion)
        case 'U2'
            U2 = step_val;   % Roll torque
        case 'U3'
            U3 = step_val;   % Pitch torque
        case 'U4'
            U4 = step_val;   % Yaw torque
    end

    % --- State Vector ---
    dx = zeros(12, 1);

    % --- Translational Motion ---
    dx(1) = x(2);  % x dot
    dx(2) = (cos(x(7)) * sin(x(9)) * cos(x(11)) + sin(x(7)) * sin(x(11))) * (U1 / m);

    dx(3) = x(4);  % y dot
    dx(4) = (cos(x(7)) * sin(x(9)) * sin(x(11)) - sin(x(7)) * cos(x(11))) * (U1 / m);

    dx(5) = x(6);  % z dot
    dx(6) = -g + (U1 / m) * cos(x(7)) * cos(x(9));  % Acceleration in Z

    % --- Rotational Motion ---
    dx(7) = x(8);  % phi (roll)
    dx(8) = ((Iz - Iy) * x(10) * x(12) - J * x(10) * SumOmega + U2) / Ix;

    dx(9) = x(10); % theta (pitch)
    dx(10) = ((Iz - Ix) * x(8) * x(12) - J * x(8) * SumOmega + U3) / Iy;

    dx(11) = x(12); % psi (yaw)
    dx(12) = ((Ix - Iy) * x(8) * x(10) + U4) / Iz;
end

exportgraphics(gcf, 'Non_StepResponses.jpeg', 'Resolution', 600);