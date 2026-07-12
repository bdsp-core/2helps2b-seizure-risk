subplot(2,2,1);
plot((1-SP),SE);
title('ROC');
xlabel('1-specificity');
ylabel('Sensitivity')

subplot(2,2,2);
plot(th,(1-NPV(:,1)));
title('threshold');
xlabel('logistic predicted % chance of sz');
ylabel('1-NPV');

subplot(2,2,3);
plot(th,(PPV(:,1)));
title('threshold');
xlabel('logistic predicted % chance of sz');
ylabel('PPV');

subplot(2,2,4);
plot(th,SE(:,1),th,SP(:,1));
title('SE , SP threshold');
xlabel('logistic predicted % chance of sz');
ylabel('SE/SP');
legend('SEN','SPEC');

