clear all; clc; format compact; 

%% examples using glmnet

% create some data
n = 100; 
x0 = randn(n,2)+.5; y0 = zeros(n,1); 
x1 = randn(n,2)-.5; y1 = ones(n,1); 

x = [x0; x1]; x = [x randn(size(x,1),15)];
y = [y0; y1]; 

figure(1); clf; 
plot(x0(:,1),x0(:,2),'bo'); hold on
plot(x1(:,1),x1(:,2),'rx'); 

%% fit logistic regression model
cvob1=cvglmnet(x,y,'binomial') % default is 10 folds of cv
cvglmnetPlot(cvob1);
cvglmnetCoef(cvob1) % Default is the value s='lambda_1se'
pred=cvglmnetPredict(cvob1,x,'lambda_min'); % give back coefficients - min
y = exp(pred)./(1+exp(pred)); 

% get coefficients back, show that we get same result
c=cvglmnetCoef(cvob1,'lambda_min');
b0 = c(1); b = c(2:end); 
yc = 1./(1+exp(-(b0 + x*b))); 

figure(2); clf; 
plot(y); hold on;  
plot(yc,'r'); 


