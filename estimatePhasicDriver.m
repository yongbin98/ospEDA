function driver = estimatePhasicDriver(phasic, fs, tau1, tau2, lambda, kernel_duration)
% Estimate sparse phasic driver from phasic component using deconvolution
%
% Inputs:
% phasic - [T x 1] vector: phasic component signal
% fs - scalar: sampling frequency in Hz
%
% Output:
% driver - [T x 1] vector: estimated phasic driver (non-negative)

% Ensure phasic is a column vector
phasic = phasic(:);
T = length(phasic); % signal length

% Create time vector for kernel
t = (0:1/fs:kernel_duration)';
t(end) = [];

% Bi-exponential impulse response (SCR kernel)
h = (exp(-t / tau1) - exp(-t / tau2));
h = h / sum(h); % normalize

% Construct convolution matrix H (Toeplitz)
h_len = length(h);
H = zeros(T, T);

for i = 1:T
    for j = 1:min(h_len, T - i + 1)
        H(i + j - 1, i) = h(j);
    end
end

% Debug: Check dimensions
% fprintf('Debug - Matrix dimensions:\n');
% fprintf('  phasic: %d x %d\n', size(phasic, 1), size(phasic, 2));
% fprintf('  H: %d x %d\n', size(H, 1), size(H, 2));
% fprintf('  H'': %d x %d\n', size(H', 1), size(H', 2));

% Verify dimensions match for multiplication
if size(H', 2) ~= size(phasic, 1)
    error('Dimension mismatch: H'' has %d columns but phasic has %d rows', ...
          size(H', 2), size(phasic, 1));
end

% Optimization: minimize ||H * p - r||^2 + lambda * ||p||_1
% We'll use quadratic programming: 1/2 p'Qp + f'p subject to p >= 0
Q = 2 * (H' * H + lambda * eye(T));
f = -2 * H' * phasic;

% Lower bound: p >= 0
lb = zeros(T, 1);

% Check if Optimization Toolbox is available
if exist('quadprog', 'file') == 2
    % Solve using quadprog (requires Optimization Toolbox)
    options = optimoptions('quadprog', 'Display', 'off');
    try
        driver = quadprog(Q, f, [], [], [], [], lb, [], [], options);
    catch ME
        warning('quadprog failed: %s.');
    end
else
    warning('Optimization Toolbox not available. Using alternative solver.');
    driver = alternativeSolver(Q, f, lb);
end

% Ensure output is column vector
driver = driver(:);

% 1. Apply amplitude threshold
threshold = 1e-2; % Keep only top 10%
driver(driver < threshold) = 0;
% 2. Apply minimum distance constraint
dmin = 10 * fs; % 2 seconds minimum distance
[peaks, locs] = findpeaks(driver, 'MinPeakHeight', threshold, 'MinPeakDistance', dmin);
driver_sparse = zeros(size(driver));
driver_sparse(locs) = peaks;

driver = driver_sparse;

end