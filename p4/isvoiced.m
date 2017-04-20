function [ res ] = isvoiced( a,fs )
% isvoiced - determines whether a segment of recorded speech at a given
% sampling rate contained voiced speech as opposed to unvoiced speech,
% based on the LPC coefficients.
% inputs
%   a: lpc coefficients of audio sample
%   fs: sampling frequency of sample
%
% outputs
%   res: 1 for voiced, 0 for unvoiced

r  = roots(a);                          % take roots of lpc coefficients
froots = (fs/2)*angle(r)/pi;            % convert to Hz
froots = sort(froots);                  % organize
nf = find(froots > 0 & froots < fs/2);  % find those less than nyquist

% debugging
froots(nf(1));

% (crude) voiced speech decision 
% if first formant is below 2000 hz then it is voiced
% imperically derived and works decently
if froots(nf(1)) < 2000;
    res = 1;
else 
    res = 0;
end

end

