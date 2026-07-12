clear all; clc; format compact; 
N= 500; 
n = N/5; 

%% create labels for the data
% create random data corresponding to the labels -- gaussian, dim = 2, different means
mx = randn(5,1)*5; 
my = randn(5,1)*5; 
y=randsample(5,N,true); % class labels -- to be predicted from x
m = randn(5,1)*5;
b = randn(5,1)*5; 
cc = randn(5,1)*15; 

c = 'krbgm';
for i = 1:N
   x(i,1) = mx(y(i))+randn*3;
   x(i,2) = my(y(i))+randn*3; 
end

%% plot the data, indicate class label with color
figure(1); clf;
for i = 1:5 
    ind = find(y==i); 
    plot(x(ind,1),x(ind,2),'x','color',c(i)); hold on;
end
axis([-10 10 -10 10]);
axis square
set(gcf,'color','w'); 
xlabel('x'); 
ylabel('y'); 

%% fit a classifier to the data -- multinomial logistic regression
% fit=glmnet(x,y,'multinomial'); 
cvob=cvglmnet(x,y,'multinomial');
cvob.lambda_1se % optimal value of lambda (as determined by cross validation)

%% use the learned model to obtain class probabilities p(y=1|x)
p = glmnetPredict(cvob.glmnet_fit,x,cvob.lambda_1se,'response');

%% visualize what the model has learned
xxx = linspace(-10,10,500); 
yyy = linspace(-10,10,500); 
[xx,yy] = meshgrid(xxx,xxx); % grid of points
p = glmnetPredict(cvob.glmnet_fit,[xx(:) yy(:)],cvob.lambda_1se,'response');

%% draw the decision regions -- region where each class is the most probable class
figure(2); clf; 
[~,z] = max(p');
xx = xx(:); 
yy = yy(:); 
for i = 1:5
    ind = find(z==i); 
    DT = delaunayTriangulation(xx(ind),yy(ind));
    k = convexHull(DT)
    plot(DT.Points(k,1),DT.Points(k,2),'color',c(i),'linewidth',1); hold on; 
    patch(DT.Points(k,1),DT.Points(k,2),c(i),'facealpha',0.051,'edgecolor','none'); hold on
end

for i = 1:5 
    ind = find(y==i); 
    plot(x(ind,1),x(ind,2),'x','color',c(i)); hold on;
end

axis([-10 10 -10 10]);

xlabel('x'); 
ylabel('y'); 
set(gcf,'color','w'); 
axis square

title('demo of multiclass logistic regresssion'); 

%% calculate confusion matrix, display as bar plot
C = zeros(5,5); 
Cn = C; 
p = glmnetPredict(cvob.glmnet_fit,x,cvob.lambda_1se,'response');
[~,z] = max(p'); 
for i = 1:5
    ind = find(y==i); 
    for j = 1:5
       C(i,j) = sum(z(ind)==j);  
    end
    Cn(i,:) = C(i,:)/sum(C(i,:)); 
end
disp('*************'); 
disp('confusion matrix'); 
disp(C); 
disp('*************'); 
disp(Cn)
%% stacked bar plot 
disp('*************'); 
figure(3); 
bar(1:5, Cn, 0.5, 'stack')



