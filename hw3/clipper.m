%% sigout - clip a signal at the specified bounds
% matt ruffner feb. 17 2017
% function to clip a sinusoid at upper and lower bounds
% args
%   sigin: input signal vector
%   limits: a 2 element vector of a lower and upper limit respectively
%
% usage:
% sigout = clipper(sigin, [-0.9, 0.9]);

function[sigout] = clipper(sigin, limits)

% verify limits exist
if length(limits)~=2
    error('limits must be a two element vector');
end

% verify limit order
if limits(1) > limits(2)
    error('first element in limit vector must be less than second element');
end

sigout=sigin; % initialize output

for i=(1:length(sigin)) % iterate over input signal
   if sigin(i)<limits(1) % clip lower limit
       sigout(i)=limits(1);
   end
   if sigin(i)>limits(2) % clip upper limit
       sigout(i)=limits(2);
   end
end
    
