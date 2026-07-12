function [pred,ci,xx,x,y,n] = fcnGetBinomialFit_v2(data,featureName,featureName2,plotIt); 

%% target events for prediction
y = data.hasseizures; 

%% data elements relevant to feature of interest and possible values
eval(['x1 = data.any' featureName ';']); % binary [0,1]                
eval(['x2 = data.has' featureName2 ';']); % binary  
eval(['x3 = data.' featureName 'freqmaxfactor;']); % 1, 1.5, 2, 2.5, 3, nan          
eval(['x4 = data.' featureName 'plus;']);  % binary             
eval(['x5  = data.' featureName 'SI;']);  % binary               
%LPDprevmost = data.LPDprevmost -- no data
% notes: x1 == x2 always -- completely redundant

%% limit analysis to subjects with finding of interest
ind = find(x1==1); 
f = x3(ind); 
s = y(ind); 

%ind = find(isnan(f)); f(ind) = 1; 
ff = [1 1.5 2 2.5 3]
ct=1; 
x=[]; y=[]; n=[];
ind = find(isnan(f)); x(ct) = .5; n(ct) = length(ind); y(ct) = sum(s(ind)); 
for i=1:length(ff); 
    ind = find(f==ff(i)); 
    disp(sum(s(ind))/length(ind)); 
    
    ct=ct+1; 
    x(ct) = ff(i); n(ct) = length(ind); y(ct) = sum(s(ind));     
end
x=x'; y=y'; n=n';

%% 
xx = linspace(min(x),max(x),100); 
mdl = fitglm(x,[y n], 'linear','Distribution','binomial','link','logit')
b = mdl.Coefficients.Estimate;
C = mdl.CoefficientCovariance;
[pred,ci] = predict(mdl,xx');

if plotIt ==1; 
    figure(1); clf; 
    plot(x, y./n,'o',xx,pred,'k',xx,ci(:,1),'r--',xx,ci(:,2),'r--','LineWidth',2)
    ylim([0 1]); 
end

