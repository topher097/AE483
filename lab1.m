data = readmatrix('20190909-155326.csv');
time = data(:, 1);
x_pos = data(:, 5);
y_pos = data(:, 6);
z_pos = data(:, 7);
yaw = data(:, 8);
pitch = data(:, 9);
roll = data(:, 10);