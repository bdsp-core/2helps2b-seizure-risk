function [labels,AUC]=fcnGetFeaturesAndAUC_UsingLasso(X,Y,Labels,featureName); 

%% Step 1: prepare data
% try simple model, factors: frequency, plus, frequency x plus

feature_names=Labels;
Ybool = Y;  % binary

%% Step 2. Create a cross-validated fit.
% rng('default') % for reproducibility
[B,FitInfo] = lassoglm(X,Ybool,'binomial','NumLambda',100,'CV',10,'alpha',0.9);
% L=linspace(0.01,0.22,200); 
% [B,FitInfo] = lassoglm(X,Ybool,'binomial','Lambda',L,'CV',10,'alpha',0.9);

%% Step 3. Look at plots to find appropriate regularization.
lassoPlot(B,FitInfo,'PlotType','CV');
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');
indx = FitInfo.IndexMinDeviance;
indx = FitInfo.Index1SE;

B0 = B(:,indx);
nonzeros = sum(B0 ~= 0);
cnst = FitInfo.Intercept(indx);
B1 = [cnst;B0];

%% Step 4. Train using features 
% b = glmfit(xtrain, ytrain, 'binomial', 'link', 'logit');
ind=find(abs(B0)>0); % select features identified by procedure above
x=X(:,ind); b0=[cnst; B0(ind)]; labels=Labels(ind); 

yfit = glmval(b0, x,'logit');
[X1,Y1,T,AUC] = perfcurve(Y,yfit,1); 
close all