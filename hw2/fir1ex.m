%  This script solves the example in lecture notes comparing filter orders
%  for the linear phase FIR filters (designed using the windowing method).
%  High-pass filters of orders of 10 and 50 are designed with a cut-off
%  of 500 Hz.  The freqz command is used to examine the frequency response
%  (phase and magnitude), the grpdelay command is used to examine the group
%  delay for the filter, and finally a frequency swept signal (from 20Hz
%  to 2000Hz is generated and filtered with both filters for comparisons.
% 
%    Written by Kevin D. Donohue (donohue@engr.uky.edu) March 2004 
%

%  Define DSP Parameters
fs = 8e3;  %  Sampling Frequency
fc = 500;  %  Cutoff Frequency
dt = 4;    % Time duration of frequency sweep signal in seconds
flow = 20;   %  Starting frequency of sweep in Hertz
fend = 2000; %  Ending frequency of sweep in Hertz
t = [0:round(dt*fs)-1]/fs;  %  Corresponding time axis of sweep

%  Generate Filter coefficients
b10 = fir1(10,fc/(fs/2),'high');  %  Order 10 FIR, order should be even for high pass
b50 = fir1(50,fc/(fs/2), 'high');  %  Order 50 FIR, order should be even for high pass

%  Compute Frequency Response
[h10,f10] = freqz(b10,1,1024,fs);
[h50,f50] = freqz(b50,1,1024,fs);

%  Plot magnitude
figure(1)
plot(f10,20*log10(abs(h10)), 'b',f50,20*log10(abs(h50)), 'r')
title('Compare 10 and 50 order FIR high pass filter magnitudes')
xlabel('Hertz')
ylabel('dB')
legend('0rder 10', 'Order 50')
%  Plot Phase
figure(2)
%  unwrap phase to eliminate mod pi jumps
plot(f10,unwrap(angle(h10)), 'b',f50, unwrap(angle(h50)) , 'r')
title('Compare 10 and 50 order FIR high pass filter phases')
xlabel('Hertz')
ylabel('Radians')
legend('0rder 10', 'Order 50')

%  Compute Group Delay
[gd10,fgd10] = grpdelay(b10,1,1024,fs);
[gd50,fgd50] = grpdelay(b50,1,1024,fs);
figure(3)
plot(fgd10,gd10, 'b',fgd50,gd50 , 'r')
title('Compare 10 and 50 order FIR high pass filter group delays')
xlabel('Hertz')
ylabel('samples')
legend('0rder 10', 'Order 50')
pause
%   Simulate signal - Frequency Sweep
fsw = flow + ((fend-flow)/2)*[0:length(t)-1]/length(t);  %  Create Frequency ramp - Why divid by 2?
swp = sin(2*pi*t.*fsw);  % Generate sweep signal

%  Filter signal
sigsw10 = filter(b10,1,swp);
sigsw50 = filter(b50,1,swp);
figure(4)
plot(t,sigsw10)
title('Filtered Frequency Sweep - Order 10')
xlabel('Seconds')
ylabel('Amplitude')
figure(5)
plot(t,sigsw50)
title('Filtered Frequency Sweep - Order 50')
xlabel('Seconds')
ylabel('Amplitude')



