% Load MCMC results
mcmcRes = csvread('mcmc_result/China_subnational_Shenzhen_GD_mcmc_res.csv');
mcmcRes = mcmcRes(mcmcRes(:,1)~=0,:);
mcmcRes = mcmcRes(0.4*length(mcmcRes(:,1)):2:end,:);


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


% Set default figure window state to "maximized"
set(groot,'defaultFigureWindowState','maximized');
figure;
set(groot,'defaultFigureWindowState','maximized');
subplot(5,2,1);
hist(scaleRtArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('γ_1'); 
% title('Post. dist. of γ_1');
% legend('gamma_1');

subplot(5,2,2);
hist(scaleRtArr(:,2), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('γ_2');
% title('Post. dist. of γ_2');
% legend('gamma_2');


subplot(5,2,3);
hist(seedSizeArr, round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('Seed size'); 
% title('Post. dist. of seed size');

subplot(5,2,4);
hist(propReportArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{report}');
% title('Post. dist. of p_{report}');
% legend('propReport_1');

subplot(5,2,5);
hist(p_acArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{ascertain}');
% title('Post. dist. of p_{ascertain}');
% title('p_{ascertain}');

subplot(5,2,6);
hist(a_dh_hospArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('meanlog parm of intervals x_{DH}');   % 
% title('Post. dist. of shape');

subplot(5,2,7);
hist(b_dh_hospArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('sdlog parm of intervals x_{DH}');
% title('Post. dist. of scale');

subplot(5,2,8);
hist(a_fc_hospArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('meanlog parm of intervals x_{FC}');
% title('Post. dist. of shape');

subplot(5,2,9);
hist(b_fc_hospArr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('sdlog parm of intervals x_{FC}');
% title('Post. dist. of scale');
hold off;



set(groot,'defaultFigureWindowState','maximized');
figure;
set(groot,'defaultFigureWindowState','maximized');
subplot(3,2,1); 
hist(pSZHdh_age1Arr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{a,DH} (a=1)');
% title('Post. dist. of p_{HKUSZH (direct)}');
% title('p_{HKUSZH (direct)}');

subplot(3,2,2); 
hist(pSZHdh_age2Arr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{a,DH} (a=2)');
% title('Post. dist. of p_{HKUSZH (direct)}');
% title('p_{HKUSZH (direct)}');

subplot(3,2,3); 
hist(pSZHdh_age3Arr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{a,DH} (a=3)');
% title('Post. dist. of p_{HKUSZH (direct)}');
% title('p_{HKUSZH (direct)}');

subplot(3,2,4); 
hist(pSZHfc_age1Arr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{a,FC} (a=1)');
% title('Post. dist. of p_{HKUSZH (direct)}');
% title('p_{HKUSZH (direct)}');

subplot(3,2,5); 
hist(pSZHfc_age2Arr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{a,FC} (a=2)');
% title('Post. dist. of p_{HKUSZH (direct)}');
% title('p_{HKUSZH (direct)}');

subplot(3,2,6); 
hist(pSZHfc_age3Arr(:,1), round(sqrt(size(mcmcRes,1)))/2);
hold on;
xlabel('p_{a,FC} (a=3)');
% title('Post. dist. of p_{HKUSZH (direct)}');
% title('p_{HKUSZH (direct)}');



