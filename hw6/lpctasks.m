clear
[y,fs] = audioread('aaa3.wav');  %  Read in wavefile with neutral vowel sound

% add -10 db of white noise
noi=randn(size(y,1),1).*.1;
y=y+noi;


%  Read in and filter another segment of speech from the same speaker
% (note if 'fs' of the recorded file is different than the segment of speech
%  used to design the LPCs then an error (frequency shift in filter) will
%  occur) fs should be the same for both files
% [y,fs] = audioread('mytalk.wav');  %  Read in wavefile
wind = .064;  % window size in seconds
%y = y(1:round(fs*wind));
[cb,ca] = butter(5,2*80/fs,'high');  %  Filter to remove LF recording noise
yf = filtfilt(cb,ca,y(:,1));
[a,er] = lpc(yf,10);  %  Compute LPC coefficent with model order 10
pe = filter(1,a,yf);
%Find period
cc = cclip(pe,'cnhl',.4);
[gg, lgg] = xcorr(cc,'coeff');
gg = gg(lgg >= 0);
lgg = lgg(lgg >= 0);
%[gm, gp] = findpeaks(gg,'MINPEAKHEIGHT',.9);
[gm, gp] = findpeaks(gg,'MINPEAKHEIGHT',.7);
figure
plot(lgg(gp)/fs,gm,'or',lgg/fs,gg, '-k')
title('Autocorrelation of all pole filtered signal')
xlabel('Seconds')
ylabel('Correlation')

%  Estimate Formant Frequencies form LCF filter poles and plot for confirmation
r  = (roots(a));  % Compute poles of LPC filter 

%  Find resonant frequencies corresponding to poles 
froots = (fs/2)*angle(r)/pi;  % Convert plot angles to frequency in Hz based on sampling rate
nf = find(froots > 0 & froots < fs/2);  %  Find only those corresponding to complex conjugate poles
figure
%  Examine average spectrum with formant frequencies
[pd,f] = pwelch(yf,hamming(2*1024),2*1024-256, 4*1024,fs);  
dbspec = 10*log10(pd);
mxp = max(dbspec);  %  Find max and min points for graphing verticle lines
mnp = min(dbspec);
plot(f,dbspec,'b')  %  Plot PSD
hold
% Over lines on plot where formant frequencies were estimated from LPCs
for k=1:length(nf)
   plot([froots(nf(k)), froots(nf(k))], [mnp(1), mxp(1)], 'k--')
end
%  put all formant frequencies in an ascending array
formfreq = sort(froots(nf));
hold off
title('PSD plot with formant frequencies (Black broken lines)')
xlabel('Hertz')
ylabel('dB')

% If figure looks Ok then the estimate of tube length will make sense
%  Use all poles in the estimate based on quarter wavelength resonance
%
%     L = (2*k-1)*c / (4*f(k))
%  
c = 345;  %  Assume speed of sound is 345 m/s
for k=1:length(nf)
    tlen(k) = (2*k-1)*c/(4*formfreq(k));
end
    tubelen = mean(tlen(3:end));
    disp(['tube length is ' num2str(100*tubelen) ' cm'])
    
 
 spezf = filter(a,1,yf);  %  Apply all zero (inverse) filter
 spepf = filter(1,a,yf);  %  Apply all pole (match) filter

 disp('Playing original sound, hit any key to hear all-pole filter')
 soundsc(yf,fs)
 pause

 soundsc(spepf,fs)  %  All pole filter
 disp('Playing all pole-filter sound, hit any key to play all zero sound' )

 pause
 disp('Playing all zero-filter sound, hit any key to continue' )
 soundsc(spezf,fs)  %  All zero filter
 
 % Compare spectra of all 2 filtered signals
 
%  Examine average spectrum with formant frequencies
[pdzf,f] = pwelch(spezf,hamming(2*1024),2*1024-256,4*1024,fs);  
dbspeczf = 10*log10(pdzf);
[pdpf,f] = pwelch(spepf,hamming(2*1024),2*1024-256,4*1024,fs);  
dbspecpf = 10*log10(pdpf);
figure
plot(f,dbspec/(mean(dbspec)),'b',f,dbspeczf/(mean(dbspeczf)),'g',f,dbspecpf/(mean(dbspecpf)),'r')  %  Plot PSD
legend({'Original', 'Zero-filter', 'Pole-filter'})
xlabel('Hertz')
ylabel('dB')
pause


%  Design filter in second order sections
[s,g] = zp2sos([], r, 1);  %  no zeros, all poles a gain of 1
%  Filter in stages
[stg, cols] = size(s);   %  Find row of S, these correspond to second order filter stages
%  Loop through each second order stage
ytemp = filter(s(1,1:3), s(1,4:6), yf);
for k=2:stg
    ytemp = filter(s(k,1:3), s(k,4:6), ytemp);
end
%  Compare second order stage filter with other direct form
disp('compare filter implementations, hit any key to continue')
soundsc([ytemp/mean(abs(ytemp)); spepf/mean(abs(spepf))],fs)
pause

% Move poles toward unit circle
scp = abs(r);
%  Normalize all pole magnitudes 
np = r./scp;
% place all plot magnitudes at .9
pmagshift = .9;
np99 = np*pmagshift;

%  Design filter in second order sections
[zb,za] = zp2tf([], np99, 1);  %  no zeros, all poles a gain of 1
ytemp = filter(zb, za, yf);

%  Plot pole zero diagram
figure
zr  = (roots(za))
w = [0:.001:2*pi];
plot(real(zr),imag(zr),'xr',real(exp(j*w)),imag(exp(j*w)),'b')
title('Pole diagram of vocal tract filter')
xlabel('Real'); ylabel('Imaginary')

disp(['Listen to filter with pole magnitudes shifted to ' num2str(pmagshift)]) 
audiowrite(strcat('poleshift',num2str(pmagshift),'.wav'),ytemp,fs)
soundsc(ytemp,fs)