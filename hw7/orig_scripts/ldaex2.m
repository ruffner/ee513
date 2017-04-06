%  This script illustrates Linear Discriminant Anlaysis using Gaussian random
%  distribution for all features and separate standard deviations and means
%  for each feature can be set.  In this version, the means and variances
%  for each feature can be different, but must be typed in for each.  If
%  the number of features is 2, then a 2D plot with feature measurments,
%  projection line and a sample decision boundary are plotted.
%
%  Written by Kevin D. Donohue (donohue@engr.uky.edu) November 2006


ntrain0 = 50;  %  Number of training samples in class 0
ntrain1 = 50;  %  Number of training samples in class 1
ntest0 = 100;  %  Number of training samples in class 0
ntest1 = 100;  %  Number of training samples in class 1


m0 =  [-2; -3]; % means for each feature in class 0
m1 = [1; 2]; % means for each feature in class 1
s0 = [2; 3]; % standard deviation for each feature in class 0
s1 = [3; 2];  % standard deviaion for each feature in class 1
nfeature = length(m1);  %  Number of features used to discriminate processes

nruns = 10;   %  Number of monte carlo runs

%  Monte Carlo Loop (generate a signls for each class, extract 
%  and store labeled features
for k =1:nruns
    %  Generate matrix of random numbers to represent feature measurments
    %  from each class:
    clstrn0 = (s0*ones(1,ntrain0)).*randn(nfeature,ntrain0)+(m0*ones(1,ntrain0)); % Training 0
    clstrn1 = (s1*ones(1,ntrain1)).*randn(nfeature,ntrain1)+(m1*ones(1,ntrain1)); % Training 1
    clstest0 = (s0*ones(1,ntest0)).*randn(nfeature,ntest0)+(m0*ones(1,ntest0));   % Test 0
    clstest1 = (s1*ones(1,ntest1)).*randn(nfeature,ntest1)+(m1*ones(1,ntest1));   % Test 1
    %  Compute statistics form training set for classifier
    mm0 = mean(clstrn0,2);  %  Mean of class 0 features
    mm1 = mean(clstrn1,2);  %  Mean of class 1 features
    sm0 = (ntrain0-1)*cov(clstrn0');  % Scatter matrix for class 0
    sm1 = (ntrain1-1)*cov(clstrn1');  % Scatter matrix for class 1
    sminv = inv(sm0+sm1);     %  Take inverse of combined scatter matrices      
    v = sminv*(mm1-mm0);     %  Use mean difference vector to compute projection vector (classifier)
    %  If 2 features are present plot them
    if nfeature == 2
        figure(1)
        set(gcf,'Position',[92   450   314   286]);
        %  Plot feature measurments for each class in training data
        plot(clstrn0(1,:),clstrn0(2,:),'bo'); hold on; plot(clstrn1(1,:),clstrn1(2,:),'rx');
        xa = get(gca,'Xlim');
        %  Compute Threshold for equal a priori probablilities and covariance matrices 
        mnp = (mm0'*sminv*mm0+mm1'*sminv*mm1)/2;
        %  Plot projection axis (green)
        plot(xa,(v(1)/v(2))*(xa-mnp(1))-mnp,'g-');
        %  Plot decision boundary between means of both classes (black)
        plot(xa,(-v(2)/v(1))*(xa-mnp(1))-mnp,'k-','Linewidth',3);
        hold off
        xlabel('Feature 1')
        ylabel('Feature 2')
        title('Training Data')
        figure(2)
        set(gcf,'Position',[417   440   314   286]);
        %  Plot feature measurments for each class in testing data
        plot(clstest0(1,:),clstest0(2,:),'bo'); hold on; plot(clstest1(1,:),clstest1(2,:),'rx');
        xa = get(gca,'Xlim');
       %  Compute Threshold for equal a priori probablilities and covariance matrices 
        mnp = (mm0'*sminv*mm0+mm1'*sminv*mm1)/2;
        %  Plot projection axis (green)
        plot(xa,(v(1)/v(2))*(xa-mnp(1))-mnp,'g-');
        %  Plot decision boundary between means of both classes (black)
        plot(xa,(-v(2)/v(1))*(xa-mnp(1))-mnp,'k-','Linewidth',3);
        hold off
        xlabel('Feature 1')
        ylabel('Feature 2')
        title('Testing Data')
    end
    %  Apply classifier to testing data 
    testout0 = (v')*clstest0;
    testout1 = (v')*clstest1;
    %  Apply classifier to training data
    trnout0 = (v')*clstrn0;
    trnout1 = (v')*clstrn1;
    figure(3)
    set(gcf,'Position',[88    90   314   286]);
    %  Plot training data after classification
    plot(trnout0,'bo'); hold on; plot(trnout1,'rx'); hold off
    title('Training Data Results (after projection)')
    xlabel('feature index')
    ylabel('Decision Statistic')
    figure(4)
    set(gcf,'Position',[425    89   314   286]);
    %  Plot testing data after classification
    plot(testout0,'bo'); hold on; plot(testout1,'rx'); hold off
    title('Test Data Results (after projection)')
    xlabel('feature index')
    ylabel('Decision Statistic')
    %  Compute and store classification error
    minclasser(k) = roc(testout1,testout0);
    pause
end
figure(5)
plot(100*minclasser)
xlabel('Monte Carlo Index')
ylabel('% classification error')
title(['Classification error = ' num2str(100*mean(minclasser)) ...
        '%, std of estimate = ' num2str(100*std(minclasser))]) 