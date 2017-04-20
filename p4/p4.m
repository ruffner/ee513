% EE513 PROJECT 4
% MATT RUFFNER
% 4/19/2017
%
% ANALYZE A RECORDED SPEECH SEGMENT, REPLACING ALL INSTANCES OF VOICED
% SPEECH WITH WHITE NOISE COLORED BY THE VOICED PITCH
%
% GENERAL PROGRAM FLOW AS FOLLOWS 
%--------------------------------
% READ IN SPEECH AND SEGMENT WITH TAPERING WINDOW AND ITERATE
        
    % FOR EACH SPEECH SEGMENT, EXTRACT LPC COEFFS 

    % CALL FUNCTION TO DETERMINE IF THIS SEGMENT OF SPEECH CONTAINS A
    % STRONG PERIODIC COMPONENT

    % IF IT CONTAINS PERIODIC SPEECH, REPLACE SEGMENT WITH WHITE NOISE
    % MODULATED AT THE SAME PITCH TO EMULATE A WHISPER

% PLAY MODIFIED RECORDING BACK TO USER
%--------------------------------


infile = 'audio/woman1_take1.wav';                    % input file
windur=40e-3;                                       % segment duration in ms

[yin,fs]=audioread(infile);                         % read in audio
yout = zeros(size(yin,1),1);                        % presize output vector

winlen = 2*round((fs*windur)/2);                    % segment length in samples, gauranteed even
maxidx = floor(length(yin)/winlen)*winlen;          % max index to iterate to
tapwin = triang(winlen);                            % triangular tapering allows for lossless reconstruction

for i=1:winlen/2:maxidx-winlen/2                    % iterate over input 50% segment overlap

    seg = yin(i:(i+winlen-1));                      % extract single segment
    seg = seg.*tapwin;                              % apply tapering window
    
    [a,er] = lpc(seg,10);                           % Compute LPC coefficent with model order 10
    
    if isvoiced(a,fs)                               % determine if this is a segment of voiced speech
        
        seg = whisperfy(seg,fs,a);                     % convert to whisper if it is voiced
        
        seg = seg.*tapwin;                          % taper the colored noise before reconstruction
    end
            
    yout(i:i+winlen-1) = yout(i:i+winlen-1) + seg;  % reconstruct signal 
    %pause
end

% soundsc(yin,fs)
% pause
figure(1)
spectrogram(yin,tapwin,10,1024,fs);
title('Before Whisperfication')

figure(2)
spectrogram(yout,tapwin,10,1024,fs);
title('After Whisperfication')

% play the whisperfied result
soundsc(yout,fs)
pause















