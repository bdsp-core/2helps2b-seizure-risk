function [pred,ci] = fcnGetBinomialFit(f,s); 

%% fit binomial model to the data with logit link [glm]
% try probit regression

load CCEMRCDATA
f = data.GPDfreqmaxfactor; 
f = data.LRDAfreqmaxfactor;
s = data.hasseizures; 

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
mdl = fitglm(x,[y n], 'linear','Distribution','binomial','link','logit')
b = mdl.Coefficients.Estimate;
C = mdl.CoefficientCovariance;
[pred,ci] = predict(mdl,xx');

if plotIt ==1; 
    figure(1); clf; 
    plot(x, y./n,'o',xx,pred,'k',xx,ci(:,1),'r--',xx,ci(:,2),'r--','LineWidth',2)
    ylim([0 1]); 
end

