% TEST SCRIPT FOR DIGOSC FUNCTION
% Matt Ruffner
% EE513 Spring 2017
% Project 2

fs=16000; % sampling frequency

del=[1 zeros(1,fs-1)]; % delta pulse to input energy

amps=[2 4 2 1 1.5]; % input vector to digosc function of relative amplitudes
fos=[100 150 500 50 250]; % input vector to digosc of frequencies to create

[af,bf] = digosc(fos,amps,fs); % create tf

ff=filter(af, bf, del); % convolve with delta

% plot impulse response in time domain
[r1,t1]=impz(ff);
figure(1)
plot(t1,r1,'r')
title('Time domain representation of $$H(z)=\frac{Y(z)}{X(z)}$$', 'Interpreter', 'Latex');
xlabel('Time');
ylabel('Amplitude');

fax = fs*((0:fs-1)/fs);
fff=fft(ff);
figure(2)
semilogx((fax),abs(fff))
xlim([0 fs/2]);
title('Frequency domain representation of  $$H(z)=\frac{Y(z)}{X(z)}$$', 'Interpreter', 'Latex');
