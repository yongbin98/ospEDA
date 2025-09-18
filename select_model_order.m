function optimal_m = select_model_order(Y, X, max_delay)
    N = length(Y);
    MDL = zeros(max_delay+1, 1);

    for m = 0:max_delay
        V = zeros(N-m, m+1);
        for d = 0:m
            V(:, d+1) = X(m - d + 1 : N - d);
        end
        y = Y(m+1:N);
        
        if(rcond(V' * V) < 1e-8)
            lambda = 0.01;
            P = V * ((V' * V+ lambda * eye(size(V,2))) \ V');
        else
            P = V * ((V' * V) \ V');
        end

        y_residual = y - P * y;

        sigma_sq = sum(y_residual.^2) / (N - m);
        num_params = m + 1;
        MDL(m+1) = (N - m) * log(sigma_sq) + num_params * log(N - m);
    end

    [~, optimal_m_MDL] = min(MDL);

    optimal_m = optimal_m_MDL - 1;
end