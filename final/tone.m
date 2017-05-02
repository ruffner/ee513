function [v, t] = tone(f,int,fs)

%  This function will create a series of samples at sampling rate
%  FS for a duration of INT seconds at frequency F in Hertz.
%
%               [v, t] = tone(f,int,fs)
%
%  The output is a row vector V containing the sampled points
%   T is an optional output and is the time axis assoicated with V
%
%   Written by Kevin D. Donohue (donohue@engr.uky.edu) 6/2003

t = [0:fix(fs*int)-1]/fs;   %  Create time axis
v = sin(2*pi*t*f);     %  Create sampled tone signal