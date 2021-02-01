clear all; close all;

%Load Excel Data
filename = '20190909-164605-Hand.csv';
data = xlsread(filename);

time = data(:,1);

imu_pitch = data(:,5);
imu_roll = data(:,6);
imu_yaw = data(:,7);

gyro_roll = data(:,2);
gyro_pitch = data(:,3);
gyro_yaw = data(:,4);

index = 1453;
dt = 0.02;

angrate_pitch = [];
angrate_roll = [];
angrate_yaw = [];

angvel_pitch = [];
angvel_roll = [];
angvel_yaw = [];
 
%Finite Difference
for i = 1:index
    angrate_pitch =[angrate_pitch; (imu_pitch(i+1) - imu_pitch(i))/dt];
    angrate_roll =[angrate_roll; (imu_roll(i+1) - imu_roll(i))/dt];
    angrate_yaw = [angrate_yaw; (imu_yaw(i+1) - imu_yaw(i))/dt];
    
    R_Ain0 = [cos(imu_yaw(i)), -sin(imu_yaw(i)), 0; sin(imu_yaw(i)), cos(imu_yaw(i)), 0; 0, 0, 1];
    R_BinA = [cos(imu_pitch(i)), 0, sin(imu_pitch(i)); 0, 1, 0; -sin(imu_pitch(i)), 0, cos(imu_pitch(i))];
    R_1inB = [1, 0, 0; 0, cos(imu_roll(i)), -sin(imu_roll(i)); 0 sin(imu_roll(i)), cos(imu_roll(i))];
    R_1in0 = R_Ain0*R_BinA*R_1inB;
    angvel_matrix = [((R_BinA*R_1inB)'*[0;0;1]), (R_1inB)'*[0;1;0], [1;0;0]];
   
    angvel_pitch = [angvel_pitch; angvel_matrix(1,1)*angrate_pitch(i,1) + angvel_matrix(1,2)*angrate_roll(i,1) + angvel_matrix(1,3)*angrate_yaw(i,1)];
    angvel_roll = [angvel_pitch; angvel_matrix(2,1)*angrate_pitch(i,1) + angvel_matrix(2,2)*angrate_roll(i,1) + angvel_matrix(2,3)*angrate_yaw(i,1)];
    angvel_yaw = [angvel_pitch; angvel_matrix(3,1)*angrate_pitch(i,1) + angvel_matrix(3,2)*angrate_roll(i,1) + angvel_matrix(3,3)*angrate_yaw(i,1)];
    i = i+1;
end

angrate_pitch = [angrate_pitch; 0];
angrate_roll = [angrate_roll; 0];
angrate_yaw = [angrate_yaw; 0];

angvel_pitch = [angvel_pitch; 0];
angvel_roll = [angvel_roll; 0];
angvel_yaw = [angvel_yaw; 0];

subplot(3, 1, 1)
hold on
plot(time(:,1),angrate_pitch(:,1))
plot(time(:,1),angvel_pitch(:,1))
plot(time(:,1),gyro_pitch(:,1))
xlabel('Time (s)')
ylabel('Angle (rad)')
title('Pitch')

subplot(3, 1, 2)
plot(time(:,1),angrate_roll(:,1))
plot(time(:,1),angvel_roll(:,1))
plot(time(:,1),gyro_roll(:,1))
xlabel('Time (s)')
ylabel('Angle (rad)')
title('Roll')

subplot(3, 1, 3)
plot(time(:,1),angrate_yaw(:,1))
plot(time(:,1),angvel_yaw(:,1))
plot(time(:,1),gyro_yaw(:,1))
xlabel('Time (s)')
ylabel('Angle (rad)')
title('Yaw')
hold off



