function [P,low,high,N,SUB] = subset(X,F,L,H)
%X is the database, F are the columns to isolate in vector form eg [3 6 8]. X(:,1) is
%dependent variable, L is the low and H is the high (inclusive) for a
%continuous/ordinal variable should be 1,1 or 0,0 for a binary variable
%P is the prop with positive outcome variable, low and high are the 95% CI
%of P, N is the number of subjects in the subset, and SUB is the matrix of
%the subset.
SUB=[];
ww=1;
N=0;
for ii=1:size(X,1);
     temp=zeros(length(F),1);
    for yy=1:length(F);
    if X(ii,F(yy))>=L&&X(ii,F(yy))<=H;
        temp(yy)=1;
    else
        temp(yy)=0;
    end
    end
    if sum(temp)>0;
        SUB(ww,1:size(X,2))=X(ii,:);
        ww=ww+1;
    end
    end
 

N=size(SUB,1);
P=sum(SUB(:,1))/N;
[low, high]=CI2(P,N);
end

