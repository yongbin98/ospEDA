function [mae_phasic, mae_tonic, rmse_phasic, rmse_tonic, corr_phasic, corr_tonic, R2] = calculate_signal_metrics(phasic_est, tonic_est, phasic_true, tonic_true)

    phasic_est = phasic_est(:);
    tonic_est = tonic_est(:);
    phasic_true = phasic_true(:);
    tonic_true = tonic_true(:);
    
    rmse_phasic = sqrt(mean((phasic_est - phasic_true).^2));
    rmse_tonic = sqrt(mean((tonic_est - tonic_true).^2));

    corr = corrcoef(phasic_est, phasic_true);
    corr_phasic = corr(1,2);

    corr = corrcoef(tonic_est, tonic_true);
    corr_tonic = corr(1,2);

    mae_phasic = mean(abs(phasic_est - phasic_true));
    mae_tonic = mean(abs(tonic_est - tonic_true));

    y_true = phasic_true + tonic_true;
    y_pred = phasic_est + tonic_est;
    
    SS_res = sum((y_true - y_pred).^2);
    SS_tot = sum((y_true - mean(y_true)).^2);
    
    R2 = 1 - SS_res / SS_tot;
end