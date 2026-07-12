function [min1,max1] = CI2(p,m)
%confidence interval of a proportion p with m number of subjects
%using Wilson score interval with continuity correction 

znn=1.96;
if p<1
max1=min(1, 1/(1+znn^2/m)*(p+znn^2/(2*m)+znn*((p/m)*(1-p)+znn^2/(4*m^2))^0.5));
else
    max1=1;
end
if p>0
min1=max(0, 1/(1+znn^2/m)*(p+znn^2/(2*m)-znn*((p/m)*(1-p)+znn^2/(4*m^2))^0.5));
else 
    min1=0;
end
  
end
