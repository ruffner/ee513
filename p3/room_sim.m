% EE 513 Project 3
% Beamforming and Cocktail Party Noise
% Room noise simulation script
% Matt Ruffner 
% March 18, 2017
%
% Below is code modified from runCocktailp.m from the ArrayToolbox
% Written by Satoru Tagawa (staga2@uky.edu) and Kevin D. Donohue 6/23/2008
% Updated 6/4/2013
% with the new purpose of simulating room noise for random speaker and
% noise source positions for 3 noise sources and 1 speaker in project 3 of
% Spring 2017 EE513
% 
% Two different microphone configurations are also computed and room noise
% simulated for them. 
%
% Microphone positions for each of these configurations as well as speaker
% positions are save to .dat files for further processing for the project.
%
%  mposa.dat -> mic positions for the adjacent cluster config 
%  mpose.dat -> mic positions for equidistant mic spacing config
%  spos.dat  -> speaker positions, the speaker of interest is always the 
%               first column in the spos.dat file
%
% 4 output files are written as well, speaker of interest and noise sources
% for both microphone configurations. These vectors are named sigposXX
% where XX is either sa,se,na,ne. the first letter is SOI/noise and the
% second letter is adjacent/eqidistant, referring to the mic arrangment of
% that particular simulation.

clear
% SET BY USER *************************************************************
% With reverberation (1) or without (0) room reverberation
reverbEn = 1;  %  Note simulation will take longer with room reverberations

% Play flag. Set to 1 to play back 4 (or all if N less than 4) channels of sigout at
% end of script
pflag = 1;

% Save flag. Set to 1 to save multichannel recording wave file: sigout.wav
sflag = 1;  

% Sampling frequency to be used throughout (optional)
%   otherwise the defaults is that of the lowest sampled wavefile
fsre = 16000;  % IN Hz COMMENT THIS LINE TO Use SAMPLING RATE OF ORIGINAL FILES

% Single speaker wavefiles for creating cocktail party sound
wavefilesn = {'woman1.wav';'woman2.wav';'woman3.wav'};
wavefiless = {'man2.wav'};

Secondsin = 5;  % Number of seconds to read in data
% Read in wavefiles and resample signals 
siginn = wav2sig(wavefilesn,fsre,[0 Secondsin]);  %  Read in over requested range (first 10 seconds)
sigins = wav2sig(wavefiless,fsre,[0 Secondsin]);  %  Read in over requested range (first 10 seconds)
fs = fsre;  %  Reassign sampling rate

% corners adjusted to for specified room size
corners = [0 0 0; 3.2 3.2 2.2]';  %  opposite corners of room coordinates in meters (x,y,z)

% generate a speaker of interest position
spos=[rand(1)*2.8+.25,rand(1)*2.8+.25,rand(1)*1.8+.25];

% randomly generated speaker positions for noise speakers
numSp = size(wavefilesn,1);

while size(spos, 1) < numSp+1
    newPoint=[rand(1)*2.8+.25,rand(1)*2.8+.25,rand(1)*1.8+.25];

    tempDist = sum((spos - repmat(newPoint, size(spos, 1), 1)) .^ 2, 2);

    % Only add this point if it is far enough away from all others.
    if (all(tempDist > 0.3^2))
        spos = [spos; newPoint];
    end
end

% finally, transpose
spos=spos'

% Set position of microphones
% Mic position cannot be at the exact same position as the source position
%  Use function to automatically generate a planar geometry in ceiling 

% perimeter mic layout is all around the room at a height of 1.5m 
micplane  =[0 0 1.5; 0 3.2 1.5; 3.2 3.2 1.5]';  %  Define 3 points for mic perimeter plane

% Matt Ruffner
% Added two microphone layouts

