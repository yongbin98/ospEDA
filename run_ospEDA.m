clear all; close all; clc;
addpath('ospEDA\');
load('Results_simulated_20dB.mat');

eda_4hz = sim(11).eda;
fs_eda = 4;
[tonic, driver, phasic] = ospEDA(eda_4hz, fs_eda);
tonic_osp = tonic(:);
driver_osp = driver(:);
phasic_osp = phasic(:);
