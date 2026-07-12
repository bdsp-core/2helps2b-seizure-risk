function [y00,y01,y10,y11,b,dev,stats] = fcnGetProbabilityCurves(XX,YY)

i0 = find(YY==1); X1 = XX(i0,:); n0 = length(i0); 
i1 = find(YY==0); X0 = XX(i1,:); n1 = length(i1); 

%% get probability curves using random sample of the data [getting bootstrapped estimate]
% xx0 = datasample(X0,n0,1); % returns a sample taken along dimension dim of data.
% xx1 = datasample(X1,n1,1); % returns a sample taken along dimension dim of data
yy0 = zeros(n0,1); yy1 = ones(n1,1); 
X = [X0; X1]; 
% X = [xx0; xx1]; 
Y = [yy0; yy1]; 

%% *******************************
% fit without using lasso

[b,dev,stats] = glmfit(X, Y, 'binomial', 'link', 'logit');

%**********************************
%**********************************

[B,FitInfo] = lassoglm(X,Y,'binomial','NumLambda',100,'CV',10,'alpha',0.9);
% L=linspace(0.01,0.22,200); 
% [B,FitInfo] = lassoglm(X,Ybool,'binomial','Lambda',L,'CV',10,'alpha',0.9);

%% Step 3. Look at plots to find appropriate regularization.
% lassoPlot(B,FitInfo,'PlotType','CV');
% lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');
indx = FitInfo.IndexMinDeviance;
indx = FitInfo.Index1SE;

B0 = B(:,indx);
nonzeros = sum(B0 ~= 0);
cnst = FitInfo.Intercept(indx);
B1 = [cnst;B0];
b = B1; 

%% Step 4. Train using features 
% b = glmfit(xtrain, ytrain, 'binomial', 'link', 'logit');
% ind=find(abs(B0)>0); % select features identified by procedure above
% x=X(:,ind); b0=[cnst; B0(ind)]; labels=Labels(ind); 

yfit = glmval(b, X,'logit');


%**********************************
%**********************************


%% probability curve vs frequency -- without +, without SI
f = linspace(0.25,3,100); 
Xp = zeros(100,3); 
Xp(:,1) = f'; % frequency
Xp(:,2) = 0; % plus feature
Xp(:,3) = 0; % SI feature

z = Xp*b(2:end)+b(1); 
y00 = 1./(1+exp(-z)); 


%% probability curve vs frequency -- with +, without SI
Xp(:,2) = 1; % plus feature
Xp(:,3) = 0; % SI feature

z = Xp*b(2:end)+b(1); 
y10 = 1./(1+exp(-z)); 


%% probability curve vs frequency -- without +, with SI
Xp(:,2) = 0; % plus feature
Xp(:,3) = 1; % SI feature

z = Xp*b(2:end)+b(1); 
y01 = 1./(1+exp(-z)); 


%% probability curve vs frequency -- with +, with SI
Xp(:,2) = 1; % plus feature
Xp(:,3) = 1; % SI feature

z = Xp*b(2:end)+b(1); 
y11 = 1./(1+exp(-z)); 
