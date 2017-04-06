%  This script simulates data for a classification problem by creating
%  a 2 element mean feature vector corresponding to 2 classes
%  and generating correlated gaussian variations about these means to
%  simulate sample variations in each class (differing only in the
%  means of their features, the covaraince matrix for both classes is
%  the same).
%  The first set of simulated data represents the training sets used
%  to derive the template vectors and the covaraince matrix. These
%  2 items with a decision rule form the classifier.
%  Two implementations are used, with and without scaling of by 
%  the inverse covariance matrix.
%  The second data set is generated independently to see how well
%  the classifier generalizes from the training data.  The mean
%  feature vectors and covaraince estimated from the training 
%  data is applied to the test data.
%  Feature graphs are created with classification error estimates
%  on the training data to observe the impact of each step
%  For the testing only the classification error precent is presented
%  to compare performance of the classifier with and without scaling.
%
%    Written by Kevin D. Donohue (donohue@engr.uky.edu) April 19, 2008


clear all
%  Number for training samples
trnnum =100;
%  Number for testing samples
tstnum = 300;
%  True mean values of feature vectors
m1 = [489; 10];  %  For simulation sake pretend first element is formant frequency 1 
m2 = [525; 3];   %   and second element is dB ratio between next 2 formant amplitudes
%  Underlying covariance describing power and correlation of feature value 
%  fluctuations
cv = [110, -sqrt(50); -sqrt(50) 26];   %  Off-diagonal terms imply a correlation
                                       % between features, diagonal terms are
                                       % the varainces of each feature
%  Training data generation
f1 = randn(2,trnnum);  % Generate zero-mean uncorrelated fluctuations for class 1 
f2 = randn(2,trnnum);   % Generate zero-mean uncorrelated fluctuations for class 2
%  This is tricky.  The covariance is variance (power) and we need
%  amplitude (RMS) to scale the noise values.  We can't take the square root
%  directly because correlation bewteen difference samples can be negative.
%  so we will use the singualr value decompostion  .....
[u,s,v] = svd(cv);  %  Decompose Covariance with SVD (eigenvalue and vector decomposition)
stdcv = v*sqrt(s)*u';  % recompose with values proportional to std rather than variance
%  Scale independent noise values to set power levels and introduce correlation
f1p = stdcv*f1 + m1*ones(1,length(f1));  %  Add mean template for each sample of class 1
f2p = stdcv*f2 + m2*ones(1,length(f2));  %  Add mean tmplate for each sample of class 2

%  Plot simulated traning features 
figure
plot(f1p(1,:),f1p(2,:),'xr',f2p(1,:),f2p(2,:),'og','MarkerSize', 10)
set(gca,'FontSize',12);
xlabel('First Formant Frequency ( g_1 )','FontSize',12)
ylabel('dB of Ratio Formant 3 over 4 ( g_2 )','FontSize',12)
grid
hold on
%  Build classifier without scaling
mu1 = mean(f1p,2);  %  Template for class 1
mu2 = mean(f2p,2);  %  Template for class 2
%  Plot template vectors as triangles
plot(mu1(1,:),mu1(2,:),'>r',mu2(1,:),mu2(2,:),'<g','MarkerSize', 18);
legend({'Class 1' 'Class 2'})
%  Apply minimum distance classifier with no scaling to class 1 samples
%  (Training set)
d11 = sqrt(sum((f1p-mu1*ones(1,length(f1))).^2));  % compare class 1 samples with template 1
d12 = sqrt(sum((f1p-mu2*ones(1,length(f1))).^2));  % compare class 1 samples with template 2
%  Find all the incorrect classification (note all should be closest to
%  class 1 templte for this case)
cd1 = find(d11 > d12);  %  Length of cd1 is the number of mis-classifications

%  Apply minimum distance classifier with no scaling to class 2 samples
%  (Training set)
d21 = sqrt(sum((f2p-mu1*ones(1,length(f2))).^2));
d22 = sqrt(sum((f2p-mu2*ones(1,length(f2))).^2));
%  Find all the incorrect classification (note all should be closest to
%  class 2 templte for this case)
cd2 = find(d22 > d21); %  Length of cd1 is the number of mis-classifications
%  Overall classification error with scaling
classerr = 100*(length(cd1)+length(cd2))/(length(f2) + length(f1));
title(['Training set samples, No Scaling Classification error = ' num2str(classerr) '%'])
hold off

%  scale distances by covariance matrix

%  Compute covariance matrix for each class and assume variations
%  over each class is statistically the same.  Note since means
%  are different in each class so these must be removed within each class
%  before computing the covariance matrix.  This can be done
%  with matlab COV command applied to each class as shown below:

covtot = (cov(f1p')+cov(f2p'))/2;  % Average covariances from each class together
cinv = inv(covtot);  % Take inverse

%  Scale feature for the sake of the plot only
[u,s,v] = svd(cinv);  %  Make proportional the inverse standard deviations
stdcinv = v*sqrt(s)*u';
%  Scale all features by the inverse covanance matrix (std version)
f1pws = stdcinv*(f1p); % Scale feature vectors by inverse covariance (STD)
f2pws = stdcinv*(f2p);  
%  find the new mean vectors in terms of the scaled features
smu1 = mean(f1pws,2);
smu2 = mean(f2pws,2);

%  Plot features after scaling
figure
plot(f1pws(1,:),f1pws(2,:),'xr',f2pws(1,:),f2pws(2,:),'og','MarkerSize', 10)
set(gca,'FontSize',12);
xlabel('First Formant Frequency ( g_1 )','FontSize',12)
ylabel('dB of Ratio Formant 3 over 4 ( g_2 )','FontSize',12)
grid
hold on
%  Plot scaled template vectors
plot(smu1(1,:),smu1(2,:),'>r',smu2(1,:),smu2(2,:),'<g','MarkerSize', 18);
legend({'Class 1' 'Class 2'})

