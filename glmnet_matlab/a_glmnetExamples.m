clear all; clc; format compact; 

%% examples using glmnet

% Gaussian
% x=randn(100,20); y=randn(100,1);
n = 100; 
x0 = randn(n,2)+.51; y0 = zeros(n,1); 
x1 = randn(n,2)-.51; y1 = ones(n,1); 

x = [x0; x1]; 
x = [x randn(size(x,1),15)];
y = [y0; y1];

% fit1 = glmnet(x,y);
% fit1=glmnet(x,y,'binomial')
% glmnetPrint(fit1);
% % glmnetPredict(fit1,[],0.01,'coef')           %extract coefficients at a single value of lambda
% % glmnetPredict(fit1,x(1:10,:),[0.01,0.005]')  %make predictions
% 
% glmnetPredict(fit1, x(1:10,:),[], 'response')
% 
% figure(1); clf; 
% plot(x0(:,1),x0(:,2),'bo'); hold on
% plot(x1(:,1),x1(:,2),'rx'); 
% 
% %%
% d = fit1.dev; l = fit1.lambda; figure(1); clf; plot(log(l),d)
% figure(2); clf; 
% glmnetPlot(fit1);

clear all; clc; format compact 

%% Play with glmnet
% addpath(genpath('..\..\Matlab\glmnet_matlab'));

n=1000; p=100; nzc=fix(p/10); 

x=randn(n,p);
beta=randn(nzc,1); % random model coefficients
fx=x(:,1:nzc) * beta; eps=randn(n,1)*5; y=fx+eps; px=exp(fx); px=px./(1+px);
ly=binornd(1,px,length(px),1);   

%% fit logistic regression model
cvob1=cvglmnet(x,y) % default is 10 folds of cv
cvglmnetPlot(cvob1);
cvglmnetCoef(cvob1) % Default is the value s='lambda_1se'
pred=cvglmnetPredict(cvob1,x(1:5,:),'lambda_min'); % give back coefficients - min
pred=cvglmnetPredict(cvob1,x); % give back coefficients - min


% cvobla=cvglmnet(x,y,[],[],'mae');
% cvglmnetPlot(cvobla);
% 
% cvob2=cvglmnet(x,ly,'binomial');
% cvglmnetPlot(cvob2);

cvob3=cvglmnet(x,ly,'binomial',[],'class');
cvglmnetPlot(cvob3);

%% OPTIMIZE AUC
cvob4=cvglmnet(x,ly,'binomial',[],'auc');
cvglmnetPlot(cvob4);

% get back coefficients
c=cvglmnetCoef(cvob4) % Default is the value s='lambda_1se'

% make predictions
pred=cvglmnetPredict(cvob4,x); 
