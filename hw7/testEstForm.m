% ee513 hw7
% problem 3 test of written function
% estimating formant freqs

testdir='yesnotest/';
yes = {'y01.wav', ...
             'y02.wav', ...
             'y03.wav', ...
             'y04.wav', ...
             'y05.wav', ...
             'y06.wav', ...
};
no = {'n01.wav', ...
             'n02.wav', ...
             'n03.wav', ...
             'n04.wav', ...
             'n05.wav', ...
             'n06.wav', ...
             'n07.wav'};
                 
for k=1:length(yes)
    [seg,fs] = audioread(strcat(testdir,yes{k}));
    soundsc(seg,fs)
    figure(1)
    plot(seg)
    title('Yes before')
    pause
    
    seg = extractUtterance(seg,fs);
    
    seg = estFormants(seg,fs);
    
    soundsc(seg,fs)
    figure(2)
    plot(seg)
    title('Yes after')
    pause 
end
 
for k=1:length(no)
    [seg,fs] = audioread(strcat(testdir,no{k}));
    soundsc(seg,fs)
    figure(1)
    plot(seg)
    title('No')
    pause
    
    seg = extractUtterance(seg,fs);
    
    soundsc(seg,fs)
    figure(2)
    plot(seg)
    title('Trimmed No')
    pause 
end