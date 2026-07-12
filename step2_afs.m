

b=[CVerr.glmnet_fit.a0(numb) CVerr.glmnet_fit.beta(:,numb)'];
[TP,TN,FP,FN,OR,SE,SP,AC,NPV,PPV,Z,AUC] =predict_ROC_better(th,b,data_3_fq{:,2:(length(b))},data_3_fq{:,1});
graph_IIC
gg=find(b~=0);
coeff=(b(gg));
names={data_3_fq.Properties.VariableNames{gg(2:end)}};
name=['B0', names];
[b_glm,dev,STATS]=glmfit(data_3_fq{:,names},data_3_fq{:,'hasseizures'},'binomial','link','logit');
p_value=STATS.p';
coeff_glm=b_glm';
table_b=table(b(1),'Variablenames',{'B0'});


table_coeff=data_3_fq(1,names);

table_coeff=[table_b table_coeff];
table_coeff{1,:}=coeff;
table_coeff{2,:}=coeff_glm;
table_coeff{3,:}=p_value;
table_coeff.Properties.RowNames={'coeff_cvglment','coeff_glm','p_values'};
table_x_simple=data_3_fq(:,names);
table_y_simple=data_3_fq(:,1);

display(table_coeff)
display(AUC)