% script to classify yes/no/maybe data 
% Matt Ruffner
% 5/2/2017
% 
% adapted from Dr. Kevin Donohue's mindistex1.m 

audiopath = 'YesNoFinalProject/';

% creates cell arrays of each file type
yfiles = dir(strcat(audiopath,'y*.wav')); yfiles={yfiles.name};
nfiles = dir(strcat(audiopath,'n*.wav')); nfiles={nfiles.name}; 
mfiles = dir(strcat(audiopath,'m*.wav')); mfiles={mfiles.name};
afiles = [yfiles nfiles mfiles]; % all files to index into 

load('cov');

feat=zeros(5,1);

ydist = [];
ndist = [];
mdist = [];

yescount = 0;
nocount = 0;
maycount = 0;


% an empty confusing matrix
yay = 0; yan = 0; yam = 0;
nan = 0; nay = 0; nam = 0;
mam = 0; may = 0; man = 0;

for k=1:length(afiles)
    
    
    [y,fs] = audioread(char(strcat(audiopath,afiles(k)))); % read in audio
    [b,a] = butter(4, 2*[200]/fs,'high'); % room noise filter
    yf = filtfilt(b,a,y); % apply room noise filter
    [ytrim,kb,ke] = trimit(yf,fs);
    mid = floor(length(ytrim)/2);      
    bytrim = ytrim(1:mid);  % Get first half data     
    eytrim = ytrim(mid+1:end); % Get last half data 

    del = mfcc(bytrim,fs) - mfcc(eytrim,fs);


    [lpsees1,er] = lpc(bytrim,12);  %  LPC coefficents with model order 12    
    [lpsees2,er] = lpc(eytrim,12);  %  LPC coefficents with model order 12     
    r1 = roots(lpsees1);   %  Find poles of LPC reconstruction filter     
    r2 = roots(lpsees2);   %  Find poles of LPC reconstruction filter     
    sf1 = fs*angle(r1)/(2*pi);  %  Find angles corresponding to poles     
    sf2 = fs*angle(r2)/(2*pi);  %  Find angles corresponding to poles     
    %  Find those corresponding to complex conjugate poles     
    %  and in an expcted range of frequencies     
    nf = find(sf1 > 250 & sf1 < (fs/2 - 100));      
    r1 = r1(nf);  %  Trim to get relevant/positive roots     
    sf1 = sf1(nf);  % Corresponding frequenies     
    ff1 = sort(sf1);  %  Order frequenices from smallest to largest    
    nf = find(sf2 > 250 & sf2 < (fs/2 - 100));      
    r2 = r2(nf);  %  Trim to get relevant/positive roots     
    sf2 = sf2(nf);  % Corresponding frequenies     
    ff2 = sort(sf2);  %  Order frequenices from smallest to largest

    % save features
    feat(1) = del(1);
    feat(2) = del(3);
    feat(3) = del(8);

    % third formant of first half to 2nd of second half
    feat(4) = ff1(3)/ff2(2);

    feat(5) = ff1(4)/ff2(2);
        
    %  Apply minimum scaled distance classifier with scaling to class 1 samples

    %  Class 1 distances to each template
   
    % print out filename
    %strcat(audiopath,afiles(k))
    
    d11ws = (feat-mu1)'*cinv*(feat-mu1);  % compare class 1 samples with template 1
    d12ws = (feat-mu2)'*cinv*(feat-mu2);  % compare class 1 samples with template 2

    %  Find all the incorrect classifications (note all should be closest to
    %  class 1 templte for this case)
    % cd1s = find(d11ws > d12ws);  %  Length of cd1s is the number of mis-classifications

    % Class 2 distances to each template
    d21ws = (feat-mu1)'*cinv*(feat-mu1);  % compare class 2 samples with template 1
    d22ws = (feat-mu2)'*cinv*(feat-mu2);  % compare class 2 samples with template 2

    
    
    
    % thresholds determined by examining histograms of distance
    % distributions
    % mean of yes/no distances was used to create threshold in first if for
    % classifying as neither
    
    letter = afiles{k}(1);
    
    
    if d11ws < 20 && d11ws < d12ws && abs(d11ws-d12ws) > 4
        yescount=yescount+1;
        
        if letter == 'y'
            yay=yay+1;
        elseif letter=='n'
            nay=yan+1;
        else
            may=may+1;
        end
        
    elseif d12ws < 20 && d12ws < d11ws && abs(d11ws-d12ws) > 4
        nocount=nocount+1;
        
        if letter == 'n'
            nan=nan+1;
        elseif letter=='y'
            yan=yan+1;
        else
            man=man+1;
        end
        
    else
        maycount=maycount+1;
        
        if letter == 'm'
            mam=mam+1;
        elseif letter=='y'
            yam=yam+1;
        else
            nam=nam+1;
        end
        
    end
    
end

yay
yan
yam
nan
nay
nam
mam
may
man

