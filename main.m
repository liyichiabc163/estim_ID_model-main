

% 0. Date
dateZero = datenum('2022/11/17','yyyy/mm/dd'); 

dateChange = datenum('2022/12/06','yyyy/mm/dd')-dateZero;    % 1114-1205-1225

dateEnd = datenum('2023/02/01','yyyy/mm/dd')-dateZero; 

% 1. Contact pattern
% Define age groups
dataDir = 'data/';
countryText = 'China_subnational_Shenzhen_GD';
totalPopulation = 17560061;
ageGroupDefRange = [-1,19,59,84];
% Age distribution
ageDistrTemp = readmatrix([dataDir,'age_distributions/',countryText,'_age_distribution_85.csv']);
totalPop = totalPopulation;
ageDistributionOneyear =  ageDistrTemp(:,2)/sum(ageDistrTemp(:,2));



% Contact matrix by setting
overallMatr = readmatrix([dataDir,'contact_matrices/',countryText,'_M_overall_contact_matrix_85.csv']); 
[overallMatr,ageDistribution] = polymodContactMatrix(ageGroupDefRange,overallMatr,ageDistributionOneyear,totalPop);
contactMatr = overallMatr;
totalPopulation = totalPop*ageDistribution;
totalPopulationAgeBand = totalPopulation;

% 2. Load Beijing MTR data
bjMTRdata = readtable('data\2023_02_01_subway_shenzhenfrom1101.xlsx');   
bjMTRdata = bjMTRdata(18:end,:); 
bjMTRdata.date = datenum(bjMTRdata.date)-dateZero;
bjMTRdata.total = movmean(bjMTRdata.total,5); % Moving average


% 3. Load Beijing local case data
cutoffDate = datenum('2022/11/30','yyyy/mm/dd')-dateZero;
localCase = readtable("data\2022_12_13_reported_case_shenzhenfrom1101.xlsx");  
localCase = localCase(18:end,:);  
localCase.date = datenum(localCase.date)-dateZero;  
localCase = localCase(localCase.date<=datenum(cutoffDate),:);  

localCase.num_local_case = localCase.symandasym; 
dataBeijing = outerjoin(bjMTRdata(:,{'date','total'}),localCase(:,{'date','num_local_case'}),...
    'LeftKeys','date','RightKeys','date','MergeKeys',true); 

% 6. Load HKUSZH data_______hospi  datahkuszh1hospi______decon data
d = 0;
datahkuszh1hospi = readtable("data\data_extracted_from_hospi_deconv_20230808_to0201.csv");  


% 8. direct hosp的。observed daily hospitalizations from HKUSZH，
d2 = 0;
hospitalizationHKUSZH_dh = readtable("data\data_extracted_from_the_sheet_named_Fever_Clinic_and_hospi_clean_0407_3_ages.csv"); 
hospitalizationHKUSZH_dh = hospitalizationHKUSZH_dh(2:(28+d2),:);  
hospitalizationHKUSZH_dh.date = datenum(hospitalizationHKUSZH_dh.date)-dateZero; 
hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever = movmean(hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever,5);
hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever = round(hospitalizationHKUSZH_dh.Counts_hospi_among_noto_fever);

hospitalizationHKUSZH_dh.dh_age0to18 = movmean(hospitalizationHKUSZH_dh.dh_age0to18,5);
hospitalizationHKUSZH_dh.dh_age0to18 = round(hospitalizationHKUSZH_dh.dh_age0to18);

hospitalizationHKUSZH_dh.dh_age19to58 = movmean(hospitalizationHKUSZH_dh.dh_age19to58,5);
hospitalizationHKUSZH_dh.dh_age19to58 = round(hospitalizationHKUSZH_dh.dh_age19to58);

hospitalizationHKUSZH_dh.dh_age59over = movmean(hospitalizationHKUSZH_dh.dh_age59over,5);
hospitalizationHKUSZH_dh.dh_age59over = round(hospitalizationHKUSZH_dh.dh_age59over);



% 9. from fever hosp--observed daily hospitalizations from HKUSZH，
d2 = 0;
hospitalizationHKUSZH_fc = readtable("data\data_extracted_from_the_sheet_named_Fever_Clinic_and_hospi_clean_0407_3_ages.csv"); 
hospitalizationHKUSZH_fc = hospitalizationHKUSZH_fc(2:(28+d2),:);    % 2 means 1213; 28 means 0108
hospitalizationHKUSZH_fc.date = datenum(hospitalizationHKUSZH_fc.date)-dateZero; 
hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever = movmean(hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever,5);
hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever = round(hospitalizationHKUSZH_fc.Counts_hospi_among_also_fever);

hospitalizationHKUSZH_fc.fc_age0to18 = movmean(hospitalizationHKUSZH_fc.fc_age0to18,5);
hospitalizationHKUSZH_fc.fc_age0to18 = round(hospitalizationHKUSZH_fc.fc_age0to18);

hospitalizationHKUSZH_fc.fc_age19to58 = movmean(hospitalizationHKUSZH_fc.fc_age19to58,5);
hospitalizationHKUSZH_fc.fc_age19to58 = round(hospitalizationHKUSZH_fc.fc_age19to58);

hospitalizationHKUSZH_fc.fc_age59over = movmean(hospitalizationHKUSZH_fc.fc_age59over,5);
hospitalizationHKUSZH_fc.fc_age59over = round(hospitalizationHKUSZH_fc.fc_age59over);




% 7. pdf of 'onset(infections convonluted by incubation)' to hospitalization of HKUSZH

pdfOHP_HKUSZH = readtable('data\onset_to_hospi_inferred_try0320_change_7_14_for_newSEIRmcmc.csv');
pdfOHP_HKUSZH = table2array(pdfOHP_HKUSZH); 
pdfOHP_HKUSZH = double(pdfOHP_HKUSZH);




% 4. Load Beijing prevalence data
prevData = readtable("data\2022_12_26_prevalence_shenzhenpollingfrom1218.xlsx");    
prevData.date = datenum(prevData.date)-dateZero;

% 5. Load serial interval data
genTimeData = readtable('data\si_data_20200508.csv');     
genTimeData = genTimeData{:,3:4};

% Model parameters


scaleRt = [scaleRt1for,scaleRt2for];
genTime = 4.6;
seedSize = seedSizefor;
propReport = pReportfor;
% pH_HKUSZH_dh = pH_HKUSZH_dhfor;  
% pH_HKUSZH_fc = pH_HKUSZH_fcfor;
pH_HKUSZH_dh = pSZH_dhfor;
pH_HKUSZH_fc = pSZH_fcfor;

pSZHdh_age1 = pSZHdh_age1;    
pSZHdh_age2 = pSZHdh_age2;
pSZHdh_age3 = pSZHdh_age3;

pSZHfc_age1 = pSZHfc_age1;
pSZHfc_age2 = pSZHfc_age2;
pSZHfc_age3 = pSZHfc_age3;
p_ac = p_acfor;
a_dh = a_dh;
b_dh = b_dh;
a_fc = a_fc;
b_fc = b_fc;
a_all = a_all;
b_all = b_all;




% Fixed child
childSuscept = 1;

% Fixed parameters
tStart = 1;
tEnd = dateEnd;
% incubation
meanIncubation = 3.5;
stdIncubation = 3.9/5.2*meanIncubation;
shapeIncu = (stdIncubation*stdIncubation)/meanIncubation;
scaleIncu = meanIncubation/shapeIncu;
numDays = tEnd-tStart;
pdfIncubation = gamcdf(2:(numDays+1),shapeIncu,scaleIncu) - gamcdf(1:numDays,shapeIncu,scaleIncu); 
pdfIncubation = pdfIncubation(1:20)';
cdfIncubation = cumsum(pdfIncubation);
cdfIncubation(length(cdfIncubation)) = 1;

% Total population for transmission dynamics
totalPopulation = totalPopulationAgeBand;
numEstate = 1;
numIstate = 4;
numRstate = 4;
durExposed = 1;
dt = 0.1;



totalLogL = totalLogLikelihood(dataBeijing,genTimeData,prevData,...
    scaleRt,genTime,seedSize,propReport,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pH_HKUSZH_dh,p_ac,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,a_dh,b_dh,a_fc,b_fc,a_all,b_all,hospitalizationHKUSZH_fc,pH_HKUSZH_fc,pSZHdh_age1,pSZHdh_age2,pSZHdh_age3,pSZHfc_age1,pSZHfc_age2,pSZHfc_age3);



disp(['Starting log likelihood: ',num2str(totalLogL)]);

% Test Likelihood function
% x0 = [scaleRt,genTime,seedSize,propReport,pH_HKUSZH_dh,p_ac,a_dh,b_dh,a_fc,b_fc,pH_HKUSZH_fc];
x0 = [scaleRt,genTime,seedSize,propReport,p_ac,a_dh,b_dh,a_fc,b_fc,pSZHdh_age1,pSZHdh_age2,pSZHdh_age3,pSZHfc_age1,pSZHfc_age2,pSZHfc_age3];  % 16
x0LowerBound = [0.001,0.001,genTime,0,0,0,0,0,0,0,0,0,0,0,0,0];
x0UpperBound = [0.1,0.1,genTime,4000,1,1,20,20,20,20,0.005,0.005,0.005,0.005,0.005,0.005];  
disp(['Starting neg log likelihood: ',num2str(negTotalLogLikelihood(...
    x0,...
    dataBeijing,genTimeData,prevData,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc))]); 


% Point estimates from fmincon
redeffun = @(x)negTotalLogLikelihood(x,dataBeijing,genTimeData,prevData,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc);
options = optimoptions(@fmincon,'Display','iter','MaxFunEvals',30000);
if exist(strcat('mcmc_result/',countryText,'_mle.csv'),'file') == 2
    x0 = csvread(strcat('mcmc_result/',countryText,'_mle.csv'));
    xfmin = fmincon(redeffun,x0,[],[],[],[],x0LowerBound,x0UpperBound,[],options);
    write_matrix_new(xfmin,strcat('mcmc_result/',countryText,'_mle.csv'),'w',',','dec');
else
    xfmin = fmincon(redeffun,x0,[],[],[],[],x0LowerBound,x0UpperBound,[],options);
    write_matrix_new(xfmin,strcat('mcmc_result/',countryText,'_mle.csv'),'w',',','dec');
end
write_matrix_new(xfmin,strcat('mcmc_result/',countryText,'_mle.csv'),'w',',','dec');

disp(['MLE neg log likelihood: ',num2str(negTotalLogLikelihood(...
    xfmin,...
    dataBeijing,genTimeData,prevData,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc))]); 

%xfmin = x0;
% MCMC
mcSteps = 150000;
if exist(strcat('mcmc_result/',countryText,'_parameter_step.csv'),'file') == 2
    stepSize = csvread(strcat('mcmc_result/',countryText,'_parameter_step.csv')); 
else
 
    stepSize = 0.05*xfmin; 
end
out = mcmcParallel(countryText,mcSteps,...
    dataBeijing,genTimeData,prevData,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,...
    xfmin,stepSize,x0LowerBound,x0UpperBound,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc);