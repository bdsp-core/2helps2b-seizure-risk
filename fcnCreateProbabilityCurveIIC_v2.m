function fcnCreateProbabilityCurveIIC_v2(data,featureName,featureName2); 


%% target events for prediction
y = data.hasseizures; 

%% data elements relevant to feature of interest and possible values
eval(['x1 = data.any' featureName ';']); % binary [0,1]                
eval(['x2 = data.has' featureName2 ';']); % binary  
eval(['x3 = data.' featureName 'freqmaxfactor;']); % 1, 1.5, 2, 2.5, 3, nan          
eval(['x4 = data.' featureName 'plus;']);  % binary             
%LPDprevmost = data.LPDprevmost -- no data
% notes: x1 == x2 always -- completely redundant

%% limit analysis to subjects with finding of interest
ind = find(x1==1); 
x(:,1) = x1(ind); 
x(:,2) = x2(ind); 
x(:,3) = x3(ind); % frequency
x(:,4) = x4(ind); % plus
y=y(ind); 
for i = 1:4; 
%    temp = x(:,i); 
%    temp(isnan(temp)) = nanmedian(temp); 
%    x(:,i)=temp; 
    ind = find(isnan(x(:,i))); 
    x(ind,:)=[];
    y(ind)=[];
end

%x(isnan(x))=0; % set nan's to 0 [not present]
YY = y; 
XX = x(:,[3 4]);

Labels = {'Freq','Plus'}; 

[y0,y1,b] = fcnGetProbabilityCurves_v2(XX,YY)

%% probability curve vs frequency -- without +, without SI
f = linspace(0.25,3,100); 

figure(1); clf; 
p = max(y0); c0 = [1 0 0]; c1 = [1 1 0]; c = c0*p+(1-p)*c1; % line color 
figure(1); hold on; plot(f,y0,'color',c,'linewidth',2); 

%% probability curve vs frequency -- with +, with SI
p = max(y1); c0 = [1 0 0]; c1 = [1 1 0]; c = c0*p+(1-p)*c1; % line color 
figure(1); hold on; plot(f,y1,'color',c,'linewidth',2); 

%% make the figure prettier
set(gca,'tickdir','out'); 
grid on
set(gcf,'color','w'); 
xlabel('Frequency [Hz]'); 
ylabel('Probability'); 
title(sprintf('Probability of seizures vs frequency for %s',featureName)); 
axis([0.25 3 0 1]); 

plusName = [featureName '+']; 
LineLabels={featureName,plusName}; 
x = 1; y = y0(28); text(x,y,LineLabels{1}); 
x = 1; y = y1(28); text(x,y,LineLabels{2}); 

%% expore figure as .png
fig = gcf;
fig.PaperPositionMode = 'auto';
figureName = ['Fig_' featureName '_Probability']; 
print(figureName,'-dpng','-r300');


%% 
v = unique(XX(:,1)); 
for i = 1:length(v); 
   % histogram for no plus
   n = sum(XX(:,1)==v(i) & XX(:,2)==0 & YY==1); 
   d = sum(XX(:,1)==v(i) & XX(:,2)==0); 
   h0(i) = n/d; 
    
end

v = unique(XX(:,1)); 
for i = 1:length(v); 
   % histogram for no plus
   n = sum(XX(:,1)==v(i) & XX(:,2)==1 & YY==1); 
   d = sum(XX(:,1)==v(i) & XX(:,2)==1); 
   h1(i) = n/d;     
end

v0 = unique(XX(:,1)); 
for i = 1:length(v); 
   % histogram for no plus
   n(i) = sum(XX(:,1)==v(i)  & YY==1); 
   d(i) = sum(XX(:,1)==v(i)); 
   h(i) = n/d; 
    
end

