function [notes] = minor_p( sfreq, ndur, fs, fname )
%% minor_p - create an n (default 2) octave minor pentatonic scale starting at a given note
% Matt Ruffner
% EE513 Spring 2017
%
% arguments:
%   sfreq:  starting frequency in Hz
%   ndur:   note duration in ms
%   fs:     sampling frequency
%   fname:  filename to save resulting wav file as
%
% returns:
%   notes: a vector of samples representing the resultant scale

% mp, the positions in equal temperment for a minor petatonic scale
mp=[0 3 5 7 10 12];
numoct=2; % number of octaves
nfs=[]; % vector to hold note frequencies
tax = (1/fs):(1/fs):ndur/1000; % time axis for one note

% generate n octaves of the minor p scale.
% ommiting note 0 if not on first octave eliminates dups
for i=1:numoct % where the second number is the desired octave count
    if(i~=1) 
        nfs = [nfs, (sfreq*(2^i))*2.^(mp(2:end)/12)];
    else
        nfs = [nfs, (sfreq*(2^i))*2.^(mp/12)];
    end
end

notes = []; % vector to hold audio samples
for note=nfs
    notes = [notes, cos(2*pi*note*tax)];
end

% export the audio to the specified filename
audiowrite(fname,notes,fs)

    