% do not write clear all here



numParam = 16;  % Number of estimated parameters. 
numObs = 48; % Sample sizes.
log_likelihood = readmatrix('./mcmc_result/China_subnational_Shenzhen_GD_log_likelihood.csv');

% BIC_all = zeros(size(log_likelihood));
% for i = 1:size(log_likelihood, 1)
%     BIC_all(i) = numParam*log(numObs) - 2*log_likelihood(i);  % BIC = k*log(n) - 2*log(L)
% end
% writematrix(BIC_all, 'BIC1_all.csv');


[BIC_all, ~] = aicbic(log_likelihood, numParam*ones(size(log_likelihood)), numObs*ones(size(log_likelihood)));
outputFile1 = fullfile('./allmcmcresults', 'BIC_all.csv');
writematrix(BIC_all, outputFile1);


logL_burnin = log_likelihood(0.4*length(log_likelihood(:,1)):2:end,:); 
[BIC_all_withoutburnin, ~] = aicbic(logL_burnin, numParam*ones(size(logL_burnin)), numObs*ones(size(logL_burnin)));
outputFile2 = fullfile('./allmcmcresults', 'BIC_withoutburnin_all.csv');
writematrix(BIC_all_withoutburnin, outputFile2);


% Set default figure window state to "maximized"
set(groot,'defaultFigureWindowState','maximized');

figure;
% subplot(1,2,1);
% hist(log_likelihood(:,1), round(sqrt(size(log_likelihood,1)))/2);
% hold on;
% xlabel('log Likelihood'); 
% title('log Likelihood Distribution');
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor',[0.5 0.25 0])

subplot(1,1,1);
hist(logL_burnin(:,1), round(sqrt(size(logL_burnin,1)))/2);
hold on;
xlabel('log likelihood value'); ylabel('Frequency');
% title('log likelihood Distribution');
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.5 0.25 0])

% subplot(2,2,3);
% hist(BIC_all(:,1), round(sqrt(size(BIC_all,1)))/2);
% hold on;
% xlabel('BIC'); 
% title('BIC Distribution');
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor',[0.5 0.25 0])
% 
% subplot(2,2,4);
% hist(BIC_all_withoutburnin(:,1), round(sqrt(size(BIC_all_withoutburnin,1)))/2);
% hold on;
% xlabel('BIC'); 
% title('BIC Distribution (without burn-in)');
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor',[0.5 0.25 0])

