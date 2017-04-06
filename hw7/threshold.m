% hw 7 ee513
% problem 7.1
% matt ruffner

% test script for extractUtterance function

% this script determines where the spoken voice portions of the signal
% begin and end in the provided yesnotest/ directory or recorded audio
% samples

testdir='yesnotest/';
yes = {'y01.wav', ...
             'y02.wav', ...
             'y03.wav', ...
             'y04.wav', ...
             'y05.wav', ...
             'y06.wav', ...
             'y07.wav', ...
             'y08.wav', ...
             'y09.wav', ...
             'y10.wav', ...
             'y11.wav', ...
             'y21.wav', ...
             'y22.wav', ...
             'y23.wav', ...
             'y24.wav', ...
             'y25.wav', ...
             'y26.wav', ...
             'y27.wav', ...
             'y28.wav', ...
             'y29.wav', ...
             'y30.wav', ...
             'y31.wav', ...
             'y32.wav', ...
             'y33.wav'};
no = {'n01.wav', ...
             'n02.wav', ...
             'n03.wav', ...
             'n04.wav', ...
             'n05.wav', ...
             'n06.wav', ...
             'n07.wav', ...
             'n08.wav', ...
             'n09.wav', ...
             'n10.wav', ...
             'n11.wav', ...
             'n12.wav', ...
             'n13.wav', ...
             'n20.wav', ...
             'n21.wav', ...
             'n22.wav', ...
             'n28.wav', ...
             'n29.wav', ...
             'n30.wav', ...
             'n33.wav'};
                 
for k=1:length(yes)
    [seg,fs] = audioread(strcat(testdir,yes{k}));
    soundsc(seg,fs)
    figure(1)
    plot(seg)
    title('Yes before')
    pause
    
    seg = extractUtterance(seg,fs);
    
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