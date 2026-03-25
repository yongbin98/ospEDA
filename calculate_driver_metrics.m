function [TP, TN, FP, FN, f1, precision, recall, amp_MAE] = calculate_driver_metrics(p_est, p_true, fs, tol_sec)
% Calculate event-based detection metrics for sparse driver signals
%
% Inputs:
%   p_est    : estimated driver, Nx1
%   p_true   : ground-truth driver, Nx1
%   fs       : sampling frequency (Hz)
%   tol_sec  : matching tolerance in seconds
%
% Outputs:
%   TP, TN, FP, FN
%   f1, precision, recall
%   amp_MAE  : amplitude MAE for matched true-positive events only

    % Ensure column vectors
    p_est  = p_est(:);
    p_true = p_true(:);

    if length(p_est) ~= length(p_true)
        error('p_est and p_true must have the same length.');
    end

    tol = round(tol_sec * fs);

    % Event indices
    true_idx = find(p_true > 0);
    [~, est_idx] = findpeaks(p_est, 'MinPeakHeight', 0.01);
    
    % Initialize tracking variables
    TP = 0;
    matched_pairs = []; 

    % Handle edge case: No ground truth events
    if isempty(true_idx)
        FP = length(est_idx);
        FN = 0;
        TN = length(p_true) - FP;
        precision = 0; 
        recall    = 0;
        f1        = 0;
        amp_MAE   = NaN;
        return;
    end

    % 3. Event Matching
    matched_est = false(length(est_idx), 1);

    for t = 1:length(true_idx)
        t_idx = true_idx(t);
        
        valid_inds = find(abs(est_idx - t_idx) <= tol);        
        valid_inds = valid_inds(~matched_est(valid_inds));
        
        if ~isempty(valid_inds)
            candidate_values = p_est(est_idx(valid_inds));

            [~, max_relative_idx] = max(candidate_values);
            best_est_ind = valid_inds(max_relative_idx);
            
            TP = TP + 1;
            matched_est(best_est_ind) = true; % Mark as used
            matched_pairs = [matched_pairs; est_idx(best_est_ind), t_idx];
        end
    end

    % 4. Calculate Final Metrics
    FP = sum(~matched_est);
    FN = length(true_idx) - TP;
    
    TN = NaN;

    % Calculate classification metrics
    precision = TP / (TP + FP + eps);
    recall    = TP / (TP + FN + eps);
    f1        = 2 * precision * recall / (precision + recall + eps);

    % Calculate Amplitude MAE only on strictly matched pairs
    if isempty(matched_pairs)
        amp_MAE = NaN;
    else
        amp_errors = abs(p_est(matched_pairs(:,1)) - p_true(matched_pairs(:,2)));
        amp_MAE = mean(amp_errors);
    end
end