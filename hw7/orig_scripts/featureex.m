%  This script illustrates selecting features to classify signal segments
%  as either simple tones in white noise, or white noise alone.  Data
%  segments are simulted for both classes and features extracted based on
%  3 different signal characterizations (time signal, autocorrelation (AC),
%  and power spectrum (PS)):
%  Features to be extracted (code left as an exersize)
%      Signal power/energy in segment
%      Autocorrelation peak value of rms normalized segment over valid
%      period range
%      Autocorrelation power/energy of rms normalized segment over valid
%      period range
%      Power spectrum of rms normalized segment peak value
%      Power Spectrum of rms normalized segment central frequency
%      Power Spectrum of rms normalized segment frequency disperson
%
%  Written by Kevin D. Donohue (donohue@engr.uky.edu) November 2006

% Simulation Parameters
fs = 10e3;  % Sampling Frequency
int = 20e-3;  %  Segment interval length
frang = [3/int fs/2-3/int];  %  Valid tonal range
snr_range = [0 3];         %  SNR range in dB for tone to white noise
nruns = 10;   %  Number of monte carlo runs

%  Monte Carlo Loop (generate a signls for each class, extract 
%  and store labeled features
for k =1:nruns
    f = frang(1)+rand(1)*(frang(2)-frang(1));  %  random frequency for tone
    [v, t] = tone(f,int,fs);  % Generage tone
    wn = randn(size(v));  %  Generate white noise rms = 1 
    %  Compute random SNR within limits
    snr = snr_range(1) + rand(1)*(snr_range(2)-snr_range(1));
    gn = 10^(snr/20);  %  Scale factor to achieve desired SNR
    vpwn = gn*v + randn(size(v));  % Add white noise to signal at desire SNR
    spow(k) = sum(vpwn.^2);  %  Extract power feature for signal class
    npow(k) = sum(wn.^2);     % Extract power feature for noise class
    
    % Normalize rms power in each segment
    vpwn = vpwn/sqrt(spow(k));  %  Normalize signal plus noise
    wn = wn/sqrt(npow(k));      % Normalize noise
    %  Computue Autocorrelation for the ...
    [schar, lags] = xcorr(vpwn);  %  Signal 
    [nchar, lags] = xcorr(wn);   %  Noise only
    
    %  Extract and store AC based features
     %  Your code here!!!!
    
    
    
    % Compute Power Spectrum for each segment
    fvpwn = abs(fft(vpwn,2*length(vpwn))).^2;  % Signal PS
    fwn = abs(fft(wn,2*length(wn))).^2;  %  Noise PS
    fax = fs*[0:length(fwn)-1]/length(fwn);  % Frequency Axis for both
    
    %  Extract and store PS based features
     %  Your code here!!!!
    
    
    %  Plot normalized signals from each class, and put 
    %  original power in the plot title
    figure(1)
    plot(1000*t,vpwn)
    xlabel('ms')
    ylabel('Signal Amplitude')
    title(['Signal Plus Noise, Total Power = ' num2str(spow(k))])
    set(gcf,'Position', [164   500   380   180])
    figure(2)
    plot(1000*t,wn)
    xlabel('ms')
    ylabel('Signal Amplitude')
    title(['Noise, Total Power = ' num2str(npow(k))])
    set(gcf,'Position', [591   500   380   180]) 
    
    %  Plot AC over relevant range  (comment out when doing actual monte carlo run)
    acn = find(lags/fs >= 0 & lags/fs < int);  %  Extract over period of interest
    figure(3)
    plot(1000*lags(acn)/fs,schar(acn))
    xlabel('ms')
    ylabel('Normalized AC')
    title('Signal Plus Noise')
    set(gcf,'Position', [164   283   380   180])
    figure(4)
    plot(1000*lags(acn)/fs,nchar(acn))
    xlabel('ms')
    ylabel('Normalized AC')
    title('Noise')
    set(gcf,'Position', [591   283   380   180])
    
    %  Plot power spectra over relevant range  (comment out when doing
    %  actual monte carlo run)
    figure(5)
    fn = find(fax<fs/2);
    plot(fax(fn),fvpwn(fn))
    xlabel('Hz')
    ylabel('Normalized PS')
    title('Signal Plus Noise')
    set(gcf,'Position', [164    31   380   180])
    figure(6)
    fn = find(fax<fs/2);
    plot(fax(fn),fwn(fn))
    xlabel('Hz')
    ylabel('Normalized PS')
    title('Noise')
    set(gcf,'Position', [591    31   380   180])
 
    pause
end

%  Compute feature separation with Fisher's criteria
psep = abs(mean(spow)-mean(npow))^2 / (std(spow)^2+std(npow)^2);
figure(7); plot(spow,'bo'); hold on; plot(npow,'rx'); hold off
title(['Feature values for both classes, F = ' num2str(psep)])
legend('Signal', 'Noise')