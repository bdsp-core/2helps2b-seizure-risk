function [yf,b,p] = fcnGetProbabilityCurves_v3(XX,YY)

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
p = stats.p; 
b = b.*(p<0.5); 
% b = stepwisefit(X,Y)
% keyboard
%**********************************
%**********************************


%% probability curve vs frequency -- without +, 
f = linspace(0.25,3,100); 
Xp = zeros(100,1); 
Xp(:,1) = f'; % frequency

z = Xp*b(2:end)+b(1); 
yf = 1./(1+exp(-z)); 