clear all
clc

countryText = 'China_subnational_Shenzhen_GD';

for seedSizefor = [300]
   % x0(3) = seedSizefor;
   for scaleRt2for = 0.07  %0.09
       for pReportfor = 0.2       
             for scaleRt1for = 0.02
               scaleRt = [scaleRt1for,scaleRt2for];
                  for sa = [33]  
                     for sag1 = 6
                         for pSZH_dhfor = [0.001]  
                             for p_acfor = 0.8    
                                 for a_dh = 1.4  
                                     for b_dh = 2.3  
                                         for a_fc = 1.4 
                                             for b_fc = 2.3 
                                                 for pSZH_fcfor = [0.001]

                             dfor = 0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% step1：for main_plot_result
disp(['will start drawing results,sag1 is',num2str(sag1),'___sa is',num2str(sa)]);

sourcefile = strcat('allmcmcresults/', countryText, '_mcmc_res_','dfor_is', num2str(dfor),'pSZH_fcfor_is', num2str(pSZH_fcfor),'a_dh_is', num2str(a_dh),'b_dh_is', num2str(b_dh),'a_fc_is', num2str(a_fc),'b_fc_is', num2str(b_fc),'p_acfor_is', num2str(p_acfor),'pSZH_dhfor_is', num2str(pSZH_dhfor),'_sag1_is', num2str(sag1),'_sa_is', num2str(sa), '_seedsizeis', num2str(seedSizefor) ,'_','_scaleRt2is', num2str(scaleRt2for), '_','_pReportis',num2str(pReportfor), '_','_scaleRt1is',num2str(scaleRt1for), '.csv');

movefile(strcat('mcmc_result/', countryText, '_mcmc_res.csv'), strcat('mcmc_result/', countryText, '_mcmc_res_','dfor_is', num2str(dfor),'pSZH_fcfor_is', num2str(pSZH_fcfor),'a_dh_is', num2str(a_dh),'b_dh_is', num2str(b_dh),'a_fc_is', num2str(a_fc),'b_fc_is', num2str(b_fc),'p_acfor_is', num2str(p_acfor),'pSZHhospifor_is', num2str(pSZH_dhfor),'_sag1_is', num2str(sag1),'_sa_is', num2str(sa), '_seedsizeis', num2str(seedSizefor), '_','_scaleRt2is', num2str(scaleRt2for),'_', '_pReportis',num2str(pReportfor),'_', '_scaleRt1is',num2str(scaleRt1for), '.csv'));


destfile = strcat('mcmc_result/', countryText, '_mcmc_res.csv');
if exist(sourcefile, 'file')
    % Copy the source file to the destination if it exists
    copyfile(sourcefile, destfile);
    disp(['Successfully copied file ', sourcefile, ' to ', destfile]);
else
    % Display error if the source file does not exist
    error(['Source file ', sourcefile, ' does not exist.']);
end

% Maximize the figure window
set(gcf, 'WindowState', 'maximized');

main_plot_result_4figs_best_1231

% Save the plot as an image
set(gcf, 'Visible', 'on');
frame = getframe(gcf); 
imageData11 = frame2im(frame);
imwrite(imageData11, fullfile('allmcmcresults', strcat(countryText, '_results_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), ...
    'pSZH_dhfor_is', num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), ...
    '_sa_is', num2str(sa), '_seedSizeis', num2str(seedSizefor), '_', ...
    '_scaleRt2is', num2str(scaleRt2for), '_', '_pReportis', num2str(pReportfor), ...
    '_', '_scaleRt1is', num2str(scaleRt1for), '.png')));
disp(['Finished drawing results, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

% Delete the MCMC result file to prepare for the next loop
if exist(destfile, 'file')
    delete(destfile);
    disp(['Successfully deleted file ', destfile, ' to prepare for the next plot.']);
else
    disp(['File to delete ', destfile, ' does not exist.']);
end

% Rename the table results file to avoid overwriting during the loop
sourcefile2 = 'allmcmcresults/main_plot_results_SZ_epifrom1118.csv'; 
destfile2 = strcat('allmcmcresults/main_plot_results_SZ_epifrom1118', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), ...
    'pSZH_dhfor_is', num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), ...
    '_sa_is', num2str(sa), '_seedsizeis', num2str(seedSizefor), '_', ...
    '_scaleRt2is', num2str(scaleRt2for), '_', '_pReportis', num2str(pReportfor), ...
    '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
if exist(sourcefile2, 'file')
    % Copy the source file to the destination if it exists
    copyfile(sourcefile2, destfile2);
    disp(['Successfully copied file ', sourcefile2, ' to ', destfile2]);
else
    % Display error if the source file does not exist
    error(['Source file ', sourcefile2, ' does not exist.']);
end

% Delete the original table file after renaming
if exist(sourcefile2, 'file')
    delete(sourcefile2);
    disp(['Successfully deleted file ', sourcefile2]);
else
    disp(['File to delete ', sourcefile2, ' does not exist.']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 2: BIC
sourcefile31 = strcat('allmcmcresults/', countryText, '_log_likelihood_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
destfile31 = strcat('mcmc_result/', countryText, '_log_likelihood.csv');
if exist(sourcefile31, 'file')
    % Copy the source file if it exists
    copyfile(sourcefile31, destfile31);
    disp(['Successfully copied file ', sourcefile31, ' to ', destfile31]);
else
    error(['Source file ', sourcefile31, ' does not exist.']);
end

% Maximize the figure window
set(gcf, 'WindowState', 'maximized');

BIC_distribution_withinlogL_0829for_auto

% Save the plot as an image
set(gcf, 'Visible', 'on');
frame = getframe(gcf); 
imageData31 = frame2im(frame);
imwrite(imageData31, fullfile('allmcmcresults', strcat(countryText, '_BIC_logL_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedSizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.png')));
disp(['Finished drawing BIC_logL, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

% Delete the log_likelihood file to prepare for the next loop
if exist(destfile31, 'file')
    delete(destfile31);
    disp(['Successfully deleted file ', destfile31, ' to prepare for the next plot.']);
else
    disp(['File to delete ', destfile31, ' does not exist.']);
end

sourcefile32 = 'allmcmcresults/BIC_all.csv'; 
destfile32 = strcat('allmcmcresults/BIC_all', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
if exist(sourcefile32, 'file')
    copyfile(sourcefile32, destfile32);
    disp(['Successfully copied file ', sourcefile32, ' to ', destfile32]);
else
    error(['Source file ', sourcefile32, ' does not exist.']);
end

if exist(sourcefile32, 'file')
    delete(sourcefile32);
    disp(['Successfully deleted file ', sourcefile32]);
else
    disp(['File to delete ', sourcefile32, ' does not exist.']);
end

sourcefile33 = 'allmcmcresults/BIC_withoutburnin_all.csv'; 
destfile33 = strcat('allmcmcresults/BIC_withoutburnin_all', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
if exist(sourcefile33, 'file')
    copyfile(sourcefile33, destfile33);
    disp(['Successfully copied file ', sourcefile33, ' to ', destfile33]);
else
    error(['Source file ', sourcefile33, ' does not exist.']);
end

if exist(sourcefile33, 'file')
    delete(sourcefile33);
    disp(['Successfully deleted file ', sourcefile33]);
else
    disp(['File to delete ', sourcefile33, ' does not exist.']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 3: posterior distributions
disp(['Will start drawing posterior distributions, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);
sourcefile41 = strcat('allmcmcresults/', countryText, '_mcmc_res_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
destfile41 = strcat('mcmc_result/', countryText, '_mcmc_res.csv');
if exist(sourcefile41, 'file')
    copyfile(sourcefile41, destfile41);
    disp(['Successfully copied file ', sourcefile41, ' to ', destfile41]);
else
    error(['Source file ', sourcefile41, ' does not exist.']);
end

% Maximize the figure window
set(gcf, 'WindowState', 'maximized');
posterior_distributions

% Save the plot as an image
set(gcf, 'Visible', 'on');
frame = getframe(gcf); 
imageData41 = frame2im(frame);
imwrite(imageData41, fullfile('allmcmcresults', strcat(countryText, '_PosteriorDistri_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedSizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.png')));
disp(['Finished drawing PosteriorDistri, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

% Delete the MCMC result file to prepare for the next loop
if exist(destfile41, 'file')
    delete(destfile41);
    disp(['Successfully deleted file ', destfile41, ' to prepare for the next plot.']);
else
    disp(['File to delete ', destfile41, ' does not exist.']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 4: ACF
disp(['Will start drawing ACF, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

sourcefile51 = strcat('allmcmcresults/', countryText, '_mcmc_res_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
destfile51 = strcat('mcmc_result/', countryText, '_mcmc_res.csv');
if exist(sourcefile51, 'file')
    % Copy the source file if it exists
    copyfile(sourcefile51, destfile51);
    disp(['Successfully copied file ', sourcefile51, ' to ', destfile51]);
else
    error(['Source file ', sourcefile51, ' does not exist.']);
end

% Maximize the figure window
set(gcf, 'WindowState', 'maximized');

acf_0409  % Run the ACF script

% Save the plot as an image
set(gcf, 'Visible', 'on');
frame = getframe(gcf); 
imageData51 = frame2im(frame);
imwrite(imageData51, fullfile('allmcmcresults', strcat(countryText, '_ACF_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedSizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.png')));
disp(['Finished drawing ACF, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

% Delete the MCMC result file to prepare for the next loop
if exist(destfile51, 'file')
    delete(destfile51);
    disp(['Successfully deleted file ', destfile51, ' to prepare for the next plot.']);
else
    disp(['File to delete ', destfile51, ' does not exist.']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Step 5: Trace plots
disp(['Will start drawing trace, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

% Copy mcmc_res to the mcmc_result folder
sourcefile61 = strcat('allmcmcresults/', countryText, '_mcmc_res_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
destfile61 = strcat('mcmc_result/', countryText, '_mcmc_res.csv');
if exist(sourcefile61, 'file')
    copyfile(sourcefile61, destfile61);
    disp(['Successfully copied file ', sourcefile61, ' to ', destfile61]);
else
    error(['Source file ', sourcefile61, ' does not exist.']);
end

% Copy log_likelihood to the mcmc_result folder
sourcefile71 = strcat('allmcmcresults/', countryText, '_log_likelihood_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedsizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.csv');
destfile71 = strcat('mcmc_result/', countryText, '_log_likelihood.csv');
if exist(sourcefile71, 'file')
    copyfile(sourcefile71, destfile71);
    disp(['Successfully copied file ', sourcefile71, ' to ', destfile71]);
else
    error(['Source file ', sourcefile71, ' does not exist.']);
end

% Maximize the figure window
set(gcf, 'WindowState', 'maximized');

traceplots_0417_together_withinlogL  % Run the trace plots script

% Save the plot as an image
set(gcf, 'Visible', 'on');
frame = getframe(gcf); 
imageData61 = frame2im(frame);
imwrite(imageData61, fullfile('allmcmcresults', strcat(countryText, '_traceplots_withinlogL_', ...
    'dfor_is', num2str(dfor), 'pSZH_fcfor_is', num2str(pSZH_fcfor), ...
    'a_dh_is', num2str(a_dh), 'b_dh_is', num2str(b_dh), 'a_fc_is', num2str(a_fc), ...
    'b_fc_is', num2str(b_fc), 'p_acfor_is', num2str(p_acfor), 'pSZH_dhfor_is', ...
    num2str(pSZH_dhfor), '_sag1_is', num2str(sag1), '_sa_is', num2str(sa), ...
    '_seedSizeis', num2str(seedSizefor), '_', '_scaleRt2is', num2str(scaleRt2for), ...
    '_', '_pReportis', num2str(pReportfor), '_', '_scaleRt1is', num2str(scaleRt1for), '.png')));
disp(['Finished drawing traceplots_withinlogL, sag1 is ', num2str(sag1), ' ___ sa is ', num2str(sa)]);

% Delete the mcmc_res file to prepare for the next loop
if exist(destfile61, 'file')
    delete(destfile61);
    disp(['Successfully deleted file ', destfile61, ' to prepare for the next plot.']);
else
    disp(['File to delete ', destfile61, ' does not exist.']);
end

% Delete the log_likelihood file to prepare for the next loop
if exist(destfile71, 'file')
    delete(destfile71);
    disp(['Successfully deleted file ', destfile71, ' to prepare for the next plot.']);
else
    disp(['File to delete ', destfile71, ' does not exist.']);
end




                                                 end
                                             end
                                          end
                                     end
                                 end
                             end
                         end
                     end
                  end
             end
       end
   end
 end



