function mf =  mfcc(source,fs)
% Function computes the Mels Frequency Cepstral Coefficients. (MFCC)
%
%    mf =  mfcc(source,fs)
%
% MFCC is computed using the following steps
%
%           1. Spectrum amplitudes are computed
%           2. Uniform Hz axis points are mapped into the Mel axis
%           3. Mel cepstrum bands are segmented out and weighted with
%           uniform trianglar windows.
%           4. the log of each band sum is taken and Cosine Transformed
% Function returns Mells Cepstrum Coefficeints.
% Input arguments
%       SOURCE - source signal
%               single channel sound signal. Minimum sampling frequency of 8
%               Khz
%       FS     - Sampling frequency
%
% Output argument
%
%       MF   - Mel Frequency Cepstrum coefficients
%
%  Written by Kevin D. Donohue April 2017


%  Check to ensure sampling rate is 800Hz
if fs ~= 8000  % If not, resample to make it so
    source = resample(source,8000,fs);
    fs = 8000;
end

% Take the FFT
cep = abs(fft(source));                      % Taking fft

%  Axis mapping from Hz to Mels
faxf = fs*[0:floor(length(cep)/2)-1]/floor(length(cep)/2); % in Hz
fax =2595*log10(1+faxf/700); % Corresponding Mel frequenies

%  Step through filter bank

mf = zeros(1,20);        % Pre allocating output mel cepstrum coefs
mfinc = 102.2;  %  Uniform frequency increment in the mel domain
fstart = 0;  %  Starting Mel point

% Loop to compute each coefficient - 20 channels in bank
for ii = 1:20
    %  Filter points for current channel
    f1 = fstart;  % starting mel
    f2 = fstart+2*mfinc;  % ending mel
    fc = (f1+f2)/2;  % center mel
    % Find all fft point in the current channel
    fpts = find(fax>=f1 & fax <= f2);
    
    % Apply filter bank values to FFT amplitudes
    for kp=1:length(fpts)  % Step through every point in the channel
        if fax(fpts(kp)) <= fc  % if before the center frequency ....
            % Apply a positive slope linear weights to mel
            mf(ii) = mf(ii) + cep(fpts(kp))*(fax(fpts(kp))-f1)/(fc-f1);
        else  % if after the center frequency
            %  Apply a negative slope linear weights
            mf(ii) = mf(ii) + cep(fpts(kp))*(f2-fax(fpts(kp)))/(f2-fc);
        end
    end
    % Increment to next band
    fstart = fstart + mfinc;
end
%  Apply log and take DCT
mf = dct(log10(mf));

