% TEST SCRIPT FOR DIGOSC FUNCTION
% Matt Ruffner
% EE513 Spring 2017
% Project 2

fs=8000; % sampling frequency

del=[1 zeros(1,fs-1)]; % delta pulse to input energy

amps=[2 1]; % input vector to digosc function of relative amplitudes
fos=[20 21]; % input vector to digosc of frequencies to create

[af,bf] = digosc(fos,amps,fs); % create tf

ff=filter(af, bf, del); % convolve with delta

[r1,t1]=impz(ff);

plot(t1,r1,'r')