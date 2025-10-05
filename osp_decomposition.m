function [tonic_osp, phasic_osp, lag] = osp_decomposition(eda, ref, sr)
    eda = eda(:);
    ref = ref(:);

    lag = select_model_order(eda, ref, sr);
    V = build_lag_matrix(ref, lag);
    Y = eda(lag+1:end);

    if(rcond(V' * V) < 1e-8)
        lambda = 0.01;
        P = V * ((V' * V+ lambda * eye(size(V,2))) \ V');
    else
        P = V * ((V' * V) \ V');
    end
    
    interference = P * Y;

    phasic_osp = Y - interference;

    tonic_osp = interference;
end