%  This script simulates a frequency sweep signal and takes its spectrogram
%  to examine its spectral content changes over time, and compares spectrogram
%  result to the FFT of the whole sweep signal.  In addition, parameters
%  and settings such as zero padding, window size window shape, window
%  overlap, as well as signal characteristics can be changed to observe
%  effects.
%
%   written by Kevin D. Donohue (donohue@engr.uky.edu) October 2006

% Signal Parameters
flow = 20;   %  Starting frequency of sweep in Hertz
fend = 1900; %  Ending frequency of sweep in Hertz
dt = 8;  % Time duration of sweep in seconds
fs = 8000;  %  Sampling frequency 

% Spectrogram Parameters
wlen = 128;             %  Length of actual point extracted from signal segment
nfft = wlen*2;            %  number of FFT point (zero padding)
olap = floor(wlen/2);   %  Points of overlap between segments
wn = hamming(wlen);    % Create tapering window (also try boxcar - square window)
%wn = kaiser(wlen,10);    % Create tapering window (also try boxcar - square window)

%  Generate signal
t = [0:round(dt*fs)-1]/fs;  %  Create time axis
fsw = flow + ((fend-flow)/2)*[0:length(t)-1]/length(t);  %  Create Frequency ramp 
swp = sin(2*pi*t.*fsw);  % Generate sweep signal
%soundsc(swp,fs) %  Play sound 

%  Create Spectrogram
[b,faxis,taxis] = spectrogram(swp,wn,olap,nfft,fs);
%  Plot over time and frequency
figure(1)    
imagesc(taxis, faxis, 20*log10(abs(b))) %  Plot spectrogram
axis('xy')  %  Flip y axis to put zero Hz on bottom
colorbar   %  Include colorbar to determine color coded magnitudes on graph
 title(['Frequency Sweep from ' num2str(flow) ' Hz to ' num2str(fend) ' Hz'])
 xlabel('Seconds')
 ylabel('Hz')
 %  Just plot at a single time instant
 figure(2)
 tindex = find(taxis >= dt/2);  %Find index of halfway point over the time axis
 tindex = tindex(1);
 plot(faxis,abs(b(:,tindex)))
 title(['Single column from Spectrogram at ' num2str(taxis(tindex)) ' seconds'])
 xlabel('Hz')
 ylabel('Magnitude')
 %  Take FFT of whole frequency sweep and display spectrum (may take a 
 %  while to compute, so you should comment out these lines if just
 %  experimenting with Spectrogram).
 figure(3)
 len = length(swp);  %  get length of entire sweep
 nfft2 = 2^nextpow2(2*len);     % Double signal length and padd to next power of 2
 spec = fft(swp,10*nfft2);   %  take FFT
 fftax = fs*[0:nfft2-1]/nfft2;  %  create frequency axis
 plot(fftax(1:fix(nfft2/2)),abs(spec(1:fix(nfft2/2))))
 title(['Spectrum over whole signal'])
 xlabel('Hz')
 ylabel('Magnitude')
 