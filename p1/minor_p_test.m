%% minor_p_test.m - create and play a scale using minor_p.m 
% Matt Ruffner
% EE513 Spring 2017

% parameters for minor_p
fs=8000;    % sampling frequency
ndur=200;   % in ms
fbegin=220; % start note
outfile='mp.wav';

minor_p( fbegin, ndur, fs, outfile ); % generate scales and write to file

sig=audioread(outfile);

soundsc(sig, fs); % play scales