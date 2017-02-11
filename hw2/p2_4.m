% ee513 hw 2 p2_4
% matt ruffner
% parts adapted from colorednoise.m Written by Kevin D. Donohue (donohue@engr.uky.edu) March 2004


fs = 44.1e3;  %  Sampling Frequency
dur = 3;     %  Sound duration in seconds


ord = 3; %3rd order iir


bnum = [ 0.04957526213389,  -0.06305581334498,  0.01483220320740 ];
aden = [ 1.00000000000000, -1.80116083982126, 0.80257737639225];

plen = 32;  % PSD segment length

no = randn(1,round(fs*dur));  %  Generate noise signal


% perform filter operation to get colored noise
cno = filter(bnum,aden,no);



% Compute the PSD
[p, fax] = pwelch(cno,hamming(plen),fix(plen/2),2*plen, fs); % Compute PSD of noise 


figure(1);
plot(fax,abs(fs*p/2),'r'); % Plot PSD

% Label figure
xlabel('Hertz', 'Fontsize', 14)
ylabel('PSD', 'Fontsize', 14)
legend('Ouput PSD')




mxlag = fs*.02;  %  Only compute lags up to 20 milliseconds
[acwno, lagwno] = xcorr(no, mxlag, 'coef');
%  Plot lags 
figure(2); plot(1000*lagwno/(fs),acwno)
xlabel('milliseconds','Fontsize', 14);  ylabel('Correlation coefficient','Fontsize', 14)

%  Compute autocorrelation of output sequence
mxlag = fs*.02;  %  Only compute lags up to 20 milliseconds
[accno, lagcno] = xcorr(cno, mxlag, 'coef');
%  Plot lags 
figure(3); plot(1000*lagcno/(fs),accno)
xlabel('milliseconds','Fontsize', 14);  ylabel('Correlation coefficient','Fontsize', 14)




%%%%% alright do part b

tax=(0:1/fs:dur-1/fs);

power = std(cno);
newsig = sqrt(2)c*power*sin(2*pi*440.*tax) + cno;

% Compute the PSD
[p, fax] = pwelch(newsig,hamming(plen),fix(plen/2),2*plen, fs); % Compute PSD of noise 


figure(4); lh = plot(fax,abs(fs*p/2),'r'); % Plot PSD

% Label figure
xlabel('Hertz', 'Fontsize', 14)
ylabel('PSD', 'Fontsize', 14)
legend('Ouput PSD with sinusoid')




mxlag = fs*.02;  %  Only compute lags up to 20 milliseconds
[acwno, lagwno] = xcorr(no, mxlag, 'coef');
%  Plot lags 
figure(5); plot(1000*lagwno/(fs),acwno)
title('autocorrelation with itself');
xlabel('milliseconds','Fontsize', 14);  ylabel('Correlation coefficient','Fontsize', 14)

%  Compute autocorrelation of output sequence
mxlag = fs*.02;  %  Only compute lags up to 20 milliseconds
[accno, lagcno] = xcorr(newsig, mxlag, 'coef');
%  Plot lags 
figure(6); plot(1000*lagcno/(fs),accno)
title('autocorrelation w pink noise + sinusois');
xlabel('milliseconds','Fontsize', 14);  ylabel('Correlation coefficient','Fontsize', 14)
