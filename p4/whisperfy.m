function [ segout ] = whisperfy( seg, fs, a )
% whisperfy - replace voiced speech with white noise colored 
% by the pitch of the voiced segment 
%
% inputs
%   seg: the signal input vector
%   fs:  the signal sampling rate
%   a:   the lpc coeffiecents of the segment
%
% outputs
%   seg: the whisper out vector

% generate white noise the length of the segment
no = randn(length(seg),1);

% Move poles toward unit circle
% adapted from lpctasks.m courtesy of Dr. Donohue
r = roots(a);
scp = abs(r); %  Normalize all pole magnitudes 
np = r./scp; % place all plot magnitudes at .6
pmagshift = .7; 
np99 = np*pmagshift;

%  Design filter in second order sections 
[zb,za] = zp2tf([], np99, 1);  %  all zeros, no poles, gain of 1
cno = filter(zb, za, no);

% color it so it reflects the pitch of the segment
cno = filtfilt(1,a,cno);

% scale to segment amplitude
segout = (cno./max(cno)).*max(seg);


end

