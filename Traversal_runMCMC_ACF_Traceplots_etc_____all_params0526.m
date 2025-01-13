clear all;
clc

rng('shuffle');
countryText = 'China_subnational_Shenzhen_GD';

if ~exist('OHP_daily_estimates0828','dir')
mkdir OHP_daily_estimates0828
end

for seedSizefor = [1000]
for scaleRt2for = 0.07
  for pReportfor = 0.08        
   for scaleRt1for = 0.02
   scaleRt = [scaleRt1for,scaleRt2for];
    for sa = [33]  
     for sag1 = 6
      for p_acfor = 0.9
       for a_dh = 0.98   % directly hospitalization shape
        for b_dh = 0.75  % directly hospitalization scale
         for a_fc = 0.88  % from fever clinic shape
          for b_fc = 0.75  % from fever clinic scale
           for a_all = 0.92
            for b_all = 0.75
             for pSZHdh_age1 = 0.0001
              for pSZHdh_age2 = 0.0001
               for pSZHdh_age3 = 0.0001
                for pSZHfc_age1 = 0.0001
                 for pSZHfc_age2 = 0.0001
                  for pSZHfc_age3 = 0.0001

                             dfor = 0;
                             pSZH_dhfor = 0;
                             pSZH_fcfor = 0;

filename = strcat('mcmc_result/', countryText, '_mcmc_res.csv');

data = readtable(filename);

meanlog_dh = data{:, 7};
sdlog_dh = data{:, 8};

mean_dh = exp(meanlog_dh + (sdlog_dh.^2)/2);
sd_dh = sqrt((exp(sdlog_dh.^2) - 1) .* exp(2*meanlog_dh + sdlog_dh.^2));

data.mean_dh = mean_dh;
data.sd_dh = sd_dh;

% Write to CSV file, overwrite original file
writetable(data, filename);

meanlog_fc = data{:, 9};
sdlog_fc = data{:, 10};

mean_fc = exp(meanlog_fc + (sdlog_fc.^2)/2);
sd_fc = sqrt((exp(sdlog_fc.^2) - 1) .* exp(2*meanlog_fc + sdlog_fc.^2));

data.mean_fc = mean_fc;
data.sd_fc = sd_fc;

% Write to CSV file, overwrite original file
writetable(data, filename);

        movefile(strcat('mcmc_result/', countryText, '_parameter_step.csv'), strcat('mcmc_result/', countryText, '_parameter_step_', '.csv'));
        movefile(strcat('mcmc_result/', countryText, '_mcmc_res.csv'), strcat('mcmc_result/', countryText, '_mcmc_res_', '.csv'));
        movefile(strcat('mcmc_result/', countryText, '_log_likelihood.csv'), strcat('mcmc_result/', countryText, '_log_likelihood_' , '.csv'));
        movefile(strcat('mcmc_result/', countryText, '_mle.csv'), strcat('mcmc_result/', countryText, '_mle_' , '.csv'));

       
        movefile(strcat('mcmc_result/', countryText, '_parameter_step_', '.csv'), strcat('allmcmcresults/', countryText, '_parameter_step_','.csv'));
        movefile(strcat('mcmc_result/', countryText, '_mcmc_res_', '.csv'), strcat('allmcmcresults/', countryText, '_mcmc_res_','.csv'));
        movefile(strcat('mcmc_result/', countryText, '_log_likelihood_', '.csv'), strcat('allmcmcresults/', countryText, '_log_likelihood_','.csv'));
        movefile(strcat('mcmc_result/', countryText, '_mle_', '.csv'), strcat('allmcmcresults/', countryText, '_mle_','.csv'));

% Successfully moved MCMC result files to allmcmcresults folder
disp('MCMC result files have been successfully moved to allmcmcresults folder.')
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
    end
   end
  end
 end

clear all;
rng('shuffle');
   
end



