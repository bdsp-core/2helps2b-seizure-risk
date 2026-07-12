clear all; clc; format compact; 
N= 500; 

%% create random labels for the data
y=randsample(2,N,true); % class labels -- to be predicted from x

%% create random data corresponding to the labels -- gaussian, dim = 2, different means
ind1 = find(y==1); sigx1 = .5; sigy1 = 1;  x(ind1,1) = sigx1*randn(length(ind1),1)+1; x(ind1,2) = sigy1*randn(length(ind1),1)+1; 
ind2 = find(y==2); sigx2 = 1;  sigy2 = 1;  x(ind2,1) = sigx2*randn(length(ind2),1)+3; x(ind2,2) = sigy2*randn(length(ind2),1)+2; 

% save these in X and Y (because below we write over x and y)
X = x; 
Y = y; 

%% plot the data
figure(1); clf;
plot(x(ind1,1),x(ind1,2),'ro',x(ind2,1),x(ind2,2),'bx'); 
axis([-1 5 -1 5]); 
axis equal; 

%% fit a binary classifier to the data -- binomial logistic regression
fit=glmnet(x,y,'binomial'); 
cvob=cvglmnet(x,y,'binomial');
cvob.lambda_1se % optimal value of lambda (as determined by cross validation)

%% use the learned model to obtain class probabilities p(y=1|x)
p = glmnetPredict(cvob.glmnet_fit,x,cvob.lambda_1se,'response');

%% visualize what the model has learned: let's plot the probability vs x in 2-dimensions as a contour plot
x = linspace(-1,5,100); 
y = linspace(-1,5,100); 
[xx,yy] = meshgrid(x,x); % grid of points
p = glmnetPredict(cvob.glmnet_fit,[xx(:) yy(:)],cvob.lambda_1se,'response');
p = reshape(p,100,100);
figure(2); clf;  
imagesc(x,y,p); axis xy; 
colormap gray; colorbar; 
axis([-1 5 -1 5]); 
axis tight


%% plot original points on top of probability map
hold on;
plot(X(ind1,1),X(ind1,2),'ro',X(ind2,1),X(ind2,2),'bx'); 
axis([-1 5 -1 5]); 

%% get coefficients at optimal lambda
ind = find(cvob.lambda == cvob.lambda_1se); % find the lambda that minimized the cross validated deviance
b0 = cvob.glmnet_fit.a0(ind); 
b = cvob.glmnet_fit.beta(:,ind); % coefficients of the best model -- for x

% compare to check that we understand the model: compare output of
% "glmnetPredict" with plugging values in to the logistic function p(y=1|x) = 1/(1+exp(-z))
z = b0+X*b;
p1 = 1./(1+exp(-z)); 
p0 = glmnetPredict(cvob.glmnet_fit,X,cvob.lambda_1se,'response');
[p0 p1] % they are identical -- excellent!! 

%% ROC curve
th = linspace(-0.1,1.1,1000); 
for i = 1:length(th)
   YH = ones(size(Y)); 
   ind = find(p0>th(i)); YH(ind)=2;  % predicted class using threshold th(i)
   se(i) = sum(YH==2 & Y==2)/sum(Y==2); 
   fp(i) = sum(YH==2 & Y==1)/sum(Y==1); 
end

figure(3); clf;
stairs(fp,se,'k','linewidth',2); 
box off
set(gcf,'color','w'); 
xlabel('FPR = 1-spec'); 
ylabel('Sens'); 
title('ROC curve'); 



%% get probabilities out using optimal coeffs
%% plot probabilities vs z
%% roc curve from proabibilities

