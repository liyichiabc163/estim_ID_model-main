% Load MCMC results
mcmcRes = csvread('mcmc_result/China_subnational_Shenzhen_GD_mcmc_res.csv');

% Extract parameter columns
scaleRtArr = mcmcRes(:,[1,2]);
genTimeArr = mcmcRes(:,3).*normrnd(1,0.05,size(mcmcRes(:,3)));
seedSizeArr = mcmcRes(:,4);
propReportArr = mcmcRes(:,5);
pH_HKUSZHArr = mcmcRes(:,6); %,pH_HKUSZH
p_acArr = mcmcRes(:,7);
a_all_hospArr = mcmcRes(:,8);
b_all_hospArr = mcmcRes(:,9);


% Calculate autocorrelation for each parameter
%n_lags = 2000;
n_lags = 100000-1;  
scaleRtAutocorr = zeros(size(scaleRtArr, 2), n_lags+1);
genTimeAutocorr = zeros(size(genTimeArr, 2), n_lags+1);
seedSizeAutocorr = zeros(size(seedSizeArr, 2), n_lags+1);
propReportAutocorr = zeros(size(propReportArr, 2), n_lags+1);
pH_HKUSZHAutocorr = zeros(size(pH_HKUSZHArr, 2), n_lags+1);
p_acAutocorr = zeros(size(p_acArr, 2), n_lags+1);

a_all_hospAutocorr = zeros(size(a_all_hospArr, 2), n_lags+1);
b_all_hospAutocorr = zeros(size(b_all_hospArr, 2), n_lags+1);


for i=1:size(scaleRtArr, 2)
    corr = autocorr(scaleRtArr(:,i), 'NumLags', n_lags);
    scaleRtAutocorr(i,:) = reshape(corr, 1, []);
end

for i=1:size(genTimeArr, 2)
    corr = autocorr(genTimeArr(:,i), 'NumLags', n_lags);
    genTimeAutocorr(i,:) = reshape(corr, 1, []);
end

for i=1:size(seedSizeArr, 2)
    corr = autocorr(seedSizeArr(:,i), 'NumLags', n_lags);
    seedSizeAutocorr(i,:) = reshape(corr, 1, []);
end

for i=1:size(propReportArr, 2)
    corr = autocorr(propReportArr(:,i), 'NumLags', n_lags);
    propReportAutocorr(i,:) = reshape(corr, 1, []);
end

for i=1:size(pH_HKUSZHArr, 2)
    corr = autocorr(pH_HKUSZHArr(:,i), 'NumLags', n_lags);
    pH_HKUSZHAutocorr(i,:) = reshape(corr, 1, []);
end

for i=1:size(p_acArr, 2)
    corr = autocorr(p_acArr(:,i), 'NumLags', n_lags);
    p_acAutocorr(i,:) = reshape(corr, 1, []);
end

for i=1:size(a_all_hospArr, 2)
    corr = autocorr(a_all_hospArr(:,i), 'NumLags', n_lags);
    a_all_hospAutocorr(i,:) = reshape(corr, 1, []);
end


for i=1:size(b_all_hospArr, 2)
    corr = autocorr(b_all_hospArr(:,i), 'NumLags', n_lags);
    b_all_hospAutocorr(i,:) = reshape(corr, 1, []);
end




% Plot autocorrelation functions
figure;
fig = figure;
set(fig,'units','normalized','outerposition',[0 0 1 1]); 
% clf; 

ax1 = subplot(4,2,1); hold on; grid on;
plot(scaleRtAutocorr(1,:),'r-','LineWidth',1.5);
plot(scaleRtAutocorr(2,:),'b-','LineWidth',1.5);
% plot(scaleRtAutocorr(3,:),'g-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('Scale Rt');
% legend('parameter 1','parameter 2','parameter 3');
legend('γ_1','γ_2');

ax2 = subplot(4,2,2); hold on; grid on;
plot(genTimeAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('Generation time');

ax3 = subplot(4,2,3); hold on; grid on;
plot(seedSizeAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('Seed size');

ax4 = subplot(4,2,4); hold on; grid on;
plot(propReportAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('p_{report}');

ax5 = subplot(4,2,5); hold on; grid on;
plot(pH_HKUSZHAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('p_{HKUSZH}');

ax6 = subplot(4,2,6); hold on; grid on;
plot(p_acAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('p_{ascertain}');

ax7 = subplot(4,2,7); hold on; grid on;
plot(a_all_hospAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('gam_shape_total_hosp');


ax8 = subplot(4,2,8); hold on; grid on;
plot(b_all_hospAutocorr(1,:),'r-','LineWidth',1.5);
xlabel('Lags'); ylabel('Correlation');
title('gam_scale_total_hosp');

