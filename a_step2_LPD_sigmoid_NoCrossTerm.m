clear all; clc; format compact

%% sigmoid curve for LPDs
load CCEMRCDATA

%% data elements relevant to LPDs, and possible values
x1 = data.anyLPD; % binary [0,1]                
x2 = data.hasLateralPeriodic; % binary  
x3 = data.LPDfreqmaxfactor; % 1, 1.5, 2, 2.5, 3, nan          
x4 = data.LPDplus; % binary             
x5  = data.LPDSI; % binary               
%LPDprevmost = data.LPDprevmost -- no data
% notes: x1 == x2 always -- completely redundant

%% target events
Y = data.hasseizures; 

%% limit analysis to subjects with finding of interest
ind = find(x1==1); 
x1 = x1(ind); 
x2 = x2(ind); 
x3 = x3(ind); 
x4 = x4(ind); 
x4 = x5(ind); 
Y = Y(ind); 

%% consider balancing the data here -- get equal numbers with & w/o seizures

%% Lasso logistic regression

%% Step 1: prepare data
% try simple model, factors: frequency, plus, frequency x plus
X = [x3 x4 x3.*x4];
Labels = {'Freq','Plus','Freq x Plus'}; 

feature_names=Labels;
Ybool = Y;  % binary

%% Step 2. Create a cross-validated fit.
rng('default') % for reproducibility
[B,FitInfo] = lassoglm(X,Ybool,'binomial','NumLambda',100,'CV',10,'alpha',0.9);
% L=linspace(0.01,0.22,200); 
% [B,FitInfo] = lassoglm(X,Ybool,'binomial','Lambda',L,'CV',10,'alpha',0.9);

%% Step 3. Look at plots to find appropriate regularization.
lassoPlot(B,FitInfo,'PlotType','CV');
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');
indx = FitInfo.IndexMinDeviance;
indx = FitInfo.Index1SE;

B0 = B(:,indx);
nonzeros = sum(B0 ~= 0)
cnst = FitInfo.Intercept(indx);
B1 = [cnst;B0];

%% Step 4. Train using features 
% b = glmfit(xtrain, ytrain, 'binomial', 'link', 'logit');
ind=find(abs(B0)>0); % select features identified by procedure above
x=X(:,ind); b0=[cnst; B0(ind)]; labels=Labels(ind); char(labels); 

% b = glmfit(x, Y, 'binomial', 'link', 'logit');
yfit = glmval(b0, x,'logit');

[X1,Y1,T,AUC] = perfcurve(Y,yfit,1); 
disp(sprintf('AUC: %0.2f%%',100*AUC));

predictors = find(B0); % indices of nonzero predictors
mdl = fitglm(X,Ybool,'linear','Distribution','binomial','PredictorVars',predictors)

% confidence intervals for parameters: 
confint = coefCI(mdl)

%% Step 7 -- show sigmoid
[prediction CI]=predict(mdl,X);

% extract coefficients from mdl -- gives same values as "prediction" above
Xrelevant=X(:,predictors); 
Beta=mdl.Coefficients{:,1};
yData = glmval(Beta, Xrelevant, 'logit');

%% get x values -- B*X
x=Beta(1)*ones(size(Xrelevant,1),1)+Xrelevant*Beta(2:end);

%% show fit sigmoid curve
xx=linspace(min(x),max(x),500); 
yCurve=1./(1+exp(-xx)); 

figure(10); clf; plot(xx,yCurve,'linewidth',2); 



