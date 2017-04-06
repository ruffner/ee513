function [minclasser, roca, pfa, pd, t] = roc(c1,c2)
%  This function inputs 2 vectors of decision statistics
%  and computes the probability of detection (correct classification
%  for vector with higher mean), and probability of false alarm (incorrect
%  classification for vector with smaller mean) for a range of thresholds
%  covering all decision statistic values.
%
%      [minclasser, roca, pfa, pd, t] = roc(c1,c2)
%
%  Inputs: C1 => vector of decision statistics for class 1
%          C2 => vector of decision statistics for class 2
%  Outputs: 
%         MINCLASSER =>  Minimum classificaiton error in percent (using
%         optimal threshold
%         ROCA =>  Area under Receiver Operating Characterisic curvec
%         PFA =>  Vector of false alarm probabilties for each threshold
%         PD =>  Vector of detection probabilities for each threshold
%         T  =>  Vector of all thresholds applied
%
%   Written by Kevin D. Donohue (donohue@engr.uky.edu) Nov. 2006

%  Find which vector has larger values on average
m1 = mean(c1);
m2 = mean(c2);
%  Find range of values that threshold must cover
bt = min(min(c1), min(c2));  %  Smallest point
et = max(max(c1), max(c2));  %  Largest point
nc1 = length(c1);  %  number of points in class 1
nc2 = length(c2);  %  number of points in class 2
npt = 10*(nc1+nc2);  %  Make threshold density 100 times that
%                                   %  of number of points
t = et + (bt-et)*[0:npt-1]/(npt-1); % Compute thresholds to apply

%  Apply each threhsold and compute false alarm and detection probabilities
for k=1:npt
    pd(k) = length(find(c1 >= t(k)))/nc1;  %  Probability of detection
   pfa(k) = length(find(c2 >= t(k)))/nc2; % here use >= to guarentee that roc area can reach 1
end
% Compute ROC area (trapazoid rule)
roca = sum(diff(pfa).*(pd(1:npt-1)+pd(2:npt)))/2;
%  If larger class was on bottom flip them around
if roca<0.5
    roca=1-roca;
    pd0 = pfa;
    pfa0 = pd;
    pd = pd0;
    pfa = pfa0;
    nc10 = nc2;
    nc20 = nc1;
    nc1 = nc10;
    nc2 = nc20;
end
%  Compute classificaiton errors
classer =((1-pd)*nc1+(pfa)*nc2)/(nc1+nc2);
%  Find minimum value
minclasser = min(classer);
minclasser = minclasser(1);


