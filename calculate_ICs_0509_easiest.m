clear all;


% scaleRt = [0.03,0.07];
% genTime = 4.6;
% seedSize = 50;
% propReport = 0.1;
numParam = 5;  % Number of estimated parameters. 
numObs = 30; % Sample sizes.
log_likelihood = readmatrix('./mcmc_result/China_subnational_Shenzhen_GD_log_likelihood.csv');
logL_allsimulations = (log_likelihood(:,1))';

% logL = [prctile(logL_allsimulations,50,2),prctile(logL_allsimulations,2.5,2),prctile(logL_allsimulations,97.5,2)];     % Loglikelihoods.
logL = prctile(logL_allsimulations,50,2);     % Loglikelihoods.

[~,~,ic] = aicbic(logL,numParam,numObs);
table_ic = struct2table(ic);
filename = 'AIC_BIC_etc.csv';
writetable(table_ic, filename);

% mcmcRes = mcmcRes(0.4*length(mcmcRes(:,1)):8:end,:);
logL_allsimulations_burnin = logL_allsimulations(:,0.4*length(log_likelihood(:,1)):8:end);  %logL_allsimulations(0.4*length(log_likelihood(:,1)):8:end,:);
logL_withoutburnin = prctile(logL_allsimulations_burnin,50,2); 
[~,~,ic] = aicbic(logL_withoutburnin,numParam,numObs);
table_ic = struct2table(ic);
filename = 'AIC_BIC_etc_without_burnin.csv';
writetable(table_ic, filename);

logL
logL_withoutburnin

% new_row = {'AIC_50percen', 'AIC_0025percen', 'AIC_0975percen', 'BIC_50percen', 'BIC_0025percen', 'BIC_0975percen', 'AICC_50percen', 'AICC_0025percen', 'AICC_0975percen', 'CAIC_50percen', 'CAIC_0025percen', 'CAIC_0975percen', 'HQC_50percen', 'HQC_0025percen', 'HQC_0975percen'};
% table_ic = [table_ic; new_row];
% filename = 'IC2218.csv';
% writetable(table_ic, filename);


