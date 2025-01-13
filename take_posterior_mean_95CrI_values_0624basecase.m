

clear all
clc
filePath = 'C:\O\S_2_hosp_0407_0412logn_doage0414_0428_0504_3_30w_new_time_interval_have_L3_0604basecase\China_subnational_Shenzhen_GD_mcmc_res_.csv';
data = readmatrix(filePath);

% burn in
startIndex = ceil(0.3 * size(data, 1)) + 1;
data = data(startIndex:end, :);


meanValues = mean(data);
lowerPercentile = prctile(data, 2.5);
upperPercentile = prctile(data, 97.5);

% testdata = [10,9,8,7,6,5,4,3,2,1];
% test = prctile(testdata, 20)  


for i = 1:size(data, 2)
    fprintf('Column %d:\n', i);
    fprintf('  Mean: %.4f\n', meanValues(i));
    fprintf('  2.5%% Percentile: %.4f\n', lowerPercentile(i));
    fprintf('  97.5%% Percentile: %.4f\n', upperPercentile(i));
end
%%%%%%%%%%% done  %%%%%%%%%




outputFilePath = 'C:\O\S_2_hosp_0407_0412logn_doage0414_0428_0504_3_30w_new_time_interval_have_L3_0604basecase\take_posterior_mean_95CrI_values_0624basecase.csv';

outputData = [meanValues; lowerPercentile; upperPercentile];


writematrix(outputData, outputFilePath);


fprintf('saved to: %s\n', outputFilePath);