%  Apply minimum scaled distance classifier with scaling to class 1 samples
%  (Training set)
d11ws = zeros(1,trnnum);  % Initalize distance vectors with zeros since we index these in a loop
d12ws = zeros(1,trnnum); 
d21ws = zeros(1,trnnum);
d22ws = zeros(1,trnnum);
%  Apply minimum distance classifier with scaling to class 2 samples
%  (Training set)

%  Class 1 distances to each template
for k=1:trnnum
    d11ws(k) = (f1p(:,k)-mu1)'*cinv*(f1p(:,k)-mu1);  % compare class 1 samples with template 1
    d12ws(k) = (f1p(:,k)-mu2)'*cinv*(f1p(:,k)-mu2);  % compare class 1 samples with template 2
end
%  Find all the incorrect classifications (note all should be closest to
%  class 1 templte for this case)
cd1s = find(d11ws > d12ws);  %  Length of cd1s is the number of mis-classifications

% Class 2 distances to each template
for k=1:trnnum
    d21ws(k) = (f2p(:,k)-mu1)'*cinv*(f2p(:,k)-mu1);  % compare class 2 samples with template 1
    d22ws(k) = (f2p(:,k)-mu2)'*cinv*(f2p(:,k)-mu2);  % compare class 2 samples with template 2
end
%  Find all the incorrect classifications (note all should be closest to
%  class 2 templte for this case)
cd2s = find(d22ws > d21ws); %  Length of cd2s is the number of mis-classifications
%  Overall classification error with scaling
classerrws = 100*(length(cd1s)+length(cd2s))/(length(f2) + length(f1));
title(['Training set samples, with Scaling Classification error = ' num2str(classerrws) '%'])
hold off


%  TESTING  - Simulate independent data
%  Apply testing data to classifier without scaling

%  Generate test data and directly apply the classifiers with and without
%  scaling and present the results
f1 = randn(2,tstnum);  % Generate zero-mean uncorrelated fluctuations for class 1 
f2 = randn(2,tstnum);   % Generate zero-mean uncorrelated fluctuations for class 2
[u,s,v] = svd(cv);  %  Decompose Covaraiance with SVD (eigenvalue and vector decomposition)
stdcv = v*sqrt(s)*u';  % recompose with values proportional to std rather than variance
%  Scale independent noise values to set power levels and introduce correlation
f1p = stdcv*f1 + m1*ones(1,length(f1));  %  Add mean template for each sample of class 1
f2p = stdcv*f2 + m2*ones(1,length(f2));  %  Add mean tmplate for each sample of class 2

%  Apply minimum distance classifier with no scaling to class 1 samples
%  (Testing set)
d11 = sqrt(sum((f1p-mu1*ones(1,length(f1))).^2));  % compare class 1 samples with template 1
d12 = sqrt(sum((f1p-mu2*ones(1,length(f1))).^2));  % compare class 1 samples with template 2
%  Find all the correct classification (note all should be closest to
%  class 1 templte for this case)
cd1 = find(d11 > d12);  %  Length of cd1 is the number of mis-classifications

%  Apply minimum distance classifier with no scaling to class 2 samples
%  (Training set)
d21 = sqrt(sum((f2p-mu1*ones(1,length(f2))).^2));
d22 = sqrt(sum((f2p-mu2*ones(1,length(f2))).^2));
%  Find all the correct classification (note all should be closest to
%  class 2 templte for this case)
cd2 = find(d22 > d21); %  Length of cd1 is the number of mis-classifications
%  Overall classification error with scaling
classerrtst = 100*(length(cd1)+length(cd2))/(length(f2) + length(f1));

%  Testing data with scaled classifier distances

%  Apply minimum scaled distance classifier with scaling to class 1 samples
%  (Training set)
d11ws = zeros(1,tstnum);  % Initalize distance vectors
d12ws = zeros(1,tstnum); 
d21ws = zeros(1,tstnum);
d22ws = zeros(1,tstnum);
%  Class 1 distances to each template
for k=1:tstnum
    d11ws(k) = (f1p(:,k)-mu1)'*cinv*(f1p(:,k)-mu1);  % compare class 1 samples with template 1
    d12ws(k) = (f1p(:,k)-mu2)'*cinv*(f1p(:,k)-mu2);  % compare class 1 samples with template 2
end
%  Find all the incorrect classifications (note all should be closest to
%  class 1 templte for this case)
cd1s = find(d11ws > d12ws);  %  Length of cd1s is the number of mis-classifications

%  Apply minimum distance classifier with scaling to class 2 samples
%  (Training set)
% Class 2 distances to each template
for k=1:tstnum
    d21ws(k) = (f2p(:,k)-mu1)'*cinv*(f2p(:,k)-mu1);  % compare class 2 samples with template 1
    d22ws(k) = (f2p(:,k)-mu2)'*cinv*(f2p(:,k)-mu2);  % compare class 2 samples with template 2
end
%  Find all the incorrect classifications (note all should be closest to
%  class 2 templte for this case)
cd2s = find(d22ws > d21ws); %  Length of cd2s is the number of mis-classifications
%  Overall classification error with scaling
classerrtstws = 100*(length(cd1s)+length(cd2s))/(length(f2) + length(f1));
mstr = {['Classification error without scaling = ' num2str(classerrtst) '%'] ...
         ['Classification error with scaling = ' num2str(classerrtstws) '%']};
h = msgbox(mstr, 'Error Report for Test Data');