% First version, adjacent clusters, centered on adjacent walls
wa1=regmicsline([1.6-1.5*0.0215625 0 1.5; 1.6+1.5*0.0215625 0 1.5]', 0.0215624);
wa2=regmicsline([0 1.6-1.5*0.0215625 1.5; 0 1.6+1.5*0.0215625 1.5]', 0.0215624);
mposa = [wa1 wa2];



% Second version, equidistant perimeter
wa1=regmicsline([0 0 1.5; 0 3.2 1.5]', 3.2/3);
wa2=regmicsline([0 3.2 1.5; 3.2 3.2 1.5]', 3.2/3);
wa3=regmicsline([3.2 3.2 1.5; 3.2 0 1.5]', 3.2/3);
wa4=regmicsline([3.2 0 1.5; 0 0 1.5]', 3.2/3);
mpose = [wa1(:,2:3) wa2(:,2:3) wa3(:,2:3) wa4(:,2:3)]



[dimnum, micnum] = size(mposa);  %  Get number of mics in micnum
if reverbEn == 1
    % Matt Ruffner 
    % Added specified reflection coefficients
    % Set parameters for simarraysigim here
    reflecc = [.82, .82, .82, .82, .5, .5]; % [.8, .8, .8, .8, .7, .4];  %  Reflection coefficients of walls, ceiling and floor
    recinfo = struct ('fs',fs,'corners',corners,'reflecc',reflecc);
else
    % Set parameters for simarraysig here without reverb (set refectivity of walls to
    % 0)
    reflecc = [0, 0, 0, 0, 0, 0];  %  Reflection coefficients of walls, ceiling and floor
    recinfo = struct ('fs',fs,'corners',corners,'reflecc',reflecc);
end

% Environmental parameters set according to project 3 spec
%  Set environmental parameters affecting attenuation and speed of sound
recinfo.temp = 24; % in centigrade
recinfo.press = 29.8; % in inches of Hg
recinfo.hum = 45; % percent humidity
% ************************************************************************

% Display whether room reverb is on or off
if reverbEn == 1
    disp('ROOM REVERB IS TURNED ON');
else
    disp('ROOM REVERB IS TURNED OFF');
end

% Output source positions of adjacent mics
[nRs,nCs] = size(spos);
figure(1)
plot3(mposa(1,:),mposa(2,:),mposa(3,:),'bo')
hold on
plot3(spos(1,:),spos(2,:),spos(3,:),'rx')
hold off
axis([min(corners(1,:)) max(corners(1,:)) min(corners(2,:)) max(corners(2,:)) min(corners(3,:)) max(corners(3,:))])
title('Mic position denote by blue Os, and source positions denoted by red Xs. Adjacent Cluster Mic Config')
xlabel('X-Dimension in meters')
ylabel('Y-Dimension in meters')
zlabel('Z-Dimension in meters')
grid on

% Output source positions of equidistant mics
[nRs,nCs] = size(spos);
figure(2)
plot3(mpose(1,:),mpose(2,:),mpose(3,:),'bo')
hold on
plot3(spos(1,:),spos(2,:),spos(3,:),'rx')
hold off
axis([min(corners(1,:)) max(corners(1,:)) min(corners(2,:)) max(corners(2,:)) min(corners(3,:)) max(corners(3,:))])
title('Mic position denote by blue Os, and source positions denoted by red Xs. Equidistant Mic Config')
xlabel('X-Dimension in meters')
ylabel('Y-Dimension in meters')
zlabel('Z-Dimension in meters')
grid on
pause(.5);  % Pause to let Matlab generate Figure before simulation

% Simulate cocktail party recording for speaker of interest
%  adjacent cluster and equidistant mic config
sigoutsa = cocktailp(sigins, spos(:,1), mposa, recinfo);
% equidistant
sigoutse = cocktailp(sigins, spos(:,1), mpose, recinfo);


% % Simulate cocktail party recording for noise speakers with both mic
% configs
sigoutna = cocktailp(siginn, spos(:,2:end), mposa, recinfo);
% equidistant
sigoutne = cocktailp(siginn, spos(:,2:end), mpose, recinfo);


% save mic positions for both arrangements to file
dlmwrite('mposa.dat', mposa, ' ');
dlmwrite('mpose.dat', mpose, ' ');

% save speaker positions to file
dlmwrite('spos.dat', spos, ' ');


% Save all channels of sigout
if sflag == 1
    audiowrite('sigoutsa.wav', sigoutsa,fs);
    audiowrite('sigoutse.wav', sigoutse,fs);
    audiowrite('sigoutna.wav', sigoutna,fs);
    audiowrite('sigoutne.wav', sigoutne,fs);
end