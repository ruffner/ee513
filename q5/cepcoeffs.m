function [ coeffs, deltas ] = cepcoeffs( sig, fs, ncoeffs )
% cepcoeffs.m compute cepstral coefficeients
%
% length of return vector is two less than ncoeffs

if ncoeffs < 2
    error('ncoeffs must be > 1');
end

% starting/ending frequencies
fbegin = 200;
fend =   8e3;

% mel range 
melbegin = 1125*log(1 + fbegin/700);
melend =   1125*log(1 + fend/700);

% evenly space the interval markers in mels
melints = linspace(melbegin, melend, ncoeffs);

% convert interval to hz
frqints = 700.*(exp(melints/1125) - 1);

% set window length = .08 seconds
% expect that input segment is already the appropriate length
%winlen = round(.08*fs);
nfft = 4096;

% overlay onto nearest fft bin index
melbins = floor((nfft+1)*frqints/fs);

% blank filter banks
banks = zeros(length(melbins)-2,nfft);

% compute mel filter banks
for mbin=1:length(melbins)-2 
    blower = melbins(mbin);
    bupper = melbins(mbin+2);
    banks(mbin,blower:bupper-1) = triang(bupper-blower)';
end

% take dft of data
ffc = abs(fft(sig,nfft));

% transposefilter bank to ease iteration
banks=banks';

bankno=1;
for fil=banks(:,1:end)
    % multiply fft data by current filter bank 
    fildat=ffc.*fil;
    coeffs(bankno) = sum(fildat.^2);
    bankno=bankno+1;
end


% ITERATE THROUGH STATIC COEFFICIENTS TO CREATE DELTA VALUES YEAYUH



