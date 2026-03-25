%% cvxEDA-style simulated EDA signal
clear; clc; close all;

for i = 1:100 % 100 subjects
    rng(i)

    tau1 = 0.7;             % fixed fast time constant [s]
    tau0 = 2 + (4-2)*rand;  % random slow time constant in [2,4] s

    fs = 4;                 % sampling frequency [Hz]
    T = 300;                % signal length [s]
    t = (0:1/fs:T-1/fs)';   % time vector
    N = length(t);
    Tt = 60 + 60*rand;      % tonic sinusoid period in [45,90] s

    nPulses = 30;           % number of sparse driver impulses
    minDistSec = 2;         % minimum spacing between impulses [s]
    edgeMarginSec = 2;      % minimum distance from both ends [s]

    snr_dB = 10;            % Noise Level (choose 30, 20, 10 dB)

    %% 1) Generate sparse driver (ground truth impulses)
    driver = zeros(N,1);
    
    candidateIdx = round((edgeMarginSec*fs+1):((T-edgeMarginSec)*fs));
    selectedIdx = [];
    
    while numel(selectedIdx) < nPulses
        idx = candidateIdx(randi(numel(candidateIdx)));
        if isempty(selectedIdx) || all(abs(idx - selectedIdx) >= minDistSec*fs)
            selectedIdx(end+1) = idx; %#ok<SAGROW>
        end
    end
    
    selectedIdx = sort(selectedIdx);
    driver(selectedIdx) = 0.01 + 0.99 * rand(nPulses, 1);
    
    %% 2) Build bi-exponential SCR impulse response
    tk = (0:1/fs:20)';  
    h = exp(-tk/tau0) - exp(-tk/tau1);
    h = h / max(h);     
    
    %% 3) Generate phasic component
    phasic_full = conv(driver, h);
    phasic = phasic_full(1:N);
    
    %% 4) Generate tonic component
    offset = 3.0 + 3.0*rand;               
    slope = 2.0 * (2*rand-1);              
    ampTonic = 0.1 + 0.4*rand;            
    phaseTonic = 2*pi*rand;    
    tonic = offset + slope*(t/T) + ampTonic*sin(2*pi*t/Tt + phaseTonic);
    
    %% 5) Add AWGN at chosen SNR
    cleanEDA = tonic + phasic;

    signalPower = mean((cleanEDA - mean(cleanEDA)).^2);
    noisePower = signalPower / (10^(snr_dB/10));
    noise = sqrt(noisePower) * randn(N,1);
    
    eda = cleanEDA + noise;

    sim(i).eda = eda;
    sim(i).tonic = tonic;
    sim(i).phasic = phasic;
    sim(i).noise = noise;
    sim(i).driver = driver;

    figure('Color','w','Position',[100 100 900 700]);
    subplot(4,1,1);
    plot(t, eda - noise, 'LineWidth',1.5);
    ylabel('EDA');
    title('raw EDA without noise');
    grid on; xlim([0 T]);

    subplot(4,1,2);
    plot(t, phasic, 'LineWidth',1.5);
    ylabel('Phasic');
    title('Ground-truth phasic component');
    grid on; xlim([0 T]);

    subplot(4,1,3);
    plot(t, tonic, 'LineWidth',1.5);
    ylabel('Tonic');
    title('Ground-truth tonic component');
    grid on; xlim([0 T]);

    subplot(4,1,4);
    plot(t, eda, 'k', 'LineWidth',1.2); hold on;
    plot(t, cleanEDA, '--', 'LineWidth',1.0);
    xlabel('Time [s]');
    ylabel('EDA');
    title(sprintf('Simulated EDA (SNR = %d dB)', snr_dB));
    legend('Noisy EDA','Clean EDA');
    grid on; xlim([0 T]);

end
