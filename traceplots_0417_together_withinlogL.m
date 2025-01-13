% Load MCMC results
mcmcRes = csvread('mcmc_result/China_subnational_Shenzhen_GD_mcmc_res.csv');
logL = csvread('mcmc_result/China_subnational_Shenzhen_GD_log_likelihood.csv');

mcmcRes = mcmcRes(mcmcRes(:,1)~=0,:);
% mcmcRes = mcmcRes(0.4*length(mcmcRes(:,1)):2:end,:);
mcmcRes = mcmcRes(0.2*length(mcmcRes(:,1)):end,:);   

logL = logL(logL(:,1)~=0,:);
% logL = logL(0.4*length(logL(:,1)):2:end,:);
logL = logL(0.2*length(logL(:,1)):end,:);


% Extract parameter columns
scaleRtArr = mcmcRes(:,[1,2]);
seedSizeArr = mcmcRes(:,4);
propReportArr = mcmcRes(:,5);
p_acArr = mcmcRes(:,6);
a_dh_hospArr = mcmcRes(:,7);
b_dh_hospArr = mcmcRes(:,8);
a_fc_hospArr = mcmcRes(:,9);
b_fc_hospArr = mcmcRes(:,10);


pSZHdh_age1Arr = mcmcRes(:,11);
pSZHdh_age2Arr = mcmcRes(:,12);
pSZHdh_age3Arr = mcmcRes(:,13);

pSZHfc_age1Arr = mcmcRes(:,14);
pSZHfc_age2Arr = mcmcRes(:,15);
pSZHfc_age3Arr = mcmcRes(:,16);

loglikelihood = logL(:,1);  



%  set(groot,'defaultFigureWindowState','maximized');
figure;
fig = figure;
set(fig,'units','normalized','outerposition',[0 0 1 1]); 

subplot(4,2,1);
plot(scaleRtArr(:,1),'r-','LineWidth',1.5);
hold on;
plot(scaleRtArr(:,2),'b-','LineWidth',1.5);
% plot(scaleRtArr(:,3),'g-','LineWidth',1.5);
% plot(scaleRtArr(:,4),'y-','LineWidth',1.5);
xlabel('Iteration'); ylabel('Parameter Value');
title('γ(t)');
xlim([1 size(seedSizeArr,1)]);
legend('γ_1','γ_2');

subplot(4,2,2);
plot(seedSizeArr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('Seed size');
xlim([1 size(seedSizeArr,1)]);

subplot(4,2,3);
plot(propReportArr(:,1),'r-','LineWidth',1.5);
hold on;
% plot(propReportArr(:,2),'b-','LineWidth',1.5);
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{report}');
xlim([1 size(seedSizeArr,1)]);
% legend('propReport_1','propReport_2');

subplot(4,2,4);
plot(p_acArr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{ascertain}');
xlim([1 size(seedSizeArr,1)]);

subplot(4,2,5);
plot(a_dh_hospArr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('meanlog parm of intervals x_{DH}');
xlim([1 size(seedSizeArr,1)]);

subplot(4,2,6);
plot(b_dh_hospArr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('sdlog parm of intervals x_{DH}');
xlim([1 size(seedSizeArr,1)]);

subplot(4,2,7);
plot(a_fc_hospArr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('meanlog parm of intervals x_{FC}');
xlim([1 size(seedSizeArr,1)]);

subplot(4,2,8);
plot(b_fc_hospArr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('sdlog parm of intervals x_{FC}');
xlim([1 size(seedSizeArr,1)]);
hold off;




figure;
fig = figure;
set(fig,'units','normalized','outerposition',[0 0 1 1]); 

subplot(3,2,1); 
plot(pSZHdh_age1Arr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{a,DH} (a=1)');
xlim([1 size(seedSizeArr,1)]);

subplot(3,2,2); 
plot(pSZHdh_age2Arr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{a,DH} (a=2)');
xlim([1 size(seedSizeArr,1)]);

subplot(3,2,3); 
plot(pSZHdh_age3Arr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{a,DH} (a=3)');
xlim([1 size(seedSizeArr,1)]);

subplot(3,2,4); 
plot(pSZHfc_age1Arr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{a,FC} (a=1)');
xlim([1 size(seedSizeArr,1)]);

subplot(3,2,5); 
plot(pSZHfc_age2Arr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{a,FC} (a=2)');
xlim([1 size(seedSizeArr,1)]);

subplot(3,2,6); 
plot(pSZHfc_age3Arr(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Parameter Value');
title('p_{a,FC} (a=3)');
xlim([1 size(seedSizeArr,1)]);
hold off;




figure;
fig = figure;
set(fig,'units','normalized','outerposition',[0 0 1 1]); 

subplot(1,1,1);
plot(loglikelihood(:,1),'r-','LineWidth',1.5);
hold on;
xlabel('Iteration'); ylabel('Log likelihood value');
xlim([1 size(seedSizeArr,1)]);
% title('total log likelihood');
hold off;


