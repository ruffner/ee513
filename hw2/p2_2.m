% ee513 hw2 p2.2

% parameters
fs=4e3;
tax=(0:fs-1)./fs;
f1=250;
f2=254;

wlen=.5*fs;
wn = hamming(wlen);


sig=sin(2*pi*f1.*tax) + sin(2*pi*f2.*tax); % create signal, no zero padding

figure(1)
pwelch(sig,wn,wlen/2); % look at psd

% now do zero padding


sig=[sin(2*pi*f1.*tax) zeros(1,length(tax)) sin(2*pi*f2.*tax) zeros(1,length(tax))]; % create signal, with zero padding

figure(2)
pwelch(sig,wn,wlen/2); % look at psd