% EE5513 Quiz 2 Part 1
% Matt Ruffner
% Determine the heart rate every 5 seconds from a demodulated
% ultrasonic transducer reading of blood flow sampled at 8khz

[sig,fs] = audioread('HRRestingss8000.wav'); % read in data

dur=5; % chunk duration

b=fir1(20,800/(fs/2),'high'); % high pass to filter out demodulation artifacts

pindex=1; % previous chunk index
nindex=dur*fs*2; % next chunk index
nchunks=floor(length(sig)/(dur*fs));

bpax=zeros(1,nchunks); % beats per minute axis
cax=(1:nchunks)*dur; % time axis for heart rate plot

for i=(1:nchunks)
    % only happens on last iter
    if nindex > length(sig)
        nindex=length(sig);
    end
    ck=sig(pindex+1:nindex); % dur seconds of samples
    
    
    ck=filter(b,1,ck); % preform high pass
    ck=ck-mean(ck); % crude detrending
    [acf,lags]=autocorr(ck,fs,2);   % compare 1s worth to itself. 
                                        % min capture is 1 beat every two
                                        % seconds
    acf=abs(acf); % for taking max()
    boff=500; % get past initial unity val, only a 1/16th of a second
    [v,li]=max(acf(boff:end));
    li=li+boff; % add back
    bpax(i)=(fs/li)*60; % beats per minute datapoint for this chunk
    
    pindex=pindex+dur*fs; % increment chunk pointers
    nindex=pindex+dur*2*fs;
end

figure
plot(cax,bpax,'r')
ylim([60 120]);
title('Heart Beats Per Minute When Stationary')
xlabel('Time (Seconds)')
ylabel('Beats Per Minute')
