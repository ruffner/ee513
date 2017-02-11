%  This script simulates a tone (ring) with a Rayleigh envelope.  The
%  signal is truncated and the FFT is taken in order to examine its
%  spectral content.  The script can be used to study the effects of
%  zero padding, signal truncation, and signal duration on the estimated
%  spectrum.
%  
%   written by Kevin D. Donohue (donohue@engr.uky.edu) June 2002

fr = 250;   %  Frequency of the ring
sigma = .05;  % effective duration TIMES 2 of ring
fs = 8000;  %  Sampling frequency 
dur = .25;  % signal duration in seconds
nfft = 4096;
t = [0:round(dur*fs)-1]/fs;  %  Create time axis
ring = (t/sigma).*exp((-t.^2)/(sigma^2)).*sin(2*pi*t*fr);  % Generate Ring signal

figure(1)    
plot(t, ring) %  Plot ring
title('Rayleigh Envelope Ring Signal')
xlabel('Seconds')
ylabel('Amplitude')
soundsc(ring,fs) %  Play sound
spec0 = fft(ring);  %  No Zero pad
spec1 = fft(ring,nfft);  %  Zero pad (or truncate) to NFFT points
spec2 = fft(ring,2*nfft); %  Zero pad to 2*NFFT

%  Create frequency axes for each of the spectra
faxis0 = fs*[0:length(spec0)-1]/length(spec0); 
faxis1 = fs*[0:length(spec1)-1]/length(spec1);
faxis2 = fs*[0:length(spec2)-1]/length(spec2);
%  Plot spectrum with zero padded versions on the same graph and compare
figure(2)  % Magnitude
plot(faxis0, abs(spec0),'k',faxis1, abs(spec1),'r--',faxis2, abs(spec2),'g.')
legend([int2str(length(t)) ' point FFT'], [int2str(nfft) ' point FFT'], [int2str(2*nfft) ' point FFT']) 
title('Magnitude ffts with zero padding')
xlabel('Hertz')
ylabel('Magnitude')

figure(3) % Phase
plot(faxis0, 180*phase(spec0)/pi,'k',faxis1, 180*phase(spec1)/pi,'r--',faxis2, 180*phase(spec2)/pi,'g.')
legend([int2str(length(t)) ' point FFT'], [int2str(nfft) ' point FFT'], [int2str(2*nfft) ' point FFT']) 
title('Phase ffts with zero padding')
xlabel('Hertz')
ylabel('Degrees')
