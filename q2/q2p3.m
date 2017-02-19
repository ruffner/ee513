% EE5513 Quiz 2 Part 3
% Matt Ruffner

[sig,fs] = audioread('HRActivess8000.wav'); 

wlen=256; % window length
wn=hamming(wlen); % create hamming window

% analyze data from 65 to 75 seconds
fpos=58*fs; 
lpos=60*fs;

figure(1)
spectrogram(sig(fpos:lpos),wn,wlen/2,1024,fs) % 1024 fft points
