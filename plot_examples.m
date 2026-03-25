clear all
close all
clc

load('Results_simulated_20dB.mat');

methods = {'cda','dda','cvx','sparse','bayesian','udm','osp','reference'};
labels = {'LedaLab-CDA','LedaLab-DDA','cvxEDA','sparsEDA','BayesianEDA','UDM','ospEDA','EDA Reference'};
n_methods = length(methods);

base_colors = [0.85 0.33 0.10; 0.49 0.18 0.56; 0.47 0.67 0.19; 0.64 0.08 0.18; ...
               0.30 0.75 0.93; 0.93 0.69 0.13; 0.00 0.00 0.00; 0.50 0.50 0.50];
colors = base_colors(1:n_methods, :);

%% i = subject number (Choose subject number between 1~100)
i = 1;
sub_idx = i;

EDA = sim(i).eda;
fs = 4;
time = 0:1/fs:300; time(1) = [];
        
%% Tonic Comparison
figure('Position',[100 100 1430 650],'Color','w');
hold on; grid on; box on;
plot(time, all_signals.cda.tonic(i,:), 'Color', colors(1,:), 'LineWidth', 1.5, 'DisplayName', labels{1});
plot(time, all_signals.dda.tonic(i,:), 'Color', colors(2,:), 'LineWidth', 1.5, 'DisplayName', labels{2});
plot(time, all_signals.cvx.tonic(i,:), 'Color', colors(3,:), 'LineWidth', 1.5, 'DisplayName', labels{3});
plot(time, all_signals.sparse.tonic(i,:), 'Color', colors(4,:), 'LineWidth', 1.5, 'DisplayName', labels{4});
plot(time, all_signals.bayesian.tonic(i,:), 'Color', colors(5,:), 'LineWidth', 1.5, 'DisplayName', labels{5});
plot(time, all_signals.udm.tonic(i,:), 'Color', colors(6,:), 'LineWidth', 1.5, 'DisplayName', labels{6});
plot(time, all_signals.osp.tonic(i,:), 'Color', colors(7,:), 'LineWidth', 2, 'DisplayName', labels{7});
plot(time, sim(i).tonic, 'Color','r','LineWidth', 2, 'DisplayName', 'Ground Truth Tonic');
plot(time, EDA, '--', 'Color', colors(8,:), 'LineWidth', 1.5, 'DisplayName', labels{8});
xlabel('Time [s]', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('EDA [μS]', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'YColor', 'k', 'GridAlpha', 0.3, 'FontSize', 14);
legend('Location', 'Northeast', 'FontSize', 14);

%% Phasic Comparison
figure('Position',[100 100 1430 650],'Color','w');
hold on; grid on; box on;
plot(time, all_signals.cda.phasic(i,:), 'Color', colors(1,:), 'LineWidth', 1.5, 'DisplayName', labels{1});
plot(time, all_signals.dda.phasic(i,:), 'Color', colors(2,:), 'LineWidth', 1.5, 'DisplayName', labels{2});
plot(time, all_signals.cvx.phasic(i,:), 'Color', colors(3,:), 'LineWidth', 1.5, 'DisplayName', labels{3});
plot(time, all_signals.sparse.phasic(i,:), 'Color', colors(4,:), 'LineWidth', 1.5, 'DisplayName', labels{4});
plot(time, all_signals.bayesian.phasic(i,:), 'Color', colors(5,:), 'LineWidth', 1.5, 'DisplayName', labels{5});
plot(time, all_signals.udm.phasic(i,:), 'Color', colors(6,:), 'LineWidth', 1.5, 'DisplayName', labels{6});
plot(time, all_signals.osp.phasic(i,:), 'Color', colors(7,:), 'LineWidth', 2, 'DisplayName', labels{7});
plot(time, sim(i).phasic, '--', 'Color', colors(8,:), 'LineWidth', 1.5, 'DisplayName', 'Ground Truth Phasic');
xlabel('Time [s]', 'FontSize', 16, 'FontWeight', 'bold');    
ylabel('EDA [μS]', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'YColor', 'k', 'GridAlpha', 0.3, 'FontSize', 14);
legend('Location', 'Northeast', 'FontSize', 14);
yyaxis right;
bar(time, sim(i).driver, 'DisplayName', 'Stimuli', 'BarWidth',4);
ylim([0 1]); 
ylabel('Stimuli Level', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'YTick', 0:1);

%% Driver Comparison
figure('Position',[100 100 1430 350],'Color','w');
hold on; grid on; box on;
stem(time, all_signals.osp.driver(i,:), 'LineWidth', 2, 'DisplayName', labels{7});
stem(time, sim(i).driver, 'LineWidth', 2, 'DisplayName', 'Ground Truth Driver');
xlabel('Time [s]', 'FontSize', 16, 'FontWeight', 'bold');    
ylabel('EDA [μS]', 'FontSize', 16, 'FontWeight', 'bold');
set(gca, 'GridAlpha', 0.3, 'FontSize', 14, 'YColor', 'k');
legend('Location', 'Northeast', 'FontSize', 14);