fs=8000;
tax=(0:fs-1)/fs;

% delta pulse to input energy, for testing
del=[1 zeros(1,fs-1)];

amps=[1 2];
fos=[10 20];

ampscales=pi./(fs./fos)*2;
alphas=(2*pi.*fos)/fs;



% numerators
bs=[ampscales(1)*amps(1) 0 0];
if length(amps) > 1 
    counter=2;
    for n=amps(2:end)
        bs=[bs; ampscales(counter)*n 0 0];
        counter=counter+1;
    end
end

as=[1 -2*cos(alphas(1)) 1];
if length(alphas) > 1
    for n=alphas(2:end)
        as=[as; 1 -2*cos(n) 1];
    end
end
    


f1=filter(bs(1,1:end), as(1,1:end), del); % excite oscillator
f2=filter(bs(2,1:end), as(2,1:end), del);


[r1,t1]=impz(f1);
[r2,t2]=impz(f2);

hold on
plot(t1,r1,'r--')
plot(t2,r2,'b--')

