% age stratifications

clear all
clc

filename = 'C:\O\S_2_hosp_0407_0412logn_doage0414_0428_0504_3_30w_new_time_interval_have_L3_0604basecase\take_posterior_mean_95CrI_values_0624basecase_6phosp.csv';

data = readmatrix(filename);


age_groups = {'0-18', '19-58', '＞58'};
hosp_prob = data(1, [1, 2, 3]);
clinic_prob = data(1, [4, 5, 6]);
hosp_lower = data(2, [1, 2, 3]);
hosp_upper = data(3, [1, 2, 3]);
clinic_lower = data(2, [4, 5, 6]);
clinic_upper = data(3, [4, 5, 6]);



figure;
hold on;

% P-hospitalization
for i = 1:length(age_groups)
    
    errorbar(i - 0.1, hosp_prob(i), hosp_prob(i) - hosp_lower(i), hosp_upper(i) - hosp_prob(i), 'k', 'LineWidth', 1);
    
    pDH(i) = plot(i - 0.1, hosp_prob(i), 'o', 'MarkerFaceColor', [0.8, 0, 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 6);
end


for i = 1:length(age_groups)
    
    errorbar(i + 0.1, clinic_prob(i), clinic_prob(i) - clinic_lower(i), clinic_upper(i) - clinic_prob(i), 'k', 'LineWidth', 1);
    
    pFC(i) = plot(i + 0.1, clinic_prob(i), 'o', 'MarkerFaceColor', [0, 0.8, 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 6);
end

xticks(1:length(age_groups));
xticklabels(age_groups);

% ylabel({'probability that infections (convoluted by the'; 'infection-to-hospitalization distribution) were hospitalized at HKU-Shenzhen Hospital'}, 'HorizontalAlignment', 'center');
ylabel({'probability that infections were'; 'hospitalized at HKU-Shenzhen Hospital'}, 'HorizontalAlignment', 'center');
% The proportion of COVID-19 infections aged over 59 were hospitalized at HKU-Shenzhen Hospital (admitted directly)
xlabel('Age (years)');
legend([pDH(1), pFC(1)], 'p_{DH}, hospitalizations admitted directly', 'p_{FC}, hospitalizations from fever clinic', 'Location', 'northwest','box','off');


% set(gca, 'FontSize', 11);   

xlim([0.5, length(age_groups) + 0.5]);





