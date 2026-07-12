function [prop,N] = IIC_prop(X,Y,factors)
%UNTITLED2 Summary of this function goes here
%   factors if a vector of 0 and ones indicting how that factor should be
%   held

obs=size(Y,1);
fac=size(X,2);
N=0;
count=[];

for ii=1:obs
    temp=[];
    for qq=1:fac
        if X(ii,qq)==factors(1,qq);
            temp(qq)=1;
        else
            temp(qq)=0;
        end
    end
    if sum(temp)==fac
        N=N+1;
    end
       if sum(temp)==fac && Y(ii)==1
           count(ii)=1;
       else
           count(ii)=0;
       end
       
end
   if N>9 
       prop=sum(count)/N;
   else
       prop=nan;
    
end

