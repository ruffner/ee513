function [a,b] = digosc(freqs, amps, fs)
%% DIGOSC - create a transfer function whos impulse response resonates at
% the specified frequencies and corresponding amplitudes,
% relative to the specified sampling frequency.
%
% Matt Ruffner
% EE513 Spring 2017
% Project 2
%
% INPUTS
%   freqs -> vector containing desired frequencies
%   amps  -> vector containing desired amplitudes of frequencies in 'freqs'
%   fs    -> desired sampling frequency
%
% OUTPUTS
%   a     -> the denominators of the resulting transfer function
%   b     -> the numerator of the resulting transfer function
%
% EXAMPLE
%  create a TF who's impulse response resonates at 10Hz and 20Hz
%  where the 20Hz wave has twice the amplitude, sampled at 8kHz:
%
%  >> [a,b] = digosc( [10 20], [1 2], 8000); 

% must have matching input vector lengths
if length(freqs) ~= length(amps)
    error('size mismatch between frequency and amplitude input vectors');
end

nfreqs=length(freqs); % number of frequencies we are working with

% normalize TF coeffecients so input amplitude corresponds directly to output 
%ampscales=(freqs.*2*pi)/fs; 

% vector representing coeffecients for normalizing
% the calculation of frequencies and amplitudes
alphas=(2*pi.*freqs)/fs;

% where the TF of the digital oscillator is
% (k*z^2) / (z^2 - 2*cos(alpha)*z + 1)

% calculate numerators
bs=[]; % vector to hold numerators
counter=1;
for n=amps
    bs=[bs; alphas(counter)*n 0 0]; % multiply coefficient for z^2 term by desired amplitude
    counter=counter+1;
end

% calculate denominators
as=[]; % vector to hold denominators
for n=alphas
    % create denominators based on calculated alpha values
    as=[as; 1 -2*cos(n) 1];
end


% convert b/a num/denom coeffs to dfilt objects
dfilts = [];
for n=1:nfreqs
   % build vector of direct form 1 representations
   dfilts=[dfilts, dfilt.df1(bs(n,1:end), as(n,1:end))]; 
end

% parallelize the individual transfer functions
fdf=dfilt.parallel(dfilts);

% extract the state space variables of the parallelized TFs
[A,B,C,D]=fdf.ss;

% use ss2tf to convert to one TF with unified numerators and denominators
[a,b]=ss2tf(A, B, C, D);


