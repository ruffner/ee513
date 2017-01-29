fs=8000;
fo=10;

ampscale=pi/(fs/fo)*2;


amp=2;

tax=(0:fs-1)/fs;

alpha=(2*pi*fo)/fs;

% numerator
b=[ampscale*amp 0 0];

% denom
a=[1 -2*cos(alpha) 1];


% delta pulse to input energy
del=[1 zeros(1,fs-1)];


f1=filter(b,a,del); % excite oscillator

[r1,t1]=impz(f1);
plot(t1,r1,'r--')

