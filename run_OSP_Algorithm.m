clear all;
close all;
clc;

fs = 4;
t = 0:1/fs:360;
eda = 1 + sin(2*pi*0.1/fs*t) + t*0.05;

[tonic_osp, driver_osp, phasic_osp, lag] = ospEDA(eda, fs);

figure;
subplot(2,1,1);
hold on;
plot(t, tonic_osp, 'LineWidth', 1.5, 'DisplayName', 'OSP');
plot(t, eda, 'k--', 'LineWidth', 1, 'DisplayName', 'reference');
legend('Location', 'best');
title('Tonic Components');
xlabel('Time [s]');
ylabel('EDA [μS]');
grid on;

subplot(2,1,2);
hold on;
plot(t, phasic_osp, 'LineWidth', 1.5, 'DisplayName', 'Phasic');
bar(t, driver_osp, 'BarWidth', 2, 'DisplayName', 'Driver');
legend('Location', 'best');
title('Phasic Components');
xlabel('Time [s]');
ylabel('EDA [μS]');
grid on;