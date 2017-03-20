% EE513 Project 3
% Beamforming and Cocktail Party Noise
% Room noise analysis script
% Matt Ruffner
% March 20, 2017
%
% Below is code modified from partyanal.m from the ArrayToolbox
% Written by Phil Townsend (jptown0@engr.uky.edu) 6/2/08
% Updated by Kevin D Donohue August 2014 to remove correlation, apply taper
% window for overlap and add, apply the invese distance BF option to delay and summ
% and added time frequency masking
%
% This script reads in audio, speaker positions and microphone positions
% created by the room_sim.m script, also part of Project 3 code.

clear

c = 345.6;  %  Speed of sound for recording
tWin = 80e-3;  % Window size for block processing
iw = 1;  %  Set flag to 1 for inverse distance weighting on delay and sum BF

% trial number, corresponding to folder (3 folders exist)
trial=3;

% actual path holding trial data
tpath=strcat('trial',num2str(trial),'/');

% target snrs of trial, corresponds to additive ratio of signal and noise
% source files
tsnrs = [.1 .2 .3 .4 .5 .6 .7 .8];

% microphone arrangement to run trial on, dictates which noise/speaker
% signal files are to be read in anc combined at specified snr
%  'a' -> adjacent mic arrangement
%  'e' -> equidistant mic arrangement
micarrs=['a', 'e'];

% iterate over the mic arrangements
% this creates 8*2=16 wav files for each mic arrangement/snr/beamform
% combination, for a total of 32 audio files created in the trial folders
for micarr=micarrs
    
    % iterate over the range of snr values
    for tsnr=tsnrs
        
        % SOI input file
        soiwav=strcat(tpath,'sigouts',micarr,'.wav');

        % noise wav file
        noiwav=strcat(tpath,'sigoutn',micarr,'.wav');

        %  Get paramaters from wave files, 
        gsoi = audioinfo(soiwav);
        sigSize = [gsoi.TotalSamples, gsoi.NumChannels];
        fs = gsoi.SampleRate;
        N = sigSize(1);  % Total samples in each track
        nWin = round(tWin*fs);  % Audio window size in samples
        if nWin/2 ~= fix(nWin/2)  % Ensure samples are even for overlap and add
            nWin = nWin+1;
        end
        nInc = round(nWin/2);  % Window increment %50 overlap
        M = sigSize(2);  % Number of microphones


        % Load mic and speaker positions
        m = load(strcat(tpath,'mpos',micarr,'.dat'));  % in meters
        sRaw = load(strcat(tpath,'spos.dat'));  % in meters
        % man2 is always SOI, and first in spos matrix
        people = {'man2' 'woman1' 'woman2' 'woman3'};  % all speakers
        for p=1:length(people)  % Iterate over everyone in the party
            s.(people{p}) = sRaw(:,p);  % Set speaker location
        end


        % Output source positions to screen for observation
        figure(1)
        plot3(m(1,:),m(2,:),m(3,:),'bo')
        hold on
        plot3(s.man2(1),s.man2(2),s.man2(3),'rx', 'MarkerSize', 14)
        plot3(s.woman1(1),s.woman1(2),s.woman1(3),'g>', 'MarkerSize', 14)
        plot3(s.woman2(1),s.woman2(2),s.woman2(3),'g>', 'MarkerSize', 14)
        plot3(s.woman3(1),s.woman3(2),s.woman3(3),'g>', 'MarkerSize', 14)


        hold off
        %axis([min(corners(1,:)) max(corners(1,:)) min(corners(2,:)) max(corners(2,:)) min(corners(3,:)) max(corners(3,:))])
        title({'Mic position denote by blue Os, and source of interest denoted by red Xs', ...
                'and interfering source denoted by green triangles'})
        xlabel('X-Dimension in meters')
        ylabel('Y-Dimension in meters')
        zlabel('Z-Dimension in meters')
        grid on



        %  Find closest mic to speaker of interest for comparison
        mdd = sum((m - s.man2*ones(1,M)).^2);
        [dum, cindex] = min(mdd);


        % instead of reading in a single cocktail party noise file we create our
        % own at the specified snr with the separate noise and SOI wav files

        [soiin, fs] = audioread(soiwav);
        [noiin, fs] = audioread(noiwav);

        % normalize by their standard deviation
        for micIndex=1:M
           soiin(:,micIndex) = soiin(:,micIndex)/std(soiin(:,micIndex));
           noiin(:,micIndex) = noiin(:,micIndex)/std(noiin(:,micIndex));
        end

        % combine at specified snr
        yin = tsnr*soiin+noiin;


        %[yin, fs] = audioread(fName);
        yclose = yin(:,cindex(1));


        hwin = hann(nWin+1);  %  Tappering window for overlap and add
        hwin = hwin(1:end-1);  % Make adjustment so even windows align

        % BEGIN BEAMFORMING FROM PARTYANAL.M
        % DSB
        x = zeros(nWin, M);  % Current window of audio data
        yDsb = zeros(N, 1); % delay-sum beamformer output
        hwt = waitbar(0,'Beamformer: DSB');
        for n=1:nInc:N-nWin  % iterate over 20ms windows
            % For each 20ms window save the previous and open the new
            xPrev = x;  x = yin(n:n+nWin-1,:);
            dum = dsb(x, xPrev, fs, s.man2, m, c,iw); % run
            yDsb(n:n+nWin-1)  = yDsb(n:n+nWin-1) + dum.*hwin;
            waitbar(n/N,hwt);
        end
        close(hwt)

        %Masking
        x = zeros(nWin, M);  % Current window of audio data
        yDsb1 = zeros(N, 1); % delay-sum beamformer output
        hwt = waitbar(0,'Beamformer: DSB with TF Masking');
        for n=1:nInc:N-nWin  % iterate over 20ms windows
            % For each 20ms window save the previous and open the new
            xPrev = x;  x = yin(n:n+nWin-1,:);
            dum = dsb(x, xPrev, fs, s.man2, m, c); % run
            yDsb1(n:n+nWin-1)  = yDsb1(n:n+nWin-1) + dum.*hwin;
            waitbar(n/(4*N),hwt);
        end
        x = zeros(nWin, M);  % Current window of audio data
        yDsb2 = zeros(N, 1); % delay-sum beamformer output
        for n=1:nInc:N-nWin  % iterate over 20ms windows
            % For each 20ms window save the previous and open the new
            xPrev = x;  x = yin(n:n+nWin-1,:);
            dum = dsb(x, xPrev, fs, s.woman1, m, c); % run
            yDsb2(n:n+nWin-1)  = yDsb2(n:n+nWin-1) + dum.*hwin;
            waitbar(1/4+n/(4*N),hwt);
        end
        x = zeros(nWin, M);  % Current window of audio data
        yDsb3 = zeros(N, 1); % delay-sum beamformer output
        for n=1:nInc:N-nWin  % iterate over 20ms windows
            % For each 20ms window save the previous and open the new
            xPrev = x;  x = yin(n:n+nWin-1,:);
            dum = dsb(x, xPrev, fs, s.woman2, m, c); % run
            yDsb3(n:n+nWin-1)  = yDsb3(n:n+nWin-1) + dum.*hwin;
            waitbar(2/4+n/(4*N),hwt);
        end
        x = zeros(nWin, M);  % Current window of audio data
        yDsb4 = zeros(N, 1); % delay-sum beamformer output
        for n=1:nInc:N-nWin  % iterate over 20ms windows
            % For each 20ms window save the previous and open the new
            xPrev = x;  x = yin(n:n+nWin-1,:);
            dum = dsb(x, xPrev, fs, s.woman3, m, c); % run
            yDsb4(n:n+nWin-1)  = yDsb4(n:n+nWin-1) + dum.*hwin;
            waitbar(3/4+n/(4*N),hwt);
        end
        yMask = tfmask([yDsb1, yDsb2, yDsb3, yDsb4],1,tWin,4,fs);

        close(hwt)


        % save result of IDBF
        audiowrite(strcat(tpath,'yDsb-',micarr,'-snr',num2str(tsnr),'.wav'), yDsb/(sqrt(2)*max(abs(yDsb))), fs);
        % save result of masked IDBF
        audiowrite(strcat(tpath,'yMask-',micarr,'-snr',num2str(tsnr),'.wav'), yMask/(sqrt(2)*max(abs(yMask))), fs);

    end
end
