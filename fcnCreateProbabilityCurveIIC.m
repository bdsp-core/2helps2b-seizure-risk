function fcnCreateProbabilityCurveIIC(data,featureName,featureName2); 


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
x(:,1) = x1(ind); 
x(:,2) = x2(ind); 
x(:,3) = x3(ind); % frequency
x(:,4) = x4(ind); % plus
x(:,5) = x5(ind); % SI
x(isnan(x))=0; % set nan's to 0 [not present]
YY = y(ind); 
XX = x(:,[3 4 5]);
Labels = {'Freq','Plus','SI'}; 

[y00,y01,y10,y11,b,dev,stats] = fcnGetProbabilityCurves(XX,YY);

%% probability curve vs frequency -- without +, without SI
f = linspace(0.25,3,100); 

figure(1); clf; 
p = max(y00); c0 = [1 0 0]; c1 = [1 1 0]; c = c0*p+(1-p)*c1; % line color 
figure(1); hold on; plot(f,y00,'color',c,'linewidth',2); 

%% probability curve vs frequency -- with +, without SI
p = max(y10); c0 = [1 0 0]; c1 = [1 1 0]; c = c0*p+(1-p)*c1; % line color 
figure(1); hold on; plot(f,y10,'color',c,'linewidth',2); 

%% probability curve vs frequency -- without +, with SI
p = max(y01); c0 = [1 0 0]; c1 = [1 1 0]; c = c0*p+(1-p)*c1; % line color 
figure(1); hold on; plot(f,y01,'color',c,'linewidth',2); 

%% probability curve vs frequency -- with +, with SI
p = max(y11); c0 = [1 0 0]; c1 = [1 1 0]; c = c0*p+(1-p)*c1; % line color 
figure(1); hold on; plot(f,y11,'color',c,'linewidth',2); 

%% make the figure prettier
set(gca,'tickdir','out'); 
grid on
set(gcf,'color','w'); 
xlabel('Frequency [Hz]'); 
ylabel('Probability'); 
title(sprintf('Probability of seizures vs frequency for %s',featureName)); 
axis([0.25 3 0 1]); 

LineLabels={'-Plus, -SI','+Plus,-SI','-Plus,+SI','+Plus,+SI'}; 
x = 1; y = y00(28); text(x,y,LineLabels{1}); 
x = 1; y = y10(28); text(x,y,LineLabels{2}); 
x = 1; y = y01(28); text(x,y,LineLabels{3}); 
x = 1; y = y11(28); text(x,y,LineLabels{4}); 

%% expore figure as .png
fig = gcf;
fig.PaperPositionMode = 'auto';
figureName = ['Fig_' featureName '_Probability']; 
print(figureName,'-dpng','-r300');
