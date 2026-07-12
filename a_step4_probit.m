%% clear all; clc; format compact; 

% try probit regression

load CCEMRCDATA
f = data.GPDfreqmaxfactor; 
f = data.LRDAfreqmaxfactor;
s = data.hasseizures; 

%ind = find(isnan(f)); f(ind) = 1; 
ff = [1 1.5 2 2.5 3]
ind = find(isnan(f)); 
disp(sum(s(ind))/length(ind)); 
ct=1; 
x=[]; y=[]; n=[];
x(ct) = .5; n(ct) = length(ind); y(ct) = sum(s(ind)); 
for i=1:length(ff); 
    ind = find(f==ff(i)); 
    disp(sum(s(ind))/length(ind)); 
    
    ct=ct+1; 
    x(ct) = ff(i); n(ct) = length(ind); y(ct) = sum(s(ind));     
end
x=x'; y=y'; n=n';
%%

b = glmfit(x,[y n],'binomial','link','probit');
xx = linspace(min(x),max(x),100); 
yfit = glmval(b,xx,'probit');


%% 
mdl = fitglm(x,[y n], 'linear','Distribution','binomial','link','logit')
b = mdl.Coefficients.Estimate;
C = mdl.CoefficientCovariance;
[pred,ci] = predict(mdl,xx');

figure(1); clf; 
plot(x, y./n,'o',xx,pred,'k',xx,ci(:,1),'r--',xx,ci(:,2),'r--','LineWidth',2)

% plotSlice(mdl)
% ci = coefCI(mdl);
% 
% figure(1); clf; 
% plot(x, y./n,'o',xx,normcdf(b(1)+b(2)*xx),'LineWidth',2);
% hold on; 

ylim([0 1]); 

