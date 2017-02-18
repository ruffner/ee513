%% ee513 hw3 problem 3.2b
% matt ruffner
% design a filter to minimze particular room noise in a voice recording

ai=audioinfo('talkingwithnoise.wav');
fs=ai.SampleRate;

wlen=128;
wn=hamming(wlen);


%  Create reverb signal
[y,fs] = audioread('talkingwithnoise.wav');  %  Read in Clap sound

soundsc(y)
pause(2)

figure(1);
[p,fx] = pwelch(y,wn,wlen/2,2*wlen,fs); % take psd of room noise, get freq axis too
semilogx(fx, sqrt(p)); % examine amplitude of spectrum
title('PSD of Talking With Room Noise');
xlabel('Frequency');
ylabel('Relative Amplitude');

% characterize room noise
f=[0 281.5 500 750 875 937.5 1100 (fs/2)]./(fs/2); 
m=[0 .0031 .005674 .001923 .001628 .001049 0 0]./.005674;

b = fir2(40,f,m);

[h,w] = freqz(b,1,fs); % Frequency response of filter
figure(2);
plot(f,m,w/pi,abs(h))
title('Filter to Minimize Room Noise in Voice Recording');
xlabel('Normalized Frequency')
ylabel('Relative Amplitude')
legend('As Outlined','Actual Response')



yfilt=filter(b,1,y); % remove room noise

pause(8)

soundsc(yfilt);



[p,fx] = pwelch(yfilt,wn,wlen/2,2*wlen,fs);
figure(3);
semilogx(fx,p);
title('PSD of Filtered Voice Signal With Room Noise');
xlabel('Frequency')
ylabel('Relative Amplitude')