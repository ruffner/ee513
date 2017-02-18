% EE513 homework 3 problem 3.2a
% matt ruffner
% characterize room modes as fir filter coefficients


ai=audioinfo('labnoise.wav'); % background fan noise
fs=ai.SampleRate 

wlen=128; % window length in samples
wn=hamming(wlen); % window type

[y,fs] = audioread('labnoise.wav');  % read in room noise

figure(1);
[p,fx] = pwelch(y,wn,wlen/2,2*wlen,fs); % take psd of room noise, get freq axis too
semilogx(fx, sqrt(p)); % examine amplitude of spectrum


f = [0 187 656 1344  2625 4000 ]./(fs/2);
m = [0 .00905 .001912 .004954 .001726  0]./0.00905;

b = fir2(20,f,m);

[h,w] = freqz(b,1,fs); % Frequency response of filter
figure(2);
plot(f,m,w/pi,abs(h))
title('Filter designed based on room noise PSD');
xlabel('Normalized Frequency')
ylabel('Relative Amplitude')
legend('As Outlined','Actual Response')

no=randn(1,10000);

soundsc(no)

cno=filter(b,1,no);

pause(2)

soundsc(cno);



[p,fx] = pwelch(cno,wn,wlen/2,2*wlen,fs);
figure(4);
semilogx(fx,p);
title('White Noise Filtered With Room Noise Filter');
xlabel('Frequency')
ylabel('Relative Amplitude')