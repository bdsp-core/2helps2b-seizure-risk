function [TP,TN,FP,FN,OR,SE,SP,AC,NPV,PPV,Z,AUC] =predict_ROC(th,B,X,Y)
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


logr=zeros(obs,1);
pred=zeros(obs,1);

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

for ww=1:th_size;
    
tp=zeros(obs,1);
tn=zeros(obs,1);
fp=zeros(obs,1);
fn=zeros(obs,1);

Z(ww,1)=log(th(ww)/(1-th(ww)));

for ii=1:obs
    logr(ii)=1/(1+(exp((-1).*(B(1)+sum(B(2:length(B)).*X(ii,:))))));
    if logr(ii)>=th(ww);
    pred(ii)=1;
    else
        pred(ii)=0;
    end
    if pred(ii)==1 && Y(ii)==1;
        tp(ii)=1;
    else
        tp(ii)=0;
    end
        if pred(ii)==0 && Y(ii)==0;
        tn(ii)=1;
    else
        tn(ii)=0;
        end
        
    if pred(ii)==1 && Y(ii)==0;
        fp(ii)=1;
    else
        fp(ii)=0;
    end
    if pred(ii)==0 && Y(ii)==1
        fn(ii)=1;
    else
        fn(ii)=0;
    end
end
TP(ww,1)=sum(tp);
TN(ww,1)=sum(tn);
FN(ww,1)=sum(fn);
FP(ww,1)=sum(fp);
SE(ww,1)=sum(tp)/(sum(tp)+sum(fn));
[temp2,temp3]=CI2(SE(ww,1),(sum(tn)+sum(fp)));
SE(ww,2)=temp2;
SE(ww,3)=temp3;
SP(ww,1)=sum(tn)/(sum(tn)+sum(fp));
[temp4,temp5]=CI2(SP(ww,1),(sum(tn)+sum(fp)));
SP(ww,2)=temp4;
SP(ww,3)=temp5;
OR(ww,1)=sum(tp)*sum(tn)/(sum(fp)*sum(fn));
OR(ww,2)=max([exp(log(OR(ww,1)-1.96*sqrt(1/sum(tp)+1/sum(tn)+1/sum(fn)+1/sum(fp)))),0]);
OR(ww,3)=exp(log(OR(ww,1)+1.96*sqrt(1/sum(tp)+1/sum(tn)+1/sum(fn)+1/sum(fp))));
AC(ww,1)=(sum(tp)+sum(tn))/(sum(tp)+sum(tn)+sum(fp)+sum(fn));
[temp6,temp7]=CI2(AC(ww,1),(sum(tp)+sum(tn)+sum(fp)+sum(fn)));
AC(ww,2)=temp6;
AC(ww,3)=temp7;
if (sum(tp)+sum(fp))>0
   PPV(ww,1)=sum(tp)/(sum(tp)+sum(fp));
   [temp8, temp9]=CI2(PPV(ww,1),(sum(tp)+sum(fp)));
else
    PPV(ww,1)=1;
    temp8=1;
    temp9=1;
end

PPV(ww,2)=temp8;
PPV(ww,3)=temp9;
if (sum(tn)+sum(fn))>0
NPV(ww,1)=sum(tn)/(sum(tn)+sum(fn));
[temp10, temp11]=CI2(NPV(ww,1),(sum(tn)+sum(fn)));
else
    NPV(ww,1)=1;
    temp10=1;
    temp11=1;
end

NPV(ww,2)=temp10;
NPV(ww,3)=temp11;
end

AUC=-trap((1-SP(:,1)),SE(:,1));

end





