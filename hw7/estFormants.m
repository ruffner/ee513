

function [ forms ] = estFormants( sig,fs )
% estFormants - estimate the formant frequencies of the first and second
% half of a recorded snipped of speech
% formant frequency identification from Kevin Donohue and the Array Toolbox

winlens = 50;  %PSD window length in milliseconds
winlen = winlens*fs/1000;

% separate the signal into halves
mp=floor(size(sig,1)/2); % midpoint
if mod(mp,2) ~= 0
    mp=mp-1;
end

h1 = sig(1:mp);
h2 = sig(mp:mp*2-1);
halves(:,1)=h1;
halves(:,2)=h2;
halfc=1;

for half=halves(1:end,:);
    
    [cb,ca] = butter(5,2*100/fs,'high');  %  Filter to remove LF recording noise
    yf = filtfilt(cb,ca,half);
    [a,er] = lpc(yf,10);  %  Compute LPC coefficent with model order 10
    
    
    r  = (roots(a));
    
    %  Find resonant frequencies corresponding to poles
    % adapted from lpcex.m 
    froots = (fs/2)*angle(r)/pi;
    froots = sort(froots);
    nf = find(froots > 0 & froots < fs/2);  %  Find those corresponding to complex conjugate poles
    
    forms(:,halfc) = froots(nf(1:4));
    
    halfc=halfc+1;
    %pause
end

end

