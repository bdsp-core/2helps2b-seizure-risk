function [y0,y1,b] = fcnGetProbabilityCurves_v2(XX,YY)

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
% b = stepwisefit(X,Y)
% keyboard
%**********************************
%**********************************

% [B,FitInfo] = lassoglm(X,Y,'binomial','NumLambda',100,'CV',10,'alpha',0.5);
% 
% %% Step 3. Look at plots to find appropriate regularization.
% % lassoPlot(B,FitInfo,'PlotType','CV');
% % lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log');
% indx = FitInfo.IndexMinDeviance;
% indx = FitInfo.Index1SE;
% 
% B0 = B(:,indx);
% nonzeros = sum(B0 ~= 0);
% cnst = FitInfo.Intercept(indx);
% B1 = [cnst;B0];
% b = B1; 

%% Step 4. Train using features 


%% probability curve vs frequency -- without +, 
f = linspace(0.25,3,100); 
Xp = zeros(100,2); 
Xp(:,1) = f'; % frequency
Xp(:,2) = 0; % plus feature

z = Xp*b(2:end)+b(1); 
y0 = 1./(1+exp(-z)); 

%% probability curve vs frequency -- with +, with SI
Xp(:,2) = 1; % plus feature

z = Xp*b(2:end)+b(1); 
y1 = 1./(1+exp(-z)); 
