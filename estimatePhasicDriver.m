function driver = estimatePhasicDriver(phasic, fs, tau1, tau2, lambda, kernel_duration)

phasic = phasic(:);
T = length(phasic);

t = (0:1/fs:kernel_duration)';
t(end) = [];

h = (exp(-t / tau1) - exp(-t / tau2));
h = h / sum(h);

h_len = length(h);
H = zeros(T, T);

for i = 1:T
    for j = 1:min(h_len, T - i + 1)
        H(i + j - 1, i) = h(j);
    end
end

Q = 2 * (H' * H + lambda * eye(T));
f = -2 * H' * phasic;

lb = zeros(T, 1);
driver = quadprog(Q, f, [], [], [], [], lb);
driver = driver(:);

threshold = 1e-2;
driver(driver < threshold) = 0;
dmin = 10 * fs;
[peaks, locs] = findpeaks(driver, 'MinPeakHeight', threshold, 'MinPeakDistance', dmin);
driver_sparse = zeros(size(driver));
driver_sparse(locs) = peaks;

driver = driver_sparse;

end