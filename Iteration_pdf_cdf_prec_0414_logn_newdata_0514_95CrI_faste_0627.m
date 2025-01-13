clear all 
clc

% Read HF CSV file parameters
filename_HF = 'C:\O\S_2_hosp_0407_0412logn_doage0414_0428_0504_3_30w_new_time_interval_have_L3_0604basecase\China_subnational_Shenzhen_GD_mcmc_res_fc.csv';
data_HF = csvread(filename_HF, 1, 0); 
burnin_HF = 0.4 * length(data_HF) - 1;
data_NOburnin_HF = data_HF(burnin_HF+1:end, :);

% Read and process time_interval_HF_counts
filename_HFhist = "C:\O\stratifyHOSP\time_interval_hospi_fromfc_counts_0414.csv";
data_HFhist = readmatrix(filename_HFhist);

% Process first column
data_HFhist(:, 1) = -data_HFhist(:, 1);

% Keep rows where the first column is between 0 and 14
data_filtered_HFhist = data_HFhist(data_HFhist(:, 1) >= 0 & data_HFhist(:, 1) <= 14, :);

% Handle missing values
missing_values_HFhist = setdiff(0:14, unique(data_filtered_HFhist(:, 1)));
num_missing_HFhist = length(missing_values_HFhist);

if num_missing_HFhist > 0
    missing_rows_HFhist = [missing_values_HFhist', zeros(num_missing_HFhist, 1)];
    data_filtered_HFhist = [data_filtered_HFhist; missing_rows_HFhist];
end

for i = 1:length(missing_values_HFhist)
    data_filtered_HFhist(data_filtered_HFhist(:, 1) == missing_values_HFhist(i), 2) = 0;
end

% Sort and save processed data
data_sorted_HFhist = sortrows(data_filtered_HFhist);
cumulative_sum_HFhist = cumsum(data_sorted_HFhist(:, 2));
data_sorted_HFhist(:, 3) = cumulative_sum_HFhist;
output_filename_sorted_HFhist = 'C:\O\stratifyHOSP\time_interval_hospi_fromfc_counts_0414_process_sort.csv';
writematrix(data_sorted_HFhist, output_filename_sorted_HFhist);
data_HFhist14days = readmatrix(output_filename_sorted_HFhist);

% Plot histogram
subplot(2, 2, 1);
sorted_HF = sortrows(data_NOburnin_HF, 3);

% Percentiles
mean_2p5_HF = prctile(sorted_HF(:, 3), 2.5);
mean_97p5_HF = prctile(sorted_HF(:, 3), 97.5);
indices_within_range_HF = sorted_HF(:, 3) >= mean_2p5_HF & sorted_HF(:, 3) <= mean_97p5_HF;
HF_NOburnin_95 = sorted_HF(indices_within_range_HF, :);

% Extract parameter values
a_values_HF = HF_NOburnin_95(:, 1);
b_values_HF = HF_NOburnin_95(:, 2);
gamma_means_HF = a_values_HF .* b_values_HF;

a_values_HF_all_after_burnin = data_NOburnin_HF(:, 1);
b_values_HF_all_after_burnin = data_NOburnin_HF(:, 2);
lognormal_means_HF = exp(a_values_HF_all_after_burnin + (b_values_HF_all_after_burnin.^2)/2);
lognormal_means_best_HF = mean(lognormal_means_HF);

posteriormeanA_HF = mean(a_values_HF);
posteriormeanB_HF = mean(b_values_HF);

% Generate x values for PDF plot
x = linspace(0, 14, 1000);

% Extract the first and last parameter values
a_first_HF = a_values_HF(1);
b_first_HF = b_values_HF(1);
a_last_HF = a_values_HF(end);
b_last_HF = b_values_HF(end);

% Compute PDFs
pdf_first_HF = lognpdf(x, a_first_HF, b_first_HF);
pdf_last_HF = lognpdf(x, a_last_HF, b_last_HF);

% Plot PDFs
plot(x, pdf_first_HF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);
hold on;
plot(x, pdf_last_HF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);

x_fill = [x, fliplr(x)];
y_fill = [pdf_first_HF, fliplr(pdf_last_HF)];
patch(x_fill, y_fill, [0.68, 0.85, 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

pdf_value_best_HF = lognpdf(x, posteriormeanA_HF, posteriormeanB_HF);
plot(x, pdf_value_best_HF, 'b', 'LineWidth', 1.0);

y_value_at_lognormal_means_best_HF = interp1(x, pdf_value_best_HF, lognormal_means_best_HF);
plot([lognormal_means_best_HF, lognormal_means_best_HF], [0, y_value_at_lognormal_means_best_HF], '--', 'LineWidth', 1, 'Color', [0 0 0]);
text(lognormal_means_best_HF, y_value_at_lognormal_means_best_HF, sprintf('posterior mean %.2f', lognormal_means_best_HF), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', [0 0 0]);

hold off;
xlabel('Days');
ylabel('Probability');
title({'PDF of Onset-to-hospitalization', '(from fever clinic)'}, 'HorizontalAlignment', 'center');
xlim([0, 14]); 
ylim([0, 0.5]);

yyaxis right
bar(data_HFhist14days(:, 1), data_HFhist14days(:, 2) / sum(data_HFhist14days(:, 2)), 'BarWidth', 0.8, 'FaceColor', [0.8, 0.8, 1], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
ylim([0, 0.5]);
ylabel({'Empirical proportion', ['N = 595']}, 'HorizontalAlignment', 'center');   % 'N = 595'
set(subplot(2, 2, 1), 'YColor', [0 0 0]);
hold off;



% CDF
filename_HFemcdf = "C:\O\stratifyHOSP\time_interval_hospi_fromfc_percent_0414.csv";
data_HFemcdf = readmatrix(filename_HFemcdf);

% Negate the first column
data_HFemcdf(:, 1) = -data_HFemcdf(:, 1);

% Keep rows where the first column is between 0 and 14
data_filtered_HFemcdf = data_HFemcdf(data_HFemcdf(:, 1) >= 0 & data_HFemcdf(:, 1) <= 14, :);

% Handle missing values
missing_values_HFemcdf = setdiff(0:14, unique(data_filtered_HFemcdf(:, 1)));
num_missing_HFemcdf = length(missing_values_HFemcdf);

if num_missing_HFemcdf > 0
    missing_rows_HFemcdf = [missing_values_HFemcdf', zeros(num_missing_HFemcdf, 1)];
    data_filtered_HFemcdf = [data_filtered_HFemcdf; missing_rows_HFemcdf];
end

for i = 1:length(missing_values_HFemcdf)
    data_filtered_HFemcdf(data_filtered_HFemcdf(:, 1) == missing_values_HFemcdf(i), 2) = 0;
end

% Sort data and save processed results to a CSV file
data_sorted_HFemcdf = sortrows(data_filtered_HFemcdf);
cumulative_sum_HFemcdf = cumsum(data_sorted_HFemcdf(:, 2));
data_sorted_HFemcdf(:, 3) = cumulative_sum_HFemcdf;
output_filename_sorted_HFemcdf = 'C:\O\stratifyHOSP\time_interval_hospi_fromfc_percent_0414_process_sort.csv';
writematrix(data_sorted_HFemcdf, output_filename_sorted_HFemcdf);

% Read processed CDF data
data_HFemcdf14days = readmatrix(output_filename_sorted_HFemcdf);

% Plot cumulative distribution function (CDF)
subplot(2, 2, 2);

% Compute the CDFs for the first and last parameter values
cdf_first_HF = logncdf(x, a_first_HF, b_first_HF);
cdf_last_HF = logncdf(x, a_last_HF, b_last_HF);

% Plot the CDFs for the first and last parameter values
plot(x, cdf_first_HF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);
hold on;
plot(x, cdf_last_HF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);

% Fill the area between the two CDFs
x_fill = [x, fliplr(x)];
y_fill = [cdf_first_HF, fliplr(cdf_last_HF)];
patch(x_fill, y_fill, [1, 0.5, 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.4);

% Compute and plot the best estimated CDF
cdf_values_best_HF = logncdf(x, posteriormeanA_HF, posteriormeanB_HF);
p1 = plot(x, cdf_values_best_HF, 'r', 'LineWidth', 1);
hold off;

xlabel('Days');
ylabel('Probability');
title('CDF of Onset-to-hospitalization', '(from the fever clinic)');
xlim([0, 14]); % Limit the X-axis range

% Add a step plot for empirical CDF
yyaxis right;
p2 = stairs(data_sorted_HFemcdf(:, 1), data_sorted_HFemcdf(:, 3), 'LineWidth', 1.0, 'Color', [0.4660 0.6740 0.1880], 'LineStyle', '-');
set(subplot(2, 2, 2), 'YColor', [0 0 0]);

% Add legend
legend([p1, p2], {'inferred CDF', 'empirical CDF'}, 'Location', 'best', 'box', 'off');
hold off;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process HnotF CSV file parameters
filename_HnotF = 'C:\O\S_2_hosp_0407_0412logn_doage0414_0428_0504_3_30w_new_time_interval_have_L3_0604basecase\China_subnational_Shenzhen_GD_mcmc_res_dh.csv';
data_HnotF = csvread(filename_HnotF, 1, 0); 
burnin_HnotF = 0.4 * length(data_HnotF) - 1;
data_NOburnin_HnotF = data_HnotF(burnin_HnotF+1:end, :);

% Read and process time_interval_HnotF_counts
filename_HnotFhist = "C:\O\stratifyHOSP\time_interval_hospi_direct_counts_0414.csv";
data_HnotFhist = readmatrix(filename_HnotFhist);

% Process first column
data_HnotFhist(:, 1) = -data_HnotFhist(:, 1);

% Keep rows where the first column is between 0 and 14
data_filtered_HnotFhist = data_HnotFhist(data_HnotFhist(:, 1) >= 0 & data_HnotFhist(:, 1) <= 14, :);

% Handle missing values
missing_values_HnotFhist = setdiff(0:14, unique(data_filtered_HnotFhist(:, 1)));
num_missing_HnotFhist = length(missing_values_HnotFhist);

if num_missing_HnotFhist > 0
    missing_rows_HnotFhist = [missing_values_HnotFhist', zeros(num_missing_HnotFhist, 1)];
    data_filtered_HnotFhist = [data_filtered_HnotFhist; missing_rows_HnotFhist];
end

for i = 1:length(missing_values_HnotFhist)
    data_filtered_HnotFhist(data_filtered_HnotFhist(:, 1) == missing_values_HnotFhist(i), 2) = 0;
end

% Sort and save processed data
data_sorted_HnotFhist = sortrows(data_filtered_HnotFhist);
cumulative_sum_HnotFhist = cumsum(data_sorted_HnotFhist(:, 2));
data_sorted_HnotFhist(:, 3) = cumulative_sum_HnotFhist;
output_filename_sorted_HnotFhist = 'C:\O\stratifyHOSP\time_interval_hospi_direct_counts_0414_process_sort.csv';
writematrix(data_sorted_HnotFhist, output_filename_sorted_HnotFhist);
data_HnotFhist14days = readmatrix(output_filename_sorted_HnotFhist);

% Plot histogram
subplot(2, 2, 3);
sorted_HnotF = sortrows(data_NOburnin_HnotF, 3);

% Percentiles
mean_2p5_HnotF = prctile(sorted_HnotF(:, 3), 2.5);
mean_97p5_HnotF = prctile(sorted_HnotF(:, 3), 97.5);
indices_within_range_HnotF = sorted_HnotF(:, 3) >= mean_2p5_HnotF & sorted_HnotF(:, 3) <= mean_97p5_HnotF;
HnotF_NOburnin_95 = sorted_HnotF(indices_within_range_HnotF, :);

% Extract parameter values
a_values_HnotF = HnotF_NOburnin_95(:, 1);
b_values_HnotF = HnotF_NOburnin_95(:, 2);

a_values_HnotF_all_after_burnin = data_NOburnin_HnotF(:, 1);
b_values_HnotF_all_after_burnin = data_NOburnin_HnotF(:, 2);
lognormal_means_HnotF = exp(a_values_HnotF_all_after_burnin + (b_values_HnotF_all_after_burnin.^2)/2); 
lognormal_means_best_HnotF = mean(lognormal_means_HnotF);

posteriormeanA_HnotF = mean(a_values_HnotF);
posteriormeanB_HnotF = mean(b_values_HnotF);

% Generate x values for PDF plot
x = linspace(0, 14, 1000);

% Extract the first and last parameter values
a_first_HnotF = a_values_HnotF(1);
b_first_HnotF = b_values_HnotF(1);
a_last_HnotF = a_values_HnotF(end);
b_last_HnotF = b_values_HnotF(end);

% Compute PDFs
pdf_first_HnotF = lognpdf(x, a_first_HnotF, b_first_HnotF);
pdf_last_HnotF = lognpdf(x, a_last_HnotF, b_last_HnotF);

% Plot PDFs
plot(x, pdf_first_HnotF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);
hold on;
plot(x, pdf_last_HnotF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);

x_fill = [x, fliplr(x)];
y_fill = [pdf_first_HnotF, fliplr(pdf_last_HnotF)];
patch(x_fill, y_fill, [0.68, 0.85, 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

pdf_value_best_HnotF = lognpdf(x, posteriormeanA_HnotF, posteriormeanB_HnotF);
plot(x, pdf_value_best_HnotF, 'b', 'LineWidth', 1.0);

y_value_at_gamma_means_best_HnotF = interp1(x, pdf_value_best_HnotF, lognormal_means_best_HnotF);
plot([lognormal_means_best_HnotF, lognormal_means_best_HnotF], [0, y_value_at_gamma_means_best_HnotF], '--', 'LineWidth', 1, 'Color', [0 0 0]);
text(lognormal_means_best_HnotF, y_value_at_gamma_means_best_HnotF, sprintf('posterior mean %.2f', lognormal_means_best_HnotF), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', [0 0 0]);

hold off;
xlabel('Days');
ylabel('Probability');
title({'PDF of Onset-to-hospitalization', '(directly hospitalization)'}, 'HorizontalAlignment', 'center');
xlim([0, 14]); 
ylim([0, 0.5]);

yyaxis right
bar(data_HnotFhist14days(:, 1), data_HnotFhist14days(:, 2) / sum(data_HnotFhist14days(:, 2)), 'BarWidth', 0.8, 'FaceColor', [0.8, 0.8, 1], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
ylim([0, 0.5]);
ylabel({'Empirical proportion', ['N = 377']}, 'HorizontalAlignment', 'center');
set(subplot(2, 2, 3), 'YColor', [0 0 0]);
hold off;





%%%%%% similarly: cdf for directly hospitalized
filename_HnotFemcdf = "C:\O\stratifyHOSP\time_interval_hospi_direct_percent_0414.csv";
data_HnotFemcdf = readmatrix(filename_HnotFemcdf);

data_HnotFemcdf(:, 1) = -data_HnotFemcdf(:, 1);

data_filtered_HnotFemcdf = data_HnotFemcdf(data_HnotFemcdf(:, 1) >= 0 & data_HnotFemcdf(:, 1) <= 14, :);

missing_values_HnotFemcdf = setdiff(0:14, unique(data_filtered_HnotFemcdf(:, 1)));
num_missing_HnotFemcdf = length(missing_values_HnotFemcdf);

if num_missing_HnotFemcdf > 0
    missing_rows_HnotFemcdf = [missing_values_HnotFemcdf', zeros(num_missing_HnotFemcdf, 1)];
    data_filtered_HnotFemcdf = [data_filtered_HnotFemcdf; missing_rows_HnotFemcdf];
end


for i = 1:length(missing_values_HnotFemcdf)
    data_filtered_HnotFemcdf(data_filtered_HnotFemcdf(:, 1) == missing_values_HnotFemcdf(i), 2) = 0;
end

output_filename_HnotFemcdf = 'C:\O\stratifyHOSP\time_interval_hospi_direct_percent_0414_process.csv';


data_sorted_HnotFemcdf = sortrows(data_filtered_HnotFemcdf);
cumulative_sum_HnotFemcdf = cumsum(data_sorted_HnotFemcdf(:, 2));
data_sorted_HnotFemcdf(:, 3) = cumulative_sum_HnotFemcdf;

output_filename_sorted_HnotFemcdf = 'C:\O\stratifyHOSP\time_interval_hospi_direct_percent_0414_process_sort.csv';
writematrix(data_sorted_HnotFemcdf, output_filename_sorted_HnotFemcdf);

data_HnotFemcdf14days = readmatrix(output_filename_sorted_HnotFemcdf);


% cdf plot
subplot(2,2,4);

cdf_first_HnotF = logncdf(x, a_first_HnotF, b_first_HnotF);
cdf_last_HnotF = logncdf(x, a_last_HnotF, b_last_HnotF);

plot(x, cdf_first_HnotF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);
hold on;
plot(x, cdf_last_HnotF, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 0.02);

x_fill = [x, fliplr(x)];
y_fill = [cdf_first_HnotF, fliplr(cdf_last_HnotF)];

patch(x_fill, y_fill, [1, 0.5, 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.4); 

cdf_values_best_HnotF = logncdf(x, posteriormeanA_HnotF, posteriormeanB_HnotF);
p1 = plot(x, cdf_values_best_HnotF, 'r', 'LineWidth', 1);
hold off;
xlabel('Days')
ylabel('Probability')
title('CDF of Onset-to-hospitalization','(directly hospitalization)');
xlim([0, 14]); 

hold off;

yyaxis right
p2 = stairs(data_sorted_HnotFemcdf(:, 1), data_sorted_HnotFemcdf(:, 3), 'LineWidth', 1.0, 'Color', [0.4660 0.6740 0.1880],'LineStyle','-');
set(subplot(2,2,4),'YColor',[0 0 0]);

hold off;










