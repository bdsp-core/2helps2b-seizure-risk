function [pred,actual]=points(point,b,X,Y)


 %binary1=[1 3 7 15 31 63 127 255 511 1023 2047 4095 8191 16383 32767];
 
 binary=bi2de(ones(length(point),1)');
 temp2=de2bi(0:binary);

points_temp=repmat(point,[size(temp2,1),1]);
points_temp2=points_temp.*temp2;

total_points=sum(points_temp2,2);


for yy=1:(sum(point)+1)
    row_numb=[];
row_numb=find(total_points==(yy-1));

if isempty(row_numb)==0
    pred_temp2=[];
    pred_temp=[];
    temp3=[];
temp3=temp2([row_numb],:);
b_temp=repmat(b,[size(temp3,1),1]);
pred_temp=b_temp(:,1)+sum(b_temp(:,2:end).*temp3(:,1:end),2);
pred_temp2=1./(1+exp(-1*pred_temp));
pred(yy,1)=min(pred_temp2);
pred(yy,2)=max(pred_temp2);
actual_temp2=[];
for tt=1:size(temp3,1)
    actual_temp=[];
    N=[];
[actual_temp,N]=IIC_prop(X,Y,temp3(tt,:));
actual_temp2(tt,1)=actual_temp;
actual_temp2(tt,2)=N;
end

actual(yy,1)=min(actual_temp2(:,1));
actual(yy,2)=max(actual_temp2(:,1));
actual_temp2(isnan(actual_temp2(:,1)),:)=[];
actual(yy,5)=sum(actual_temp2(:,1).*actual_temp2(:,2))./(sum(actual_temp2(:,2)));
actual(yy,6)=sqrt(actual(yy,5).*((1-actual(yy,5))))./sqrt(sum(actual_temp2(:,2)));
[actual_1,~]=CI2(actual(yy,1),N);
[~,actual_2]=CI2(actual(yy,2),N);
actual(yy,3)=actual_1;
actual(yy,4)=actual_2;
else
    actual(yy,1)=nan;
    actual(yy,2)=nan;
    actual(yy,3)=nan;
    actual(yy,4)=nan;
    pred(yy,1)=nan;
    pred(yy,2)=nan;
end
end

end






