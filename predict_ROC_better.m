function [TP,TN,FP,FN,OR,SE,SP,AC,NPV,PPV,Z,AUC] =predict_ROC_better(th,B,X,Y)
%Generates stats comparing predicted data from a logistic regression to 
%data
%th is a vector with values from 0 to 1 used to create the ROC (0.5 is
%baseline for classification)
%B are the coefficents from the logistic regression [B0, B1, B2 ...Bn]
%X is the input data in a matrix form with n column (one less than B)
%Y is the outout
%TP=true positive, TN true negative, FP false positive, FN false negative, 
%SE sensitivity, SP specificity, AC accuracy, NPV negative predictive value
% PPV positive predictive value are vectors correlating with th proportions
%are reported with 95% confidence intervals
%Z is the value of th=f(Z)  when f(Z)=1/(1-e^(-Z))

obs=size(X,1);
th_size=length(th);

OR=zeros(th_size,3);
SE=zeros(th_size,3);
SP=zeros(th_size,3);
AC=zeros(th_size,3);
TP=zeros(th_size,1);
TN=zeros(th_size,1);
FP=zeros(th_size,1);
FN=zeros(th_size,1);
Z=zeros(th_size,1);
PPV=zeros(th_size,3);
NPV=zeros(th_size,3);

logr=(zeros(obs,1));

W=repmat(B,[obs,1]);

zz(:,1)=exp(-1.*(W(:,1)+sum((W(:,2:length(B)).*X),2)));

logr(:,1)=1./(1+zz(:,1));

for ww=1:th_size;
pred=zeros(obs,1);
Z(ww,1)=log(th(ww)/(1-th(ww)));

pred([find(logr>=th(ww))])=1;
    
tp=find(pred(:,1)==1&Y(:,1)==1);
tn=find(pred(:,1)==0&Y(:,1)==0);
fp=find(pred(:,1)==1&Y(:,1)==0);
fn=find(pred(:,1)==0&Y(:,1)==1);

TP(ww,1)=length(tp);
TN(ww,1)=length(tn);
FN(ww,1)=length(fn);
FP(ww,1)=length(fp);
SE(ww,1)=length(tp)/(length(tp)+length(fn));
[temp2,temp3]=CI2(SE(ww,1),(length(tn)+length(fp)));
SE(ww,2)=temp2;
SE(ww,3)=temp3;
SP(ww,1)=length(tn)/(length(tn)+length(fp));
[temp4,temp5]=CI2(SP(ww,1),(length(tn)+length(fp)));
SP(ww,2)=temp4;
SP(ww,3)=temp5;
OR(ww,1)=sum(tp)*length(tn)/(sum(fp)*sum(fn));
OR(ww,2)=max([exp(log(OR(ww,1)-1.96*sqrt(1/TP(ww,1)+1/TN(ww,1)+1/length(fn)+1/length(fp)))),0]);
OR(ww,3)=exp(log(OR(ww,1)+1.96*sqrt(1/length(tp)+1/length(tn)+1/length(fn)+1/length(fp))));
AC(ww,1)=(length(tp)+length(tn))/(length(tp)+length(tn)+length(fp)+length(fn));
[temp6,temp7]=CI2(AC(ww,1),(length(tp)+length(tn)+length(fp)+length(fn)));
AC(ww,2)=temp6;
AC(ww,3)=temp7;
if (length(tp)+length(fp))>0
   PPV(ww,1)=length(tp)/(length(tp)+length(fp));
   [temp8, temp9]=CI2(PPV(ww,1),(length(tp)+length(fp)));
else
    PPV(ww,1)=1;
    temp8=1;
    temp9=1;
end

PPV(ww,2)=temp8;
PPV(ww,3)=temp9;
if (length(tn)+length(fn))>0
NPV(ww,1)=length(tn)/(length(tn)+length(fn));
[temp10, temp11]=CI2(NPV(ww,1),(length(tn)+length(fn)));
else
    NPV(ww,1)=1;
    temp10=1;
    temp11=1;
end

NPV(ww,2)=temp10;
NPV(ww,3)=temp11;
end
AUC=-trapz((1-SP(:,1)),SE(:,1));

end




