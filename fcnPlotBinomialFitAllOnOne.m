function fcnPlotBinomialFitAllOnOne(i,f,yf,ci,x,y,n,featureName); 
%% make plots for binomial fits

%% put all curves on one plot
Labels = {'LPD','GPD','LRDA','GRDA'}; 
C=linspecer(4);
c = C(i,:); 

figure(3); hold on; 

plot(f,yf(i,:),'color',c,'linewidth',3); hold on; 
xx = [f fliplr(f)]; yy = [ci(:,1)' fliplr(ci(:,2)')];
h = patch(xx,yy,c);
h.FaceAlpha = 0.2; 
h.EdgeColor = 'none';
plot(x, y./n,'o','color',c)

% make the figure prettier
title(Labels{i}); 
set(gca,'tickdir','out'); 
grid on
set(gcf,'color','w'); 
xlabel('Frequency [Hz]'); 
ylabel('Probability'); 
title(sprintf('%s',featureName)); 
axis([.5 3 0 1]); 
axis square
