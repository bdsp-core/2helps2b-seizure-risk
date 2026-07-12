function AUC = fcn_runFcnGetFeaturesAndAUC_UsingLasso(data,featureName,featureName2,N); 

%% target events for prediction
y = data.hasseizures; 

%% data elements relevant to feature of interest and possible values
eval(['x1 = data.any' featureName ';']); % binary [0,1]                
eval(['x2 = data.has' featureName2 ';']); % binary  
eval(['x3 = data.' featureName 'freqmaxfactor;']); % 1, 1.5, 2, 2.5, 3, nan          
eval(['x4 = data.' featureName 'plus;']);  % binary             
eval(['x5  = data.' featureName 'SI;']);  % binary               
%LPDprevmost = data.LPDprevmost -- no data
% notes: x1 == x2 always -- completely redundant

%% limit analysis to subjects with finding of interest
ind = find(x1==1); 
x(:,1) = x1(ind); 
x(:,2) = x2(ind); 
x(:,3) = x3(ind); 
x(:,4) = x4(ind); 
x(:,5) = x5(ind); 
x(isnan(x))=0; % set nan's to 0 [not present]
YY = y(ind); 
XX = x(:,[3 4 5]);
Labels = {'Freq','Plus','SI'}; 

%% balance the data -- get equal numbers with & w/o seizures
i0 = find(YY==1); X1 = XX(i0,:); n0 = length(i0); 
i1 = find(YY==0); X0 = XX(i1,:); n1 = length(i1); 
n = min(n0,n1); 
disp(n); 
%% get AUC N times

for i = 1:N
    xx0 = datasample(X0,n,1); % returns a sample taken along dimension dim of data.
    xx1 = datasample(X1,n,1); % returns a sample taken along dimension dim of data
    yy0 = zeros(n,1); yy1 = ones(n,1); 
    X = [xx0; xx1]; Y = [yy0; yy1]; 

    %% Lasso logistic regression
    [labels,auc]=fcnGetFeaturesAndAUC_UsingLasso(X,Y,Labels,featureName); 
    disp('*******************'); 
    disp(sprintf('%s : factors that minimize CVDev (within 1SE):',featureName)); 
    disp(labels); 
    disp(sprintf('AUC: %0.2f%%',100*auc));
    AUC(i) = auc; 
end