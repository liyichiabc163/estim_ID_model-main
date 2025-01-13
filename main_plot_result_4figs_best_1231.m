% Do not use "clear all" and "clc" here.

% 0. Date initialization
dateZero = datenum('2022/11/17','yyyy/mm/dd'); 

dateChange = datenum('2022/12/06','yyyy/mm/dd') - dateZero;   
dateEnd = datenum('2023/02/01','yyyy/mm/dd') - dateZero; 

% 1. Contact pattern
% Define age groups and population data
dataDir = 'data/';
countryText = 'China_subnational_Shenzhen_GD';
totalPopulation = 17560061;
ageGroupDefRange = [-1,19,59,84];

% Age distribution
ageDistrTemp = readmatrix([dataDir, 'age_distributions/', countryText, '_age_distribution_85.csv']);
totalPop = totalPopulation;
ageDistributionOneyear = ageDistrTemp(:, 2) / sum(ageDistrTemp(:, 2));

% Contact matrix by setting
overallMatr = readmatrix([dataDir, 'contact_matrices/', countryText, '_M_overall_contact_matrix_85.csv']);
[overallMatr, ageDistribution] = polymodContactMatrix(ageGroupDefRange, overallMatr, ageDistributionOneyear, totalPop);
contactMatr = overallMatr;
totalPopulation = totalPop * ageDistribution;
totalPopulationAgeBand = totalPopulation;

% 2. Load Shenzhen subway data
bjMTRdata = readtable('data/2023_02_01_subway_shenzhenfrom1101.xlsx');
bjMTRdata = bjMTRdata(18:end, :);  % Start reading from the 18th row
bjMTRdata.date = datenum(bjMTRdata.date) - dateZero; % Convert dates to numeric indices
bjMTRdata.total2 = bjMTRdata.total;
bjMTRdata.total = movmean(bjMTRdata.total, 5);

% 3. Load Shenzhen local case data
cutoffDate = datenum('2022/11/30','yyyy/mm/dd') - dateZero;   
localCase = readtable("data/2022_12_13_reported_case_shenzhenfrom1101.xlsx");
localCase = localCase(18:end, :); % Start reading from the 18th row
localCase.date = datenum(localCase.date) - dateZero; 
localCase = localCase(localCase.date <= cutoffDate, :);  
localCase.num_local_case = localCase.symandasym;
dataBeijing = outerjoin(bjMTRdata(:, {'date', 'total'}), localCase(:, {'date', 'num_local_case'}), ...
    'LeftKeys', 'date', 'RightKeys', 'date', 'MergeKeys', true);

cutoffDate1213 = datenum('2022/12/13','yyyy/mm/dd') - dateZero; 
localCase1213 = readtable("data/2022_12_13_reported_case_shenzhenfrom1101.xlsx");
localCase1213 = localCase1213(18:end, :); % Start reading from the 18th row
localCase1213.date = datenum(localCase1213.date) - dateZero; 
localCase1213 = localCase1213(localCase1213.date <= cutoffDate1213, :);  
localCase1213.num_local_case = localCase1213.symandasym;
dataBeijing1213 = outerjoin(bjMTRdata(:, {'date', 'total'}), localCase1213(:, {'date', 'num_local_case'}), ...
    'LeftKeys', 'date', 'RightKeys', 'date', 'MergeKeys', true);

% 6. Load HKUSZH data
datahkuszh1hospi = readtable("data\data_extracted_from_Fever_Clinic_20230607.xlsx");  
datahkuszh1hospi.date = datenum(datahkuszh1hospi.date) - dateZero;

% 8. Observed daily hospitalizations (direct hospitalizations) from HKUSZH
d2 = 0;
hospitalizationHKUSZH_dh = readtable("data\data_extracted_from_the_sheet_named_Fever_Clinic_and_hospi_clean_0407_3_ages.csv"); 
hospitalizationHKUSZH_dh = hospitalizationHKUSZH_dh(2:(28 + d2), :);  
hospitalizationHKUSZH_dh.date = datenum(hospitalizationHKUSZH_dh.date) - dateZero; 
hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever = movmean(hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever, 5);
hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever = round(hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever);

hospitalizationHKUSZH_dh.dh_age0to18 = movmean(hospitalizationHKUSZH_dh.dh_age0to18, 5);
hospitalizationHKUSZH_dh.dh_age0to18 = round(hospitalizationHKUSZH_dh.dh_age0to18);

hospitalizationHKUSZH_dh.dh_age19to58 = movmean(hospitalizationHKUSZH_dh.dh_age19to58, 5);
hospitalizationHKUSZH_dh.dh_age19to58 = round(hospitalizationHKUSZH_dh.dh_age19to58);

hospitalizationHKUSZH_dh.dh_age59over = movmean(hospitalizationHKUSZH_dh.dh_age59over, 5);
hospitalizationHKUSZH_dh.dh_age59over = round(hospitalizationHKUSZH_dh.dh_age59over);

% 9. Observed daily hospitalizations (fever clinic) from HKUSZH
hospitalizationHKUSZH_fc = readtable("data\data_extracted_from_the_sheet_named_Fever_Clinic_and_hospi_clean_0407_3_ages.csv"); 
hospitalizationHKUSZH_fc = hospitalizationHKUSZH_fc(1:(28 + d2), :);  
hospitalizationHKUSZH_fc.date = datenum(hospitalizationHKUSZH_fc.date) - dateZero; 
hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever = movmean(hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever, 5);
hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever = round(hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever);

hospitalizationHKUSZH_fc.fc_age0to18 = movmean(hospitalizationHKUSZH_fc.fc_age0to18, 5);
hospitalizationHKUSZH_fc.fc_age0to18 = round(hospitalizationHKUSZH_fc.fc_age0to18);

hospitalizationHKUSZH_fc.fc_age19to58 = movmean(hospitalizationHKUSZH_fc.fc_age19to58, 5);
hospitalizationHKUSZH_fc.fc_age19to58 = round(hospitalizationHKUSZH_fc.fc_age19to58);

hospitalizationHKUSZH_fc.fc_age59over = movmean(hospitalizationHKUSZH_fc.fc_age59over, 5);
hospitalizationHKUSZH_fc.fc_age59over = round(hospitalizationHKUSZH_fc.fc_age59over);



% 4. Load prevalence data 
prevData = readtable("data/2022_12_26_prevalence_shenzhenpollingfrom1218.xlsx");
prevData.date = datenum(prevData.date) - dateZero;   
P_positive = prevData.perc_ever_positive;

% 5. Load serial interval data
genTimeData = readtable('data/si_data_20200508.csv');     
genTimeData = genTimeData{:, 3:4};

% 6. Load MCMC results
% Fixed child susceptibility
childSuscept = 1;

% Fixed parameters for SEIR model
tStart = 1;
tEnd = dateEnd;

% Incubation period parameters
meanIncubation = 3.5;
stdIncubation = 3.9 / 5.2 * meanIncubation;
shapeIncu = (stdIncubation * stdIncubation) / meanIncubation;
scaleIncu = meanIncubation / shapeIncu;
numDays = tEnd - tStart;

% Generate incubation period PDFs and CDFs
pdfIncubation = gamcdf(2:(numDays + 1), shapeIncu, scaleIncu) - ...
                gamcdf(1:numDays, shapeIncu, scaleIncu); 
pdfIncubation = pdfIncubation(1:20);
cdfIncubation = cumsum(pdfIncubation);
cdfIncubation(length(cdfIncubation)) = 1;

% Population data for transmission dynamics
totalPopulation = totalPopulationAgeBand;
numEstate = 1;
numIstate = 4;
numRstate = 4;
durExposed = 1;
dt = 0.1;

% Load MCMC results
mcmcRes = readmatrix('./mcmc_result/China_subnational_Shenzhen_GD_mcmc_res.csv');
mcmcRes = mcmcRes(mcmcRes(:, 1) ~= 0, :);
mcmcRes = mcmcRes(0.4 * length(mcmcRes(:, 1)):2:end, :);

% Extract parameters from MCMC results
scaleRtArr = mcmcRes(:, [1, 2]);
genTimeArr = mcmcRes(:, 3) .* normrnd(1, 0.05, size(mcmcRes(:, 3)));
seedSizeArr = mcmcRes(:, 4);
propReportArr = mcmcRes(:, 5);
p_acArr = mcmcRes(:, 6);
a_dh_hospArr = mcmcRes(:, 7);
b_dh_hospArr = mcmcRes(:, 8);
a_fc_hospArr = mcmcRes(:, 9);
b_fc_hospArr = mcmcRes(:, 10);

% Age-specific hospitalization probabilities
pSZHdh_age1Arr = mcmcRes(:, 11);
pSZHdh_age2Arr = mcmcRes(:, 12);
pSZHdh_age3Arr = mcmcRes(:, 13);
pSZHfc_age1Arr = mcmcRes(:, 14);
pSZHfc_age2Arr = mcmcRes(:, 15);
pSZHfc_age3Arr = mcmcRes(:, 16);

% Run SEIR model for each MCMC sample
for iiMCMC = 1:length(mcmcRes(:, 1))
   [out, recRt] = SEIR_memory(scaleRtArr(iiMCMC, 1:2), ...
       contactMatr, childSuscept, genTimeArr(iiMCMC, 1), seedSizeArr(iiMCMC, 1), ...
       totalPopulation, durExposed, dataBeijing.total / dataBeijing.total(dataBeijing.date == 1), ...
       numEstate, numIstate, dt, tStart, tEnd + 40, dateChange, sa, sag1);
    
   dRt(:, iiMCMC) = movmean(recRt, 3);
end

% Regenerate generation times and run additional simulations
genTimeArr = mcmcRes(:, 3) .* normrnd(1, 0.02, size(mcmcRes(:, 3)));
for iiMCMC = 1:length(mcmcRes(:, 1))
   [out, recRt] = SEIR_memory(scaleRtArr(iiMCMC, 1:2), ...
       contactMatr, childSuscept, genTimeArr(iiMCMC, 1), seedSizeArr(iiMCMC, 1), ...
       totalPopulation, durExposed, dataBeijing.total / dataBeijing.total(dataBeijing.date == 1), ...
       numEstate, numIstate, dt, tStart, tEnd + 40, dateChange, sa, sag1);

    dInc(:, iiMCMC) = movmean(out(:, 2), 3);
    dCumInc(:, iiMCMC) = out(:, 3);  
    dPrev(:, iiMCMC) = movmean(out(:, 4), 3);
    dOnset(:, iiMCMC) = movmean(out(:, 5), 3);
    dHospitalization(:, iiMCMC) = movmean(out(:, 6), 3);
end

% Plot configuration
colorMp = [
204, 0,   0;
0, 153,   76;
255, 178, 102;
51, 153, 255;
51, 51, 51;
127, 127, 0;
255, 51, 153] / 255;

figure;
set(gcf, 'WindowState', 'maximized'); % Set figure window to maximized



% Plotting Rt from dRt, calculated from recRt based on serial interval data.

subplot(5,1,[1,2])
set(gcf,'WindowState','maximized'); % Set the figure window to maximized.

% Calculate the mean Rt
meanRt = mean(dRt, 2);

% Plot Rt confidence interval as a shaded region
hRtPatch = patch('XData', [out(:,1)', fliplr(out(:,1)')], ...
    'YData', [prctile(dRt, 2.5, 2)', fliplr(prctile(dRt, 97.5, 2)')], ...
    'FaceColor', colorMp(1, :), ...
    'EdgeColor', 'none', ...
    'FaceAlpha', 0.1);
hold on

% Plot mean Rt
hRt = plot(meanRt, 'LineWidth', 1, 'Color', colorMp(1, :));
hold on

% Add a horizontal line at Rt = 1
hHorz = line([0, dateEnd+9], [1, 1], 'LineWidth', 0.75, 'LineStyle', '--', 'Color', 'Black');

% Configure plot appearance
set(gca, 'box', 'off', ...
    'YTick', 0:5, ...
    'XTick', 1:7:(dateEnd+9), ...
    'XTickLabel', {'Nov 18', 'Nov 25', 'Dec 2', 'Dec 9', 'Dec 16', 'Dec 23', ...
    'Dec 30', 'Jan 6', 'Jan 13', 'Jan 20', 'Jan 27', 'Feb 3', 'Feb 10'});
xticklabels = get(gca, 'XTickLabel');
set(gca, 'XTickLabel', xticklabels, 'FontSize', 9);

hold off

% Label the y-axis
ylabel('R_t', 'FontSize', 10);
ylim([0, 5])
xlim([0.5, dateEnd+9]);

% Highlight Spring Festival holiday (Jan 21 - Jan 27)
xr = xregion([65 71], 'FaceColor', [0.749, 0.847, 1]);

hold on

% Add text annotations with arrows
annotation('textarrow', [0.1797 0.1797], [0.9051 0.7321], ...
    'String', {'                                                        Nov 23: issued Notice No. 8 to enhance PHSMs'}, ...
    'HeadWidth', 5, 'HeadLength', 5, 'FontSize', 8.5);

annotation('textarrow', [0.2689 0.2689], [0.855 0.7377], ...
    'String', '                                                                                            Dec 3: no longer checked PCR testing for public transportation', ...
    'HeadWidth', 5, 'HeadLength', 5, 'FontSize', 8.5);

annotation('textarrow', [0.3546 0.3546], [0.809 0.783], ...
    'String', {'                                                                                           Dec 12: no longer checked Health QR code for public transportation'}, ...
    'HeadWidth', 5, 'HeadLength', 5, 'FontSize', 8.5);

% Add textbox for section labels
annotation('textbox', ...
    [0.0360 0.0716 0.0281 0.8863], ...
    'String', {'A','','','','','','','','','','','','','B','','','','','','C','','','','','','D'}, ...
    'FontWeight', 'bold', 'FontSize', 11, ...
    'FitBoxToText', 'off', 'EdgeColor', 'none');

annotation('textarrow', [0.4659 0.4659], [0.7866 0.6727], ...
    'String', {'                                                                  Dec 24: daily No. of subway passengers started to increase'}, ...
    'HeadWidth', 5, 'HeadLength', 5, 'FontSize', 8.5);

annotation('textarrow', [0.2436 0.2436], [0.882 0.729], ...
    'String', {'                                                                       Nov 30: reaffirmed 20 measures for further relaxing PHSMs'}, ...
    'HeadWidth', 5, 'HeadLength', 5, 'FontSize', 8.5);

% textarrow4
annotation('textarrow',[0.295534635555379 0.295534635555379],...
    [0.8324 0.7595],...
    'String',{'                                                                   Dec 5: issued Notice No. 9 to relax PHSMs'},...
    'HeadWidth',5,...
    'HeadLength',5,...
    'FontSize',8.5);

% textarrow8
annotation('textarrow',[0.60262529 0.60262529],...
    [0.7273 0.6428],...
    'String',{'                                    Jan 8: managed COVID-19 with measures','                                                        against Class-B instead of Class-A infectious diseases'},...
    'HeadWidth',5,...
    'HeadLength',5,...
    'FontSize',8.5);



% Incidence
subplot(5,1,3)
set(gcf,'WindowState','maximized'); 
% yyaxis left
set(gca,'ycolor','k')
meanInc = mean(dInc, 2);

hIncPatch = patch('XData',[out(:,1)',fliplr(out(:,1)')],...
    'YData',[prctile(dInc,2.5,2)',fliplr(prctile(dInc,97.5,2)')],...
    'FaceColor',colorMp(2,:),...
    'EdgeColor','none',...
    'FaceAlpha',0.1);
hold on
hInc = plot(meanInc,...
    'LineWidth',1,'Color',colorMp(2,:));
hold on
set(gca,'box','off', 'FontSize', 9,...
    'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})

%xr2 = xregion([65 71],FaceColor=[0.749, 0.847, 1]);
xr2 = xregion([65 71],'FaceColor',[0.749, 0.847, 1]);

hold off
ylabel('Daily incidence','FontSize',10)
xlim([0.5,dateEnd+9]);
hold off






% Cumulative IAR
subplot(5,1,4)
set(gcf,'WindowState','maximized'); 
meanCumIAR = mean(dCumInc/sum(totalPopulationAgeBand), 2);

%%%%%%%%%%%%%%%%%%%%%%%%%% add polls
xTick1 = 1:7:(dateEnd+9);
xTick2 = out(:,1)';
[~, index1] = ismember(prevData.date, xTick1);
[~, index2] = ismember(prevData.date, xTick2);
hold on
[phat,pci] = binofit(prevData.no_ever_positive,prevData.no_participants);
p1 = errorbar(index2, phat, (phat - pci(:,1))', (pci(:,2) - phat)', 'LineStyle', 'none', 'Color','k', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 2, 'MarkerFaceColor', 'k', 'CapSize', 0);
%%%%%%%%%%%%%%%%%%%%%%%%%% add polls
hold on
hIncPatch = patch('XData',[out(:,1)',fliplr(out(:,1)')],...
    'YData',[prctile(dCumInc/sum(totalPopulationAgeBand),2.5,2)',fliplr(prctile(dCumInc/sum(totalPopulationAgeBand),97.5,2)')],...
    'FaceColor',colorMp(3,:),...
    'EdgeColor','none',...
    'FaceAlpha',0.1);
hold on
hCumIAR = plot(meanCumIAR,...
    'LineWidth',1,'Color',colorMp(3,:));
hold on
set(gca,'box','off', 'FontSize', 9,...
    'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})

%xr3 = xregion([65 71],FaceColor=[0.749, 0.847, 1]);
xr3 = xregion([65 71],'FaceColor',[0.749, 0.847, 1]);

% hold off
% hold on
ylabel('Cumulative IAR','FontSize',10)
xlim([0.5,dateEnd+9]);
ylim([0,1])
% legend([p1],{'Participants testing positive, %'})
legend([p1,xr3],{'Participants testing positive rate','CNY holiday'}, 'FontSize', 8,'box','off','Location','Northwest','NumColumns',2);
hold off



subplot(5,1,5)   
set(gcf,'WindowState','maximized'); 
yyaxis left
set(gca,'ycolor','k','box','off')
hCase = bar([localCase1213.num_new_confirmed_case_local(1:cutoffDate1213),localCase1213.num_new_asym_case_local(1:cutoffDate1213)],'stacked');
set(hCase(1),"EdgeColor","none","FaceColor",colorMp(3,:),"FaceAlpha",0.7);
set(hCase(2),"EdgeColor","none","FaceColor",colorMp(4,:),"FaceAlpha",0.7);
set(gca,'box','off', 'FontSize', 9,...
    'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})
% xticklabels = get(gca, 'XTickLabel');
% set(gca, 'XTickLabel', xticklabels);
hold off
ylabel('No. of reported cases','FontSize',10);
ylim([0,480])
xlim([0.5,dateEnd+9]);

% % Set ticklength property for the top axis to 0
% ax = gca;
% ax.TickLength = [0 0];




yyaxis right
set(gca,'ycolor','k','box','off')
hMTRSZ = plot(bjMTRdata.total2,'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
ylabel('No. of subway passengers','FontSize',10)
ylim([0,820])
% xlim([0.5,dateEnd+9]);
%xr = xregion([65 71],FaceColor=[0.749, 0.847, 1]);
xr = xregion([65 71],'FaceColor',[0.749, 0.847, 1]);


% hLegend = legend([hCase(1),hCase(2),xr],...
%     {'No. of reported symptomatic cases',...
%     'No. of reported asymptomatic cases',...
%     'CNY holiday'});
% set(hLegend,'box','off','Location','Northwest','NumColumns',3, 'FontSize', 8.5)
hLegend = legend([hCase(1),hCase(2),xr],...
    {'No. of reported symptomatic cases',...
    'No. of reported asymptomatic cases'});
set(hLegend,'box','off','Location','Northwest','NumColumns',2, 'FontSize', 8)

hold off


% % subplot(5,1,5)  
% % set(gcf,'WindowState','maximized');
% % yyaxis left
% % set(gca,'ycolor','k')
% % 
% % hMTRSZ = plot(bjMTRdata.total2,'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
% % % set(gca,'box','off',...
% % %     'YTick',0:1000)
% % 
% % set(gca,'box','off', 'FontSize', 9,...
% %     'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})
% % % xticklabels = get(gca, 'XTickLabel');
% % % set(gca, 'XTickLabel', xticklabels);
% % % hold off
% % 
% % ylabel('No. of subway passengers','FontSize',11)
% % xlim([0.5,dateEnd+9]);
% % ylim([0,800])
% % % yticks(linspace(0, max(bjMTRdata.total2), 5));
% % 
% % %
% % xr = xregion([65 71],FaceColor=[0.749, 0.847, 1]);
% % 
% % % 
% % hLegend = legend([xr],...
% %     {
% %     'CNY holiday'});
% % set(hLegend,'box','off','Location','Northwest','NumColumns',1,'FontSize',8.5)
% % 
% % % % 
% % % yyaxis left
% % % set(gca,'ycolor','k')
% % hold off


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% daily prevalence
% subplot(5,1,4)
% set(gcf,'WindowState','maximized'); 
% hIncPatch = patch('XData',[out(:,1)',fliplr(out(:,1)')],...
%     'YData',[prctile(dPrev,2.5,2)',fliplr(prctile(dPrev,97.5,2)')],...
%     'FaceColor',colorMp(4,:),...
%     'EdgeColor','none',...
%     'FaceAlpha',0.1);
% hold on
% hInc = plot(prctile(dPrev,50,2),...
%     'LineWidth',1,'Color',colorMp(4,:));
% hold on
% set(gca,'box','off',...
%     'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})
% hold off
% ylabel('Daily Point Prevalence')
% xlim([0.5,dateEnd+9]);


% % daily prevalence rate
% subplot(6,1,4)
% set(gcf,'WindowState','maximized');
% hIncPatch = patch('XData',[out(:,1)',fliplr(out(:,1)')],...
%     'YData',[prctile(dPrev/sum(totalPopulationAgeBand),2.5,2)',fliplr(prctile(dPrev/sum(totalPopulationAgeBand),97.5,2)')],...
%     'FaceColor',colorMp(5,:),...
%     'EdgeColor','none',...
%     'FaceAlpha',0.1);
% hold on
% hInc = plot(prctile(dPrev/sum(totalPopulationAgeBand),50,2),...
%     'LineWidth',1,'Color',colorMp(5,:));
% hold on
% set(gca,'box','off',...
%     'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})
% hold off
% ylabel('Daily Prevalence Rate')
% xlim([0.5,dateEnd+9]);
% hold off
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% A_onset_rate (standardized)
% subplot(6,1,5)
% set(gcf,'WindowState','maximized');
% %%%%% add observed onset
% hIncPatch = patch('XData',[out(:,1)',fliplr(out(:,1)')],...
%     'YData',[prctile(dOnset/sum(dOnset),2.5,2)',fliplr(prctile(dOnset/sum(dOnset),97.5,2)')],...
%     'FaceColor',colorMp(6,:),...
%     'EdgeColor','none',...
%     'FaceAlpha',0.1);
% hold on
% hInc = plot(prctile(dOnset/sum(dOnset),50,2),...
%     'LineWidth',1,'Color',colorMp(6,:));
% hold on
% set(gca,'box','off',...
%     'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})
% hold off
% ylabel('Daily Onsets Rate')
% xlim([0.5,dateEnd+9]);
% hold off
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% hospitalizations_rate (standardized)。
% subplot(6,1,6)
% set(gcf,'WindowState','maximized');
% %%%%% add observed onset
% %%%%%%%%%%%%%%%%%%%%%%%%%% add ObsHospitalizationRate begin  hospitalizationHKUSZH.date
% xTick3 = 1:7:(dateEnd+9);
% xTick4 = out(:,1)';
% [~, index3] = ismember(hospitalizationHKUSZH.date, xTick3);
% [~, index4] = ismember(hospitalizationHKUSZH.date, xTick4);
% hold on
% % plot(index1, P_positive, 'ko');
% p2 = plot(index4, ObsHospitalizationRate, 'ko','MarkerFaceColor', 'k','MarkerSize', 4, 'DisplayName', 'ObsHospitalizationRate from HKUSZH'); 
% %%%%%%%%%%%%%%%%%%%%%%%%%% add ObsHospitalizationRate end
% hold on
% hIncPatch = patch('XData',[out(:,1)',fliplr(out(:,1)')],...
%     'YData',[prctile(dHospitalization/sum(dHospitalization),2.5,2)',fliplr(prctile(dHospitalization/sum(dHospitalization),97.5,2)')],...
%     'FaceColor',colorMp(7,:),...
%     'EdgeColor','none',...
%     'FaceAlpha',0.1);
% hold on
% hInc = plot(prctile(dHospitalization/sum(dHospitalization),50,2),...
%     'LineWidth',1,'Color',colorMp(7,:));
% hold on
% set(gca,'box','off',...
%     'XTick',1:7:(dateEnd+9),'XTickLabel',{'Nov 18','Nov 25','Dec 2','Dec 9','Dec 16','Dec 23','Dec 30','Jan 6','Jan 13','Jan 20','Jan 27','Feb 3','Feb 10'})
% hold off
% ylabel('Daily Hospitalizations Rate')
% xlim([0.5,dateEnd+9]);
% legend([p2],{'ObsHospitalizationRate from HKUSZH'})
% hold off
% 
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dates = datetime('2022-11-17') + caldays(0:size(out,1)-1);
dates = datestr(dates, 'yyyy/mm/dd');


data = table(out(:,1), ...
             dates, ...
             meanRt, prctile(dRt,2.5,2), prctile(dRt,97.5,2), ...
             meanInc, prctile(dInc,2.5,2), prctile(dInc,97.5,2), ...
             meanCumIAR, prctile(dCumInc/sum(totalPopulationAgeBand),2.5,2), prctile(dCumInc/sum(totalPopulationAgeBand),97.5,2), ...
             prctile(dPrev,50,2), prctile(dPrev,2.5,2), prctile(dPrev,97.5,2), ...
             prctile(dPrev/sum(totalPopulationAgeBand),50,2), prctile(dPrev/sum(totalPopulationAgeBand),2.5,2), prctile(dPrev/sum(totalPopulationAgeBand),97.5,2), ...
             prctile(dOnset,50,2), prctile(dOnset,2.5,2), prctile(dOnset,97.5,2), ...
             prctile(dHospitalization,50,2), prctile(dHospitalization,2.5,2), prctile(dHospitalization,97.5,2), ...
             prctile(dHospitalization/sum(dHospitalization),50,2), prctile(dHospitalization/sum(dHospitalization),2.5,2), prctile(dHospitalization/sum(dHospitalization),97.5,2), ...
             'VariableNames', {'days', ...
                               'dates', ...
                               'dRt_median', 'dRt_lower', 'dRt_upper', ...
                               'dInc_median', 'dInc_lower', 'dInc_upper', ...
                               'dCumInc_median', 'dCumInc_lower', 'dCumInc_upper', ...
                               'dPrev_median', 'dPrev_lower', 'dPrev_upper', ...
                               'dPrevNorm_median', 'dPrevNorm_lower', 'dPrevNorm_upper',...
                               'dOnset_median', 'dOnset_lower', 'dOnset_upper',...
                               'dHospitalization_median', 'dHospitalization_lower', 'dHospitalization_upper',...
                               'dHospitalizationNorm_median', 'dHospitalizationNorm_lower', 'dHospitalizationNorm_upper'});


writetable(data, 'allmcmcresults/main_plot_results_SZ_epifrom1118.csv');




