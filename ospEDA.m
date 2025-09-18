function [tonic_osp, driver_osp, phasic_osp, lag] = ospEDA(EDA, sr, varargin)
%   EDA signal decomposition method using Orthogonal Subspace Projection (OSP)
%   [tonic_osp, driver_osp, phasic_osp] = ospEDA(EDA, sr, varargin)
%   
%   Decomposes electrodermal activity (EDA) signal into tonic and phasic
%   components using optimized spline peak method.
%
%   INPUTS:
%   EDA      - EDA signal vector
%   sr       - Sampling rate (Hz)
%   varargin - Optional parameters [tau1, tau2, lambda, kernel_duration, prominence, dist, pct]
%              Default: [2, 0.7, 1e-2, 10, 1e-1, 10, 5]
%
%   OUTPUTS:
%   tonic_osp  - Tonic (slow-varying baseline) component
%   driver_osp - Estimated phasic driver signal
%   phasic_osp - Phasic (fast-varying response) component
%   lag - number of delayed samples

    %% Parse input arguments
    % Default parameters: [tau1, tau2, lambda, kernel_duration, prominence, dist, pct]
    params = {2, 0.7, 1e-2, 10, 5e-2, 10, 5};
    
    % Override defaults with provided arguments
    i = ~cellfun(@isempty, varargin);
    params(i) = varargin(i);
    [tau1, tau2, lambda, kernel_duration, prominence, dist, pct] = deal(params{:});
    
    %% Preprocessing: Downsample and detrend
    fs = 4; % Target sampling frequency
    deci_rate = floor(sr/fs);
    EDA_ds = decimate(EDA, deci_rate);
    EDA_detrended = detrend(EDA_ds, 2); % Remove quadratic trends
    
    t_ds = (0:length(EDA_ds)-1) / fs;

    %% Valley detection
    % Find valleys (negative peaks) in detrended signal
    [~, locs_ds] = findpeaks(-EDA_detrended, ...
                         'MinPeakProminence', prominence, ...
                         'MinPeakDistance', fs*dist);
    
    %% Local valley detection
    window_duration = 30;
    window_samples = window_duration * fs;
    num_windows = floor(length(EDA_detrended) / window_samples);
    
    new_locs = [];
    
    for i = 1:num_windows
        % Define window boundaries
        ST = (i-1) * window_samples + 1;
        ED = i * window_samples; % Handle last window
        
        % Check if this window already has detected peaks
        has_peak_in_window = any(locs_ds >= ST & locs_ds <= ED);
        
        if ~has_peak_in_window
            % No peak found in this window, find local minimum
            if ST <= length(EDA_detrended) % Ensure valid window
                window_data = EDA_detrended(ST:ED);
                [~, auto_locs] = min(window_data);
                absolute_loc = auto_locs + ST - 1;
                % absolute_loc = round((ST+ED)/2);
                new_locs = [new_locs, absolute_loc];
            end
        end
    end    
        
    % Add boundary conditions
    if ~isempty(locs_ds) && locs_ds(1) > fs*10
        new_locs = [1, new_locs];
    end
    if ~isempty(locs_ds) && (length(EDA_detrended) - locs_ds(end)) > fs*10
        new_locs = [new_locs, length(EDA_detrended)];
    end
    
    % Combine and sort all locations
    all_locs_ds = [locs_ds(:)', new_locs];
    locs_ds = sort(unique(all_locs_ds));
    
    min_distance = fs * 10;
    
    i = 1;
    while i < length(locs_ds)
        if (locs_ds(i+1) - locs_ds(i)) < min_distance
            locs_ds(i+1) = [];
        else
            i = i + 1;
        end
    end    
    
    peak_times = t_ds(locs_ds);
    locs = round(peak_times * sr) + 1;

    %% Spline interpolation and OSP decomposition
    x_fine = (1:1:length(EDA))';
    y_spline = spline(locs, EDA(locs), x_fine);   
    [tonic_osp, phasic_osp, lag] = osp_decomposition(EDA, y_spline, sr);

    %% Baseline correction
    alpha = -prctile(phasic_osp, pct);
    tonic = tonic_osp - alpha;
    phasic = EDA(lag+1:end) - tonic;
        
    %% Estimate phasic driver
    driver = estimatePhasicDriver(phasic, fs, tau1, tau2, lambda, kernel_duration);
    tonic_osp = [zeros(lag); tonic(:)];
    phasic_osp = [zeros(lag); phasic(:)];
    driver_osp = [zeros(lag); driver(:)];
end