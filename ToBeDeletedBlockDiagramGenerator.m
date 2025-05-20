% === Create New Simulink Model ===
modelName = 'Drone_FullSystem_WithDisturbance';
new_system(modelName);
open_system(modelName);

axes = {'Elevation', 'Roll', 'Pitch', 'Yaw'};
plantGains = {'1/0.506', '1/8.12e-5', '1/8.12e-5', '1/6.12e-5'};
controllerGains = {'2', '2', '2', '2'};  % Placeholder proportional gains
yOffset = [100, 250, 400, 550];

for i = 1:length(axes)
    axis = axes{i};
    y = yOffset(i);

    % Step Input (Reference Command)
    add_block('simulink/Sources/Step', [modelName '/' axis '_Ref'], ...
        'Time', '0', 'Before', '0', 'After', '1', ...
        'Position', [30 y 60 y+30]);

    % Sum Block (error = ref - feedback)
    add_block('simulink/Math Operations/Sum', [modelName '/' axis '_Sum1'], ...
        'Inputs', '+-', ...
        'Position', [90 y 120 y+30]);

    % Controller (Proportional Gain)
    add_block('simulink/Commonly Used Blocks/Gain', [modelName '/' axis '_Controller'], ...
        'Gain', controllerGains{i}, ...
        'Position', [150 y 180 y+30]);

    % Sum2: Add disturbance input
    add_block('simulink/Math Operations/Sum', [modelName '/' axis '_Sum2'], ...
        'Inputs', '++', ...
        'Position', [210 y 240 y+30]);

    % Disturbance Input
    add_block('simulink/Sources/Step', [modelName '/' axis '_Disturbance'], ...
        'Time', '2', 'Before', '0', 'After', '1', ...
        'Position', [150 y+50 180 y+80]);

    % Plant Gain
    add_block('simulink/Commonly Used Blocks/Gain', [modelName '/' axis '_PlantGain'], ...
        'Gain', plantGains{i}, ...
        'Position', [270 y 300 y+30]);

    % First Integrator
    add_block('simulink/Continuous/Integrator', [modelName '/' axis '_Int1'], ...
        'Position', [330 y 360 y+30]);

    % Second Integrator
    add_block('simulink/Continuous/Integrator', [modelName '/' axis '_Int2'], ...
        'Position', [390 y 420 y+30]);

    % Scope
    add_block('simulink/Sinks/Scope', [modelName '/' axis '_Scope'], ...
        'Position', [470 y 500 y+30]);

    % === Connect Blocks ===
    add_line(modelName, [axis '_Ref/1'], [axis '_Sum1/1']);
    add_line(modelName, [axis '_Int2/1'], [axis '_Sum1/2']);
    add_line(modelName, [axis '_Sum1/1'], [axis '_Controller/1']);
    add_line(modelName, [axis '_Controller/1'], [axis '_Sum2/1']);
    add_line(modelName, [axis '_Disturbance/1'], [axis '_Sum2/2']);
    add_line(modelName, [axis '_Sum2/1'], [axis '_PlantGain/1']);
    add_line(modelName, [axis '_PlantGain/1'], [axis '_Int1/1']);
    add_line(modelName, [axis '_Int1/1'], [axis '_Int2/1']);
    add_line(modelName, [axis '_Int2/1'], [axis '_Scope/1']);
end

% === Save Model ===
save_system(modelName);
