% ee513 hw 2 p2.1

tax=(0:31);

tsig=[zeros(1,16) ones(1,12) zeros(1,4)];
tfil=[(.6).^(0:11) zeros(1,20)];

fsig=fft(tsig);
ffil=fft(tfil);

fres=fsig.*ffil;
tres=ifft(fres);

figure(1);
hold on
title('Before Filtering, no zero padding');
plot(tax,tsig,'r')
plot(tax,tfil,'b')
xlabel('Time')
ylabel('Amplitude')
legend('signal','impulse response of filter');

figure(2);
plot(tax,tres,'r')
title('After Filtering, no zero padding');
xlabel('Time')
ylabel('Amplitude')
legend('resulting convolution');


% zero padding
tax=(0:63);

tsig=[zeros(1,16) ones(1,12) zeros(1,4) zeros(1,32)];
tfil=[(.6).^(0:11) zeros(1,20) zeros(1,32)];

fsig=fft(tsig);
ffil=fft(tfil);

fres=fsig.*ffil;
tres=ifft(fres);

hold off
figure(3);
hold on
plot(tax,tsig,'r')
plot(tax,tfil,'b')
title('Before Filtering, with zero padding');

xlabel('Time')
ylabel('Amplitude')
legend('signal','impulse response of filter');

hold off
figure(4);
plot(tax,tres,'r')
title('After Filtering, with zero padding');
xlabel('Time');
ylabel('Amplitude');
legend('resulting convolution');




