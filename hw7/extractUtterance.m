function [ sig ] = extractUtterance( sigin, fs )
% part of ee513 hw 7
% problem 7.2
% extracts the spoken segment of the recording based on the signal being
% below a threshold which is determined as a percentage of the signals peak
% power

% remove those pesky loitering waves
[b,a]=butter(5,250/fs,'high');
sig=filtfilt(b,a,sigin);

% compute envelope
sig=abs(hilbert(sig));

% lowpass for a smooth envelope
[b,a]=butter(5,100/fs,'low');
sig=filtfilt(b,a,sig);

% find signal peak
[maxp,maxi]=max(sig)

% test cutoffs upper and lower
tlower=maxi;
tupper=maxi;

% experimentally determined
thresh=maxp/50;

lc=0; % lower cutoff is beginning to start
hc=size(sig,1); % upper cutoff is end of signal to start
% pass counts and max pass counts, security for determining when signal has ended
passl=0; passlmax=500; % lower pass count before 'speech has ended'
passu=0; passumax=1000;% upper pass count

% start looking at signal peak, searching in both directions
% until the signal falls below the threshhold by the max passcounts for 
% the respective seach directions
while tlower>0 && tupper<size(sig,1)
    
    % test for beginning of speech
    if sig(tlower) > thresh 
        % lower test index
        tlower=tlower-1;
    else
        if passl <= passlmax
            tlower=tlower-1;
            passl = passl+1;
            if passl>passlmax
                % assign final lower cutoff
                lc=tlower;
            end
        end
   end
   
   if sig(tupper) > thresh
       % upper test index
       tupper=tupper+1;
   else
       if passu <= passumax
           tupper=tupper+1;
           passu=passu+1;
           if passu>passumax
               % assign final upper cutoff
               hc=tupper;
           end
       end
   end
   
   % if both pass counts have been exceeded, were done
   if passl>passlmax && passu > passumax
       break;
   end
end

% trim to determined bounds
sig=sigin(lc:hc);

end

