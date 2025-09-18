function [tonic_osp, phasic_osp, lag] = osp_decomposition(eda, ref, sr)
    % eda: raw EDA signal (target to clean)
    % ref: reference signal(s) (tonic components)
    eda = eda(:);
    ref = ref(:);

    % Build lag matrix from reference signal
    lag = select_model_order(eda, ref, sr);
    V = build_lag_matrix(ref, lag);
    Y = eda(lag+1:end); % target signal aligned with delay matrix
    
    % reciprocal condition
    if(rcond(V' * V) < 1e-8)
        lambda = 0.01;
        P = V * ((V' * V+ lambda * eye(size(V,2))) \ V');
    else
        P = V * ((V' * V) \ V');
    end
    
    % Project EDA onto interference subspace
    interference = P * Y;

    % Extract Phasic Component
    phasic_osp = Y - interference;

    % reconstruct tonic component
    tonic_osp = interference;
end