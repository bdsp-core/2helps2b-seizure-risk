clear all; clc; format compact

%% sigmoid curve for LPDs
load CCEMRCDATA
N = 100; % number of times to repeat -- getting bootstrap estimate of AUC CI

%%
disp('**********************'); 
featureName = 'LPD'; featureName2 = 'LateralPeriodic'; 
AUC(:,1) = fcn_runFcnGetFeaturesAndAUC_UsingLasso(data,featureName,featureName2,N); 

%%
disp('**********************'); 
featureName = 'GPD'; featureName2 = 'GeneralizedPeriodic'; 
AUC(:,2) = fcn_runFcnGetFeaturesAndAUC_UsingLasso(data,featureName,featureName2,N);

%%
disp('**********************'); 
featureName = 'LRDA'; featureName2 = 'LateralRhythmic'; 
AUC(:,3) = fcn_runFcnGetFeaturesAndAUC_UsingLasso(data,featureName,featureName2,N);

%%
disp('**********************'); 
featureName = 'GRDA'; featureName2 = 'GeneralizedRhythmic'; 
AUC(:,4) = fcn_runFcnGetFeaturesAndAUC_UsingLasso(data,featureName,featureName2,N); 

%% save results -- don't want to run this again if it can be avoided!
save AUC_INDIVIDUAL_IIC_RESULTS AUC 

%% box plots
figure(1); clf; 
Labels = {'LPD','GPD','LRDA','GRDA'}; 
boxplot(AUC,'widths',0.5,'labels',Labels);
h = findobj(gca,'Tag','Box');
 for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),'k','FaceAlpha',.5);
 end
h = findobj(gca,'Tag','Median');
set(h,'linewidth',2,'color','r');

 
hold on
xmin = 0.5; xmax = 4.5; 
% plot([xmin xmax],[0.5 .5],'r--','linewidth',1); 
axis([xmin xmax 0.49 1]); 
title('AUC for models using frequency, plus, SI'); 
set(gcf,'color','w'); 
set(gca,'ygrid','on'); 

%% expore figure as .png
fig = gcf;
fig.PaperPositionMode = 'auto';
print('Fig_AUC','-dpng','-r300')
