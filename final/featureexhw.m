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

clear
close all

fs = 10e3;  % Sampling Frequency
int = 20e-3;  %  Segment interval length
frang = [3/int fs/2-3/int];  %  Valid tonal range
snr_range = [-3 0];         %  SNR range in dB for tone to white noise
nruns = 200;   %  Number of monte carlo runs

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
    f1 = frang(1);  %  Lowest Frequency in Hz
    f2 = frang(2); %  highest frequency in Hz
    L1 = ceil(fs/f1);  %Lag corresponding to largest period
    L2 = floor(fs/f2);   %Lag corresponding to smallest period
    intrng = find(L2 <= lags & L1 >= lags);  %  Get indeces corresponding to valid range
    %  find max autocorrelation value
    vpdum = max(schar(intrng));  % for signal
    wndum = max(nchar(intrng));  % for noise
    vprmax(k) = vpdum(1);
    wnrmax(k) = wndum(1);
    %  Find sum of autocorrelation power
    vprpow(k) = mean(schar(intrng).^2);  %Signal      
    wnrpow(k) = mean(nchar(intrng).^2);  %Noise
    
    % Compute Power Spectrum for each segment
    fvpwn = abs(fft(vpwn,2*length(vpwn))).^2;  % Signal PS
    fwn = abs(fft(wn,2*length(vpwn))).^2;  %  Noise PS
    fax = fs*[0:length(fwn)-1]/length(fwn);  % Frequency Axis for both

    %  Get indecies corresponding to frequency range of interest
    intrng = find(f1 <= fax & f2 >= fax);  

    %  Find max spectral peak
    vpdum = max(fvpwn(intrng));  %  for signal
    wndum = max(fwn(intrng));  %  for noise
    vpfmax(k) = vpdum(1);
    wnfmax(k) = wndum(1);
    %  Find dispersion
    fvmu(k) = sum(fax(intrng).*fvpwn(intrng))/sum(fvpwn(intrng));  % Center of signal
    wnmu(k) = sum(fax(intrng).*fwn(intrng))/sum(fwn(intrng));  % Center of noise
    fvpdis(k) = sum(((fax(intrng)-fvmu(k)).^2).*fvpwn(intrng))/sum(fvpwn(intrng));  % disperson of signal
    wndis(k) = sum(((fax(intrng)-wnmu(k)).^2).*fwn(intrng))/sum(fwn(intrng));  % Center of noise
%     %  Plot normalized signals from each class, and put 
%     %  original power in the plot title
%     figure(1)
%     plot(1000*t,vpwn)
%     xlabel('ms')
%     ylabel('Signal Amplitude')
%     title(['Signal Plus Noise, Total Power = ' num2str(spow(k))])
%     set(gcf,'Position', [164   500   380   180])
%     figure(2)
%     plot(1000*t,wn)
%     xlabel('ms')
%     ylabel('Signal Amplitude')
%     title(['Noise, Total Power = ' num2str(npow(k))])
%     set(gcf,'Position', [591   500   380   180]) 
%     
%     %  Plot AC over relevant range  (comment out when doing actual monte carlo run)
%     acn = find(lags/fs >= 0 & lags/fs < int);  %  Extract over period of interest
%     figure(3)
%     plot(1000*lags(acn)/fs,schar(acn))
%     xlabel('ms')
%     ylabel('Normalized AC')
%     title('Signal Plus Noise')
%     set(gcf,'Position', [164   283   380   180])
%     figure(4)
%     plot(1000*lags(acn)/fs,nchar(acn))
%     xlabel('ms')
%     ylabel('Normalized AC')
%     title('Noise')
%     set(gcf,'Position', [591   283   380   180])
%     
%     %  Plot power spectra over relevant range  (comment out when doing
%     %  actual monte carlo run)
%     figure(5)
%     fn = find(fax<fs/2);
%     plot(fax(fn),fvpwn(fn))
%     xlabel('Hz')
%     ylabel('Normalized PS')
%     title('Signal Plus Noise')
%     set(gcf,'Position', [164    31   380   180])
%     figure(6)
%     fn = find(fax<fs/2);
%     plot(fax(fn),fwn(fn))
%     xlabel('Hz')
%     ylabel('Normalized PS')
%     title('Noise')
%     set(gcf,'Position', [591    31   380   180])
%  
%     pause
end

%  Create vectors to compute Fischers criterion
%  for feature extracted from signal 
featvp = [spow; vprmax; vprpow; vpfmax; fvmu; fvpdis]';
mvp = mean(featvp);  
svp = std(featvp).^2;

%  for feature extracted from noise
featwn = [npow; wnrmax; wnrpow; wnfmax; wnmu; wndis]';
mwn  = mean(featwn);
swn = std(featwn).^2;

 %  Compute feature separation with Fisher's criteria
for k=1:length(mvp)
   psep(k) = abs(mvp(k)-mwn(k)) / sqrt(svp(k)+swn(k)/2);
end
% Plot Fischer Critera for each feature
figure
bar(psep)
xl = {'power', 'maxcor', 'powcor', 'maxspec', 'centspec', 'disspec'};
set(gca, 'XTickLabel', xl)
ylabel('Standard Deviations')
title(['Fisher Criterion (sqrt)'])