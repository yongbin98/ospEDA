clear all
close all
clc

load('Results_simulated_20dB.mat');

num_signals = 100;
methods = {'cda', 'dda', 'cvx', 'sparse', 'bayesian', 'udm', 'osp'};
num_metrics = 15;

for i = 1:num_signals    
    sub_idx = i;
    
    EDA = sim(i).eda;
    fs = 4;
    time = 0:1/fs:300; time(1) = [];
        
    %% CDA
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.cda.phasic(i,:), all_signals.cda.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.cda.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.cda(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];  

    %% DDA
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.dda.phasic(i,:), all_signals.dda.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.dda.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.dda(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];  
    
    %% CVX
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.cvx.phasic(i,:), all_signals.cvx.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.cvx.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.cvx(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];  
    
    %% Sparse
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.sparse.phasic(i,:), all_signals.sparse.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.sparse.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.sparse(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];  
    
    %% Bayesian
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.bayesian.phasic(i,:), all_signals.bayesian.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.bayesian.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.bayesian(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];  

    %% UDM
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.udm.phasic(i,:), all_signals.udm.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.udm.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.udm(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];  

    %% OSP
    [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2] = calculate_signal_metrics(all_signals.osp.phasic(i,:), all_signals.osp.tonic(i,:), sim(i).phasic, sim(i).tonic);
    [TP, TN, FP, FN, f1, prec, rec, amp_MAE] = calculate_driver_metrics(all_signals.osp.driver(i,:), sim(i).driver, fs, 1.0);
    all_metrics.osp(i, :) = [mae_p, mae_t, rmse_p, rmse_t, corr_p, corr_t, R2, TP, TN, FP, FN, f1, prec, rec, amp_MAE];

end

%% --- 3. CALCULATE AVERAGES AND DISPLAY SUMMARY ---
fprintf('\n=== FINAL RESULTS (AVERAGED OVER %d SIGNALS) ===\n', num_signals);

fprintf('\nTABLE I: SIGNAL RECONSTRUCTION METRICS\n');
fprintf('%-10s | %-13s | %-13s | %-13s | %-13s\n', ...
        'Method', 'RMSE(T)', 'RMSE(P)', 'Corr(P)', 'R2');
fprintf(repmat('-', 1, 70));
fprintf('\n');

avg_results = struct();
std_results = struct();

for m = 1:length(methods)
    method_name = methods{m};

    % Calculate the mean AND standard deviation
    avg_results.(method_name) = mean(all_metrics.(method_name), 1, 'omitnan');
    std_results.(method_name) = std(all_metrics.(method_name), 0, 1, 'omitnan');

    % Extract Means (3:rmse_p, 4:rmse_t, 5:corr_p, 7:R2)
    m_rmse_p = avg_results.(method_name)(3);
    m_rmse_t = avg_results.(method_name)(4);
    m_corr_p = avg_results.(method_name)(5);
    m_r2     = avg_results.(method_name)(7);

    % Extract Standard Deviations
    s_rmse_p = std_results.(method_name)(3);
    s_rmse_t = std_results.(method_name)(4);
    s_corr_p = std_results.(method_name)(5);
    s_r2     = std_results.(method_name)(7);

    % Format as "Mean±Std"
    str_rmse_p = sprintf('%.3f±%.3f', m_rmse_p, s_rmse_p);
    str_rmse_t = sprintf('%.3f±%.3f', m_rmse_t, s_rmse_t);
    str_corr_p = sprintf('%.3f±%.3f', m_corr_p, s_corr_p);
    str_r2     = sprintf('%.3f±%.3f', m_r2, s_r2);

    fprintf('%-10s | %-13s | %-13s | %-13s | %-13s\n', ...
            upper(method_name), str_rmse_t, str_rmse_p, str_corr_p, str_r2);
end
fprintf(repmat('-', 1, 70));
fprintf('\n');

fprintf('\nTABLE II: DRIVER IMPULSE DETECTION METRICS\n');
fprintf('%-10s | %-13s | %-13s | %-13s\n', ...
        'Method', 'F1 Score', 'Precision', 'Recall');
fprintf(repmat('-', 1, 70));
fprintf('\n');

for m = 1:length(methods)
    method_name = methods{m};

    m_f1      = avg_results.(method_name)(12);
    m_prec    = avg_results.(method_name)(13);
    m_rec     = avg_results.(method_name)(14);

    s_f1      = std_results.(method_name)(12);
    s_prec    = std_results.(method_name)(13);
    s_rec     = std_results.(method_name)(14);

    str_f1   = sprintf('%.3f±%.3f', m_f1, s_f1);
    str_prec = sprintf('%.3f±%.3f', m_prec, s_prec);
    str_rec  = sprintf('%.3f±%.3f', m_rec, s_rec);

    fprintf('%-10s | %-13s | %-13s | %-13s\n', ...
            upper(method_name), str_f1, str_prec, str_rec);
end
fprintf(repmat('-', 1, 70));
fprintf('\n');
