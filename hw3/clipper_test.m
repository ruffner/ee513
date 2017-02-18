%% clipper.m test script
% matt ruffner
% clips a unit sinusoid  to +/-0.75 and estimates the THD

wlen=128;
wn=hamming(wlen);

dur=5;
fs=8e3; % sampling rate
fsig=440; % sinusoid frequency
t=(0:fs)./fs; % time axis
sig=cos(2*pi*fsig.*t); % sinusoid to clip

lim=[-0.75 0.75];

sigout=clipper(sig, lim);

figure(1)
plot(t,sig,'b', t,sigout, 'r')
title('Sinusoid before and after clipping')
xlabel('Time');
ylabel('Amplitude');
legend('Before clipping', 'After clipping');

figure(2);
[pun,fx] = pwelch(sig,wn,wlen/2,2*wlen,fs); % take psd of unclipped signal
[pcl,fx] = pwelch(sigout,wn,wlen/2,2*wlen,fs); % take psd of clipped signal
plot(fx, pun, 'b', fx, pcl, 'r'); % examine amplitude of spectrum
title('PSD of Clipped and Unclipped Signals');
xlabel('Frequency');
ylabel('Amplitude (dB)');
legend('Unclipped', 'Clipped');

figure(3)
pwelch(sig,wn,wlen/2); % take psd of unclipped signal
figure(4)
pwelch(sigout,wn,wlen/2); % take psd of clipped signal