%  This script simulates reverberation on a recorded clap sound
%  and demonstrates using the hilbert transform to estimate the 
%  signal envelope and the resulting RT60 time and the AC to identify 
%  the reverberation delays from the data.
%
%    This script requires mfiles mrevera, preverb, areverb
%    and data file clap.wav
%
%   Written by Kevin D. Donohue March 2003 (donohue@engr.uky.edu)

%  Create reverb signal
[y,fs] = audioread('clap.wav');  %  Read in Clap sound
%  Apply simulated reverb signal (delays at 30, 44, and 121 ms, with
%                                 corresponding to attenuation
%                                 coefficients .6 .8 and .6).
yout1 = mrevera(y, fs, [30 44 121]*1e-3, [.6 .8 .6]);
taxis = [0:length(yout1)-1]/fs;
%  Compute envelope of signal
env = abs(hilbert(yout1));
figure(1)
plot(taxis,20*log10(env+eps))   %  Plot Power over  time
hold on
%  Create Line at 60 dB below max point and look for intersection point
mp = max(20*log10(env+eps));
mp = mp(1);
dt = mp-60;
plot(taxis,dt*ones(size(taxis)),'r');   hold off; xlabel('Seconds')
ylabel('dB');  title('Envelope of Room Impulse Response')

%  Compute autocorrelation function of envelop and look for peaks %  to  indicate delay of major echoes
maxlag = fix(fs*.5);
[ac, lags] = xcorr(env-mean(env), maxlag);
figure(2)
plot(lags/fs,ac)
xlabel('seconds')
ylabel('AC coefficient')
%  Compute autocorrelation function of raw and look for peaks to
%  indicate delay of major echoes
[ac, lags] = xcorr(yout1, maxlag);
figure(3)
plot(lags/fs,ac)
xlabel('seconds')
ylabel('AC coefficient')