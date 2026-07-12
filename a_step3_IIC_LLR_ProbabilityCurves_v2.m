clear all; clc; format compact

%% some curves are turning out weird; suspect I may be overfitting
% potential n   solutions: 
% -- look at balancing data + bayes
% -- go back to lasso procedure for this part, too
% -- bootstrapping with lasso is probably best


%% sigmoid curve for LPDs
load CCEMRCDATA
N = 100; % number of times to repeat -- getting bootstrap estimate of AUC CI

%% sanity check on frequencies
d = sum(data.anyLPD); 
n = sum(data.anyLPD & data.hasseizures)
disp([n d n/d]); 
pp(1) = n/d; 

d = sum(data.anyGPD); 
n = sum(data.anyGPD & data.hasseizures)
disp([n d n/d]); 
pp(2) = n/d; 

d = sum(data.anyLRDA); 
n = sum(data.anyLRDA & data.hasseizures)
disp([n d n/d]); 
pp(3) = n/d; 

d = sum(data.anyGRDA); 
n = sum(data.anyGRDA & data.hasseizures)
disp([n d n/d]); 
pp(4) = n/d; 

figure(2); clf; 
figure(3); clf; 
%%
disp('**********************'); 
featureName = 'LPD'; featureName2 = 'LateralPeriodic'; 
% [yf(1,:),p(:,1),b(:,1),f]=fcnCreateProbabilityCurveIIC_v3(data,featureName,featureName2);
[pred,ci,f,x,y,n] = fcnGetBinomialFit_v2(data,featureName,featureName2,1);
yf(1,:) = pred';
fcnPlotBinomialFit(1,f,yf,ci,x,y,n,featureName); 
fcnPlotBinomialFitAllOnOne(1,f,yf,ci,x,y,n,featureName); 


%%
disp('**********************'); 
featureName = 'GPD'; featureName2 = 'GeneralizedPeriodic'; 
% [yf(2,:),p(:,2),b(:,2),f]=fcnCreateProbabilityCurveIIC_v3(data,featureName,featureName2);
[pred,ci,f,x,y,n] = fcnGetBinomialFit_v2(data,featureName,featureName2,1);
yf(2,:) = pred';
fcnPlotBinomialFit(2,f,yf,ci,x,y,n,featureName); 
fcnPlotBinomialFitAllOnOne(2,f,yf,ci,x,y,n,featureName); 

%%
disp('**********************'); 
featureName = 'LRDA'; featureName2 = 'LateralRhythmic'; 
%[yf(3,:),p(:,3),b(:,3),f]=fcnCreateProbabilityCurveIIC_v3(data,featureName,featureName2);
[pred,ci,f,x,y,n] = fcnGetBinomialFit_v2(data,featureName,featureName2,1);
yf(3,:) = pred';
fcnPlotBinomialFit(3,f,yf,ci,x,y,n,featureName); 
fcnPlotBinomialFitAllOnOne(3,f,yf,ci,x,y,n,featureName); 

%%
disp('**********************'); 
featureName = 'GRDA'; featureName2 = 'GeneralizedRhythmic'; 
% [yf(4,:),p(:,4),b(:,4),f]=fcnCreateProbabilityCurveIIC_v3(data,featureName,featureName2);
[pred,ci,f,x,y,n] = fcnGetBinomialFit_v2(data,featureName,featureName2,1);
yf(4,:) = pred';
fcnPlotBinomialFit(4,f,yf,ci,x,y,n,featureName); 
fcnPlotBinomialFitAllOnOne(4,f,yf,ci,x,y,n,featureName); 

%% put all curves on one plot
figure(1); clf; 
Labels = {'LPD','GPD','LRDA','GRDA'}; 
C=linspecer(4);
for i=1:4; 
    c = C(i,:); 
    figure(1); hold on; plot(f,yf(i,:),'color',c,'linewidth',6); 
    y = min(yf(i,:)); x = 0.3; 
    text(x,y,Labels{i}); 
end

% make the figure prettier
set(gca,'tickdir','out'); 
grid on
set(gcf,'color','w'); 
xlabel('Frequency [Hz]'); 
ylabel('Probability'); 
title(sprintf('Probability of seizures vs frequency for %s',featureName)); 
axis([0.25 3 0 1]); 

% expore figure as .png
figure(3); 
fig = gcf;
fig.PaperPositionMode = 'auto';
figureName = ['Fig_IIC_Freq_Probability']; 
print(figureName,'-dpng','-r300');

figure(2); 
fig = gcf;
fig.PaperPositionMode = 'auto';
figureName = ['Fig_IIC_Freq_ProbabilityEachAlone']; 
print(figureName,'-dpng','-r300');


