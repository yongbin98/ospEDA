clear all;
close all;
clc;

load('EDAdata.mat');

[tonic_osp, driver_osp, phasic_osp, lag] = ospEDA(EDA, fs);

meanEDA = mean(EDA); stdEDA = std(EDA);
[phasic_cvx, driver_cvx, tonic_cvx, ~, ~, ~, ~] = cvxEDA(zscore(EDA), 1/fs);
phasic_cvx = phasic_cvx*stdEDA;
tonic_cvx = tonic_cvx*stdEDA + meanEDA;

figure;
subplot(2,1,1);
hold on;
plot(time, tonic_cvx, 'LineWidth', 1.5, 'DisplayName', 'cvxEDA');
plot(time, tonic_osp, 'LineWidth', 1.5, 'DisplayName', 'OSP');
plot(time, EDA, 'k--', 'LineWidth', 1, 'DisplayName', 'EDA reference');
legend('Location', 'best');
title('Tonic Components');
ylabel('EDA [μS]');
grid on;

subplot(2,1,2);
hold on;
plot(time, phasic_cvx, 'LineWidth', 1.5, 'DisplayName', 'cvxEDA');
plot(time, phasic_osp, 'LineWidth', 1.5, 'DisplayName', 'OSP');
legend('Location', 'best');
title('Phasic Components');
xlabel('Time [s]');
ylabel('EDA [μS]');
grid on;