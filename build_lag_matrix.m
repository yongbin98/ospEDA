function V = build_lag_matrix(ref, m)
    ref = ref(:);
    N   = length(ref);

    V = zeros(N-m, m+1);

    for i = 0:m
        V(:, i+1) = ref((1+m-i):(N-i));
    end
end