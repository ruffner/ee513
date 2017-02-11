% hw 2 problem 3

fs=4000; %sampling rate
fstart=256; % in hz
ndur = 500; % in ms
outfile='temp.wav';
sig = minor_p( fstart, ndur, fs, outfile ); % make scale

% Spectrogram Parameters 
% taken from Dr. Donohue's spectoex.m file
wlen = 256;             %  Length of actual point extracted from signal segment
nfft = wlen;            %  number of FFT point (zero padding)
olap = floor(wlen/2);   %  Points of overlap between segments
wn = hamming(wlen);    % Create tapering window (also try boxcar - square window)

%  Create Spectrogram
[b,faxis,taxis] = spectrogram(sig,wn,olap,nfft,fs);
%  Plot over time and frequency

figure(1)    
imagesc(taxis, faxis, 20*log10(abs(b))) %  Plot spectrogram
axis('xy')  %  Flip y axis to put zero Hz on bottom
colorbar   %  Include colorbar to determine color coded magnitudes on graph
title(['Spectrogram of 2 octave pentatonic scale starting at 256Hz'])
xlabel('Seconds')
ylabel('Hz')

% Spectrogram Parameters 
% taken from Dr. Donohue's spectoex.m file
wlen = 256;             %  Length of actual point extracted from signal segment
nfft = wlen*4;            %  number of FFT point (zero padding)
olap = floor(wlen/2);   %  Points of overlap between segments
wn = hamming(wlen);    % Create tapering window (also try boxcar - square window)

%  Create Spectrogram
[b,faxis,taxis] = spectrogram(sig,wn,olap,nfft,fs);
%  Plot over time and frequency

figure(2)    
imagesc(taxis, faxis, 20*log10(abs(b))) %  Plot spectrogram
axis('xy')  %  Flip y axis to put zero Hz on bottom
colorbar   %  Include colorbar to determine color coded magnitudes on graph
title(['Spectrogram of 2 octave pentatonic scale starting at 256Hz'])
xlabel('Seconds')
ylabel('Hz')
