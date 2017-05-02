% This program/script opens all spoken yes, no, and miscellaneous word/sound files
% in the data set, high-pass filters, and plots the spectrogram. It also plots the
% signal and its envelope for reference, and plays the sound.  It then pauses
% until a key is hit
%
%   Kevin D. Donohue April 2017 (kevin.donohue1@uky.edu)

clear
close all
%  File names for the "NO" and "Yes" utterances
no_number = 55;  % Number of no samples
yes_number = 55;  % Number of yes samples
neither_number = 55; % number of samples that are not yes or no
      
 envfigpos =  [83   213   560   411]; % Position of envelope figure
 specfigpos =  [677  208   560   420]; % Position of spectrogram figure
 
 fs = 16e3;
 %  filter recording to remove low-frequency artifacts
 [b,a] = butter(4, 2*[200]/fs,'high'); % ~ 200 Hz
 %  filter for envelope to smooth it
 [bf,af] = butter(4, 2*50/fs);  % ~ 50 Hz    
 
 %  Reads in NO files, filters, plots, and plays 
 for k = 1 : no_number  
     if k < 10
        fname = [ 'n0' num2str(k) '.wav'];  % create file name to read in
     else
        fname = [ 'n' num2str(k) '.wav'];  % create file name to read in
     end
     [y,fs] = audioread(fname);
     %  plot signal and envelop for reference
     tax = [0:length(y)-1]/fs;
     %  Apply highpass to remove measurement and room noise
     yf = filtfilt(b,a,y);
     figure(1); plot(tax,yf,'b'); hold on
     % Compute signal envelope
     envyf = abs(hilbert(yf));
     lenv = filtfilt(bf,af,envyf);  % Smooth out envelope to reduce short valleys
     figure(1); plot(tax,lenv,'k', 'LineWidth', 2); hold off
     set(gcf,'Position',envfigpos)
     title(fname)
       xlabel('s')
       ylabel('Amplitude')
     %  now plot spectrogram
    
    winlen = round(.08*fs);  % set window length = .08 seconds
    hlen = winlen - round(winlen/4); %  set overlap
    nfft = 2^nextpow2(winlen*2); % Set fft length
    win = hamming(winlen);  % Tappering window
   % take spectrogram
     [s,f,t] = spectrogram(yf,win,hlen,nfft,fs);
     sdb = 20*log10(abs(s));  % Conver to dB
     %  Plot spectrogram down to a 60 dB dyanmic range
     figure(2); imagesc(t,f,sdb,[max(max(sdb))-60,max(max(sdb))]); 
     set(gcf,'Position',specfigpos)
     axis('xy')
     xlabel('s'); ylabel('Hz');colorbar 
     title(fname)
     % Plot sound
     soundsc(yf,fs);
     pause
 end
 
  %  Reads in YES files, filters, plots, and plays 
 for k = 1 : yes_number  
     if k < 10
        fname = [ 'y0' num2str(k) '.wav'];  % create file name to read in
     else
        fname = [ 'y' num2str(k) '.wav'];  % create file name to read in
     end
     [y,fs] = audioread(fname);
     %  plot signal and envelop for reference
     tax = [0:length(y)-1]/fs;
     %  Apply highpass to remove measurement and room noise
     yf = filtfilt(b,a,y);
     figure(1); plot(tax,yf,'b'); hold on
     % Compute signal envelope
     envyf = abs(hilbert(yf));
     lenv = filtfilt(bf,af,envyf);  % Smooth out envelope to reduce short valleys
     figure(1); plot(tax,lenv,'k', 'LineWidth', 2); hold off
     set(gcf,'Position',envfigpos)
     title(fname)
       xlabel('s')
       ylabel('Amplitude')
     %  now plot spectrogram
    
    winlen = round(.08*fs);  % set window length = .08 seconds
    hlen = winlen - round(winlen/4); %  set overlap
    nfft = 2^nextpow2(winlen*2); % Set fft length
    win = hamming(winlen);  % Tappering window
   % take spectrogram
     [s,f,t] = spectrogram(yf,win,hlen,nfft,fs);
     sdb = 20*log10(abs(s));  % Conver to dB
     %  Plot spectrogram down to a 60 dB dyanmic range
     figure(2); imagesc(t,f,sdb,[max(max(sdb))-60,max(max(sdb))]); 
     set(gcf,'Position',specfigpos)
     axis('xy')
     xlabel('s'); ylabel('Hz');colorbar 
     title(fname)
     % Plot sound
     soundsc(yf,fs);
     pause
 end
 
 %  Reads in random sound (not yes or no) files, filters, plots, and plays 
 for k = 1 : neither_number  
     if k < 10
        fname = [ 'm0' num2str(k) '.wav'];  % create file name to read in
     else
        fname = [ 'm' num2str(k) '.wav'];  % create file name to read in
     end
     [y,fs] = audioread(fname);
     %  plot signal and envelop for reference
     tax = [0:length(y)-1]/fs;
     %  Apply highpass to remove measurement and room noise
     yf = filtfilt(b,a,y);
     figure(1); plot(tax,yf,'b'); hold on
     % Compute signal envelope
     envyf = abs(hilbert(yf));
     lenv = filtfilt(bf,af,envyf);  % Smooth out envelope to reduce short valleys
     figure(1); plot(tax,lenv,'k', 'LineWidth', 2); hold off
     set(gcf,'Position',envfigpos)
     title(fname)
       xlabel('s')
       ylabel('Amplitude')
     %  now plot spectrogram
    
    winlen = round(.08*fs);  % set window length = .08 seconds
    hlen = winlen - round(winlen/4); %  set overlap
    nfft = 2^nextpow2(winlen*2); % Set fft length
    win = hamming(winlen);  % Tappering window
   % take spectrogram
     [s,f,t] = spectrogram(yf,win,hlen,nfft,fs);
     sdb = 20*log10(abs(s));  % Conver to dB
     %  Plot spectrogram down to a 60 dB dyanmic range
     figure(2); imagesc(t,f,sdb,[max(max(sdb))-60,max(max(sdb))]); 
     set(gcf,'Position',specfigpos)
     axis('xy')
     xlabel('s'); ylabel('Hz');colorbar 
     title(fname)
     % Plot sound
     soundsc(yf,fs);
     pause
 end