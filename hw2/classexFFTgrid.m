%  Script for class example demonstrating artifacts related to FFT grid
%  points.
% Kevin D Donohue 1/30/2017 

fs = 16000;  % Sampling frequency
dur = .25;  % Duration in seconds
tax = [0:round(dur*fs)-1]/fs;
%  Signal parameter matrix (frequency in Hz, amplitude) in each row
sigpar = [300, 1; 352, .5; 481, 1.5];
[r,c] = size(sigpar);
y = zeros(size(tax)); % Initaize output
%  Loop to accumulate output
for k=1:r
    y = y + sigpar(k,2)*cos(2*pi*sigpar(k,1)*tax);
end
% Take FFT and plot
g = fft(y);  %  No zero padding
%g = fft(y,length(y)); % With zero padding
fax = fs*[0:length(g)-1]/length(g);

plot(fax,abs(g))  % Plot without scaling
%plot(fax,abs(g)/length(tax))  %  Normalized so amplitudes show up as expected in the FT
xlabel('Hz')
ylabel('Amplitude')
    
    
