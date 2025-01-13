
function totalLogL = totalLogLikelihood(dataBeijing,genTimeData,prevData,...
    scaleRt,genTime,seedSize,propReport,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStartArr,tEndArr,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pH_HKUSZH_dh,p_ac,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,a_dh,b_dh,a_fc,b_fc,a_all, b_all,hospitalizationHKUSZH_fc,pH_HKUSZH_fc,pSZHdh_age1,pSZHdh_age2,pSZHdh_age3,pSZHfc_age1,pSZHfc_age2,pSZHfc_age3)

%total hospi
total_hosp = [
  0.5, 70;
  1, 270;
  2, 173;
  3, 166;
  4, 88;
  5, 71;
  6, 34;
  7, 17;
  8, 23;
  9, 17;
  10, 11;
  11, 5;
  12, 11;
  13, 1;
  14, 2;
  15, 4;
  16, 0;
  17, 0;
  18, 1;
  19, 2;
  20, 4;
  21, 1
];

data_total_hosp = table(total_hosp(:,1), total_hosp(:,2), 'VariableNames', {'count_Date', 'Counts_total_hosp'});
x_total_hosp = repelem(data_total_hosp.count_Date, data_total_hosp.Counts_total_hosp);



logL_gam_all_hosp = sum(log(lognpdf(x_total_hosp,a_all,b_all)));
% direct hosp pdf
days_all_hosp = [0.5, 1:19];

pdf_gam_all_hosp = lognpdf(days_all_hosp', a_all, b_all);


% dh hospi data
direct_hosp = [
  0.5, 16;
  1, 94;
  2, 66;
  3, 80;
  4, 35;
  5, 27;
  6, 10;
  7, 10;
  8, 14;
  9, 7;
  10, 5;
  11, 2;
  12, 3;
  13, 1;
  14, 1;
  15, 2;
  16, 0;
  17, 0;
  18, 0;
  19, 1;
  20, 2;
  21, 1
];


data_direct_hosp = table(direct_hosp(:,1), direct_hosp(:,2), 'VariableNames', {'count_Date', 'Counts_direct_hosp'});

x_direct_hosp = repelem(data_direct_hosp.count_Date, data_direct_hosp.Counts_direct_hosp);

logL_gam_dh_hosp = sum(log(lognpdf(x_direct_hosp,a_dh,b_dh)));

days_dh_hosp  = [0.5, 1:19];
pdf_gam_dh_hosp = lognpdf(days_dh_hosp', a_dh, b_dh);


% % fc hospi
fev_cli_hosp = [
  0.5, 54;
  1, 176;
  2, 107;
  3, 86;
  4, 53;
  5, 44;
  6, 24;
  7, 7;
  8, 9;
  9, 10;
  10, 7;
  11, 3;
  12, 8;
  13, 0;
  14, 1;
  15, 2;
  16, 0;
  17, 0;
  18, 1;
  19, 1;
  20, 2
];

data_fev_cli_hosp = table(fev_cli_hosp(:,1), fev_cli_hosp(:,2), 'VariableNames', {'count_Date', 'Counts_fev_cli_hosp'});
x_fev_cli_hosp = repelem(data_fev_cli_hosp.count_Date, data_fev_cli_hosp.Counts_fev_cli_hosp);

logL_gam_fc_hosp = sum(log(lognpdf(x_fev_cli_hosp,a_fc,b_fc)));

days_fc_hosp  = [0.5, 1:19];
pdf_gam_fc_hosp = lognpdf(days_fc_hosp', a_fc, b_fc);


% 1. Log likelihood of generation time distribution
exactGenTimeLogL = sum(log(gampdf(genTimeData(genTimeData(:,1)==genTimeData(:,2),1),numIstate,genTime/numIstate)));
intervalGenTimeLogL = sum(log(...
    gamcdf(genTimeData(genTimeData(:,1)~=genTimeData(:,2),2),numIstate,genTime/numIstate)-...
    gamcdf(genTimeData(genTimeData(:,1)~=genTimeData(:,2),1),numIstate,genTime/numIstate)));

% 2. Log Likelihood of incidence
for iiWave = 1:length(tStartArr)   
    tStart = tStartArr(iiWave);  
    tEnd = tEndArr(iiWave); 
    [dailyRec,~] = SEIR_memory(scaleRt,...
        contactMatr,childSuscept,genTime,seedSize(iiWave),...
        totalPopulation,durExposed,dataBeijing.total/dataBeijing.total(dataBeijing.date==1),...
        numEstate,numIstate,dt,tStart,tEnd,dateChange,sa,sag1);
    dailyInc = dailyRec(:,[1,2]);  
    dailyCumInc = dailyRec(:,[1,3]); 
    dailyPrevalence = dailyRec(:,[1,4]);  

    dailyInc_age1 = dailyRec(:,[1,7]); % age 1 daily incidence
    dailyInc_age2 = dailyRec(:,[1,8]);  % 
    dailyInc_age3 = dailyRec(:,[1,9]);  


    % convolution1.0-A_onset
    % A_onset
    dailyOnset = zeros(length(dailyInc)+length(pdfIncubation)-1,length(dailyInc(1,:))-1);
    for iiDay = 1:length(dailyInc(:,1)) 
        for iiAge = 1:(length(dailyInc(1,:))-1)  
            dailyOnset(iiDay:(iiDay+length(pdfIncubation)-1),iiAge) = dailyOnset(iiDay:(iiDay+length(pdfIncubation)-1),iiAge)+...
                dailyInc(iiDay,iiAge+1)*pdfIncubation; 
        end
    end

dailyHospitalization_dh = zeros(length(dailyOnset)+length(pdf_gam_dh_hosp)-1,length(dailyOnset(1,:)));  
    for iiDay = 1:length(dailyOnset(:,1)) 
        for iiAge = 1:(length(dailyInc(1,:))-1)  
        dailyHospitalization_dh(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge) = dailyHospitalization_dh(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge)+...
                dailyOnset(iiDay,iiAge)*pdf_gam_dh_hosp;   
        
        end
    end 

dailyHospitalization_fc = zeros(length(dailyOnset)+length(pdf_gam_fc_hosp)-1,length(dailyOnset(1,:)));  
    for iiDay = 1:length(dailyOnset(:,1)) 
        for iiAge = 1:(length(dailyInc(1,:))-1)  
        dailyHospitalization_fc(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge) = dailyHospitalization_fc(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge)+...
                dailyOnset(iiDay,iiAge)*pdf_gam_fc_hosp;   
        end
    end 

dailyHospitalization_all = zeros(length(dailyOnset)+length(pdf_gam_all_hosp)-1,length(dailyOnset(1,:)));  
    for iiDay = 1:length(dailyOnset(:,1))
        for iiAge = 1:(length(dailyInc(1,:))-1)  
        dailyHospitalization_all(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge) = dailyHospitalization_all(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge)+...
                dailyOnset(iiDay,iiAge)*pdf_gam_all_hosp;   
        end
    end

    dailyOnset_age1 = zeros(length(dailyInc_age1)+length(pdfIncubation)-1,length(dailyInc_age1(1,:))-1); 
    for iiDay = 1:length(dailyInc_age1(:,1))  
        for iiAge = 1:(length(dailyInc_age1(1,:))-1)   
            dailyOnset_age1(iiDay:(iiDay+length(pdfIncubation)-1),iiAge) = dailyOnset_age1(iiDay:(iiDay+length(pdfIncubation)-1),iiAge)+...
                dailyInc_age1(iiDay,iiAge+1)*pdfIncubation;   
        end
    end

    
dailyHospitalization_dh_age1 = zeros(length(dailyOnset_age1)+length(pdf_gam_dh_hosp)-1,length(dailyOnset_age1(1,:)));  
    for iiDay = 1:length(dailyOnset_age1(:,1)) 
        for iiAge = 1:(length(dailyInc_age1(1,:))-1)  
        dailyHospitalization_dh_age1(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge) = dailyHospitalization_dh_age1(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge)+...
                dailyOnset_age1(iiDay,iiAge)*pdf_gam_dh_hosp;   
        
        end
    end 

dailyHospitalization_fc_age1 = zeros(length(dailyOnset_age1)+length(pdf_gam_fc_hosp)-1,length(dailyOnset_age1(1,:)));  
    for iiDay = 1:length(dailyOnset_age1(:,1))  
        for iiAge = 1:(length(dailyInc_age1(1,:))-1)  
        dailyHospitalization_fc_age1(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge) = dailyHospitalization_fc_age1(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge)+...
                dailyOnset_age1(iiDay,iiAge)*pdf_gam_fc_hosp;   
        end
    end 

dailyHospitalization_all_age1 = zeros(length(dailyOnset_age1)+length(pdf_gam_all_hosp)-1,length(dailyOnset_age1(1,:)));  
    for iiDay = 1:length(dailyOnset_age1(:,1))  
        for iiAge = 1:(length(dailyInc_age1(1,:))-1)  
        dailyHospitalization_all_age1(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge) = dailyHospitalization_all_age1(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge)+...
                dailyOnset_age1(iiDay,iiAge)*pdf_gam_all_hosp;   
        end
    end 

    dailyOnset_age2 = zeros(length(dailyInc_age2)+length(pdfIncubation)-1,length(dailyInc_age2(1,:))-1); 
    for iiDay = 1:length(dailyInc_age2(:,1)) 
        for iiAge = 1:(length(dailyInc_age2(1,:))-1)   
            dailyOnset_age2(iiDay:(iiDay+length(pdfIncubation)-1),iiAge) = dailyOnset_age2(iiDay:(iiDay+length(pdfIncubation)-1),iiAge)+...
                dailyInc_age2(iiDay,iiAge+1)*pdfIncubation;   
        end
    end

dailyHospitalization_dh_age2 = zeros(length(dailyOnset_age2)+length(pdf_gam_dh_hosp)-1,length(dailyOnset_age2(1,:)));  
    for iiDay = 1:length(dailyOnset_age2(:,1)) 
        for iiAge = 1:(length(dailyInc_age2(1,:))-1)  
        dailyHospitalization_dh_age2(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge) = dailyHospitalization_dh_age2(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge)+...
                dailyOnset_age2(iiDay,iiAge)*pdf_gam_dh_hosp;   
        
        end
    end 

dailyHospitalization_fc_age2 = zeros(length(dailyOnset_age2)+length(pdf_gam_fc_hosp)-1,length(dailyOnset_age2(1,:)));  
    for iiDay = 1:length(dailyOnset_age2(:,1))  
        for iiAge = 1:(length(dailyInc_age2(1,:))-1)  
        dailyHospitalization_fc_age2(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge) = dailyHospitalization_fc_age2(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge)+...
                dailyOnset_age2(iiDay,iiAge)*pdf_gam_fc_hosp;   
        end
    end 

dailyHospitalization_all_age2 = zeros(length(dailyOnset_age2)+length(pdf_gam_all_hosp)-1,length(dailyOnset_age2(1,:)));  
    for iiDay = 1:length(dailyOnset_age2(:,1))  
        for iiAge = 1:(length(dailyInc_age2(1,:))-1)  
        dailyHospitalization_all_age2(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge) = dailyHospitalization_all_age2(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge)+...
                dailyOnset_age2(iiDay,iiAge)*pdf_gam_all_hosp;   
        end
    end 

    dailyOnset_age3 = zeros(length(dailyInc_age3)+length(pdfIncubation)-1,length(dailyInc_age3(1,:))-1); 
    for iiDay = 1:length(dailyInc_age3(:,1)) 
        for iiAge = 1:(length(dailyInc_age3(1,:))-1)   
            dailyOnset_age3(iiDay:(iiDay+length(pdfIncubation)-1),iiAge) = dailyOnset_age3(iiDay:(iiDay+length(pdfIncubation)-1),iiAge)+...
                dailyInc_age3(iiDay,iiAge+1)*pdfIncubation;   
        end
    end

dailyHospitalization_dh_age3 = zeros(length(dailyOnset_age3)+length(pdf_gam_dh_hosp)-1,length(dailyOnset_age3(1,:)));  
    for iiDay = 1:length(dailyOnset_age3(:,1)) 
        for iiAge = 1:(length(dailyInc_age3(1,:))-1)  
        dailyHospitalization_dh_age3(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge) = dailyHospitalization_dh_age3(iiDay:(iiDay+length(pdf_gam_dh_hosp)-1),iiAge)+...
                dailyOnset_age3(iiDay,iiAge)*pdf_gam_dh_hosp;   
        
        end
    end 

dailyHospitalization_fc_age3 = zeros(length(dailyOnset_age3)+length(pdf_gam_fc_hosp)-1,length(dailyOnset_age3(1,:)));  
    for iiDay = 1:length(dailyOnset_age3(:,1))  
        for iiAge = 1:(length(dailyInc_age3(1,:))-1)  
        dailyHospitalization_fc_age3(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge) = dailyHospitalization_fc_age3(iiDay:(iiDay+length(pdf_gam_fc_hosp)-1),iiAge)+...
                dailyOnset_age3(iiDay,iiAge)*pdf_gam_fc_hosp;   
        end
    end 


dailyHospitalization_all_age3 = zeros(length(dailyOnset_age3)+length(pdf_gam_all_hosp)-1,length(dailyOnset_age3(1,:)));  
    for iiDay = 1:length(dailyOnset_age3(:,1))  
        for iiAge = 1:(length(dailyInc_age3(1,:))-1)  
        dailyHospitalization_all_age3(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge) = dailyHospitalization_all_age3(iiDay:(iiDay+length(pdf_gam_all_hosp)-1),iiAge)+...
                dailyOnset_age3(iiDay,iiAge)*pdf_gam_all_hosp;   
        end
    end 

% Incidence: Poisson likelihood
    obsOnset = sum(dailyOnset,2);  
    obsOnset = [(dailyInc(1)-1+(1:(length(obsOnset))))',obsOnset];  
    obsOnset = obsOnset(tStart:tEnd,:);  


    obsOnset1use = obsOnset(ismember(obsOnset(:,1),dataBeijing.date(~isnan(dataBeijing.num_local_case))),:);  

    onsetData1use = [dataBeijing.num_local_case(ismember(dataBeijing.date,obsOnset1use(:,1))),obsOnset1use(:,2)];

    onsetLogL(iiWave) = sum(log(binopdf(onsetData1use(:,1),round(onsetData1use(:,2)),propReport)));



% L_direct hosp_age1
modeldailyHospitalization_dh_age1 = pSZHdh_age1*sum(dailyHospitalization_dh_age1,2); 

modeldailyHospitalization_dh_age1 = [(dailyInc_age1(1)-1+(1:(length(modeldailyHospitalization_dh_age1))))',modeldailyHospitalization_dh_age1];  
modeldailyHospitalization_dh_age1 = modeldailyHospitalization_dh_age1(tStart:tEnd,:); 

modeldailyHospi1use_dh_age1 = modeldailyHospitalization_dh_age1(ismember(modeldailyHospitalization_dh_age1(:,1),hospitalizationHKUSZH_dh.date(~isnan(hospitalizationHKUSZH_dh.dh_age0to18))),:); 
hospidata1use_dh_age1 = [hospitalizationHKUSZH_dh.dh_age0to18(ismember(hospitalizationHKUSZH_dh.date,modeldailyHospi1use_dh_age1(:,1))),modeldailyHospi1use_dh_age1(:,2)];
dailyHospiLogL_dh_age1(iiWave) = sum(log(binopdf(hospidata1use_dh_age1(:,1),round(hospidata1use_dh_age1(:,2)),pSZHdh_age1)));  

dailyHospiLogL_dh_age1_Poisson(iiWave) = sum(log(poisspdf(hospidata1use_dh_age1(:,1),round(hospidata1use_dh_age1(:,2)))));


% L_from fever hosp_age1
modeldailyHospitalization_fc_age1 = pSZHfc_age1*sum(dailyHospitalization_fc_age1,2);  
modeldailyHospitalization_fc_age1 = [(dailyInc_age1(1)-1+(1:(length(modeldailyHospitalization_fc_age1))))',modeldailyHospitalization_fc_age1];  
modeldailyHospitalization_fc_age1 = modeldailyHospitalization_fc_age1(tStart:tEnd,:); 

modeldailyHospi1use_fc_age1 = modeldailyHospitalization_fc_age1(ismember(modeldailyHospitalization_fc_age1(:,1),hospitalizationHKUSZH_fc.date(~isnan(hospitalizationHKUSZH_fc.fc_age0to18))),:); 
hospidata1use_fc_age1 = [hospitalizationHKUSZH_fc.fc_age0to18(ismember(hospitalizationHKUSZH_fc.date,modeldailyHospi1use_fc_age1(:,1))),modeldailyHospi1use_fc_age1(:,2)];
dailyHospiLogL_fc_age1(iiWave) = sum(log(binopdf(hospidata1use_fc_age1(:,1),round(hospidata1use_fc_age1(:,2)),pSZHfc_age1)));  

dailyHospiLogL_fc_age1_Poisson(iiWave) = sum(log(poisspdf(hospidata1use_fc_age1(:,1),round(hospidata1use_fc_age1(:,2)))));


 Onset_age1 = sum(dailyHospitalization_all_age1,2);  
 Onset_age1 = [(dailyInc(1)-1+(1:(length(Onset_age1))))',Onset_age1];  
modeldailyHospuse_dh_age1 = Onset_age1(ismember(Onset_age1(:,1),hospitalizationHKUSZH_dh.date(~isnan(hospitalizationHKUSZH_dh.dh_age0to18))),:); 
hospidata1use0504_dh_age1 = [hospitalizationHKUSZH_dh.dh_age0to18(ismember(hospitalizationHKUSZH_dh.date,modeldailyHospuse_dh_age1(:,1))),modeldailyHospuse_dh_age1(:,2)];
hospidata1use0504_dh_age1 = round(hospidata1use0504_dh_age1);

X_multi3_age1 = [hospidata1use_dh_age1(:,1),hospidata1use_fc_age1(:,1),hospidata1use0504_dh_age1(:,2) - hospidata1use_dh_age1(:,1) - hospidata1use_fc_age1(:,1)];  
X_multi3_age1(X_multi3_age1 == 0) = 1; 
prob_multi3_age1 = [pSZHdh_age1,pSZHfc_age1,1-pSZHdh_age1-pSZHfc_age1]; 
dailyHospiLogL_multi3_age1(iiWave) = sum(log(mnpdf(X_multi3_age1,prob_multi3_age1)));


% L_direct hosp_age2。
modeldailyHospitalization_dh_age2 = pSZHdh_age2*sum(dailyHospitalization_dh_age2,2);  
modeldailyHospitalization_dh_age2 = [(dailyInc_age2(1)-1+(1:(length(modeldailyHospitalization_dh_age2))))',modeldailyHospitalization_dh_age2];  
modeldailyHospitalization_dh_age2 = modeldailyHospitalization_dh_age2(tStart:tEnd,:); 

modeldailyHospi1use_dh_age2 = modeldailyHospitalization_dh_age2(ismember(modeldailyHospitalization_dh_age2(:,1),hospitalizationHKUSZH_dh.date(~isnan(hospitalizationHKUSZH_dh.dh_age19to58))),:); 
hospidata1use_dh_age2 = [hospitalizationHKUSZH_dh.dh_age19to58(ismember(hospitalizationHKUSZH_dh.date,modeldailyHospi1use_dh_age2(:,1))),modeldailyHospi1use_dh_age2(:,2)];
dailyHospiLogL_dh_age2(iiWave) = sum(log(binopdf(hospidata1use_dh_age2(:,1),round(hospidata1use_dh_age2(:,2)),pSZHdh_age2)));  

dailyHospiLogL_dh_age2_Poisson(iiWave) = sum(log(poisspdf(hospidata1use_dh_age2(:,1),round(hospidata1use_dh_age2(:,2)))));

% L_from fever hosp_age2
modeldailyHospitalization_fc_age2 = pSZHfc_age2*sum(dailyHospitalization_fc_age2,2);  
modeldailyHospitalization_fc_age2 = [(dailyInc_age2(1)-1+(1:(length(modeldailyHospitalization_fc_age2))))',modeldailyHospitalization_fc_age2];  
modeldailyHospitalization_fc_age2 = modeldailyHospitalization_fc_age2(tStart:tEnd,:); 

modeldailyHospi1use_fc_age2 = modeldailyHospitalization_fc_age2(ismember(modeldailyHospitalization_fc_age2(:,1),hospitalizationHKUSZH_fc.date(~isnan(hospitalizationHKUSZH_fc.fc_age19to58))),:); 
hospidata1use_fc_age2 = [hospitalizationHKUSZH_fc.fc_age19to58(ismember(hospitalizationHKUSZH_fc.date,modeldailyHospi1use_fc_age2(:,1))),modeldailyHospi1use_fc_age2(:,2)];
dailyHospiLogL_fc_age2(iiWave) = sum(log(binopdf(hospidata1use_fc_age2(:,1),round(hospidata1use_fc_age2(:,2)),pSZHfc_age2)));  

dailyHospiLogL_fc_age2_Poisson(iiWave) = sum(log(poisspdf(hospidata1use_fc_age2(:,1),round(hospidata1use_fc_age2(:,2)))));


 Onset_age2 = sum(dailyHospitalization_all_age2,2);  
 Onset_age2 = [(dailyInc(1)-1+(1:(length(Onset_age2))))',Onset_age2];  
modeldailyHospuse_dh_age2 = Onset_age2(ismember(Onset_age2(:,1),hospitalizationHKUSZH_dh.date(~isnan(hospitalizationHKUSZH_dh.dh_age19to58))),:); 
hospidata1use0504_dh_age2 = [hospitalizationHKUSZH_dh.dh_age19to58(ismember(hospitalizationHKUSZH_dh.date,modeldailyHospuse_dh_age2(:,1))),modeldailyHospuse_dh_age2(:,2)];
hospidata1use0504_dh_age2 = round(hospidata1use0504_dh_age2);


X_multi3_age2 = [hospidata1use_dh_age2(:,1),hospidata1use_fc_age2(:,1),hospidata1use0504_dh_age2(:,2)-hospidata1use_dh_age2(:,1)-hospidata1use_fc_age2(:,1)];  
X_multi3_age2(X_multi3_age2 == 0) = 1;  
prob_multi3_age2 = [pSZHdh_age2,pSZHfc_age2,1-pSZHdh_age2-pSZHfc_age2];  
dailyHospiLogL_multi3_age2(iiWave) = sum(log(mnpdf(X_multi3_age2,prob_multi3_age2)));

% L_direct hosp_age3
modeldailyHospitalization_dh_age3 = pSZHdh_age3*sum(dailyHospitalization_dh_age3,2);  
modeldailyHospitalization_dh_age3 = [(dailyInc_age3(1)-1+(1:(length(modeldailyHospitalization_dh_age3))))',modeldailyHospitalization_dh_age3];  
modeldailyHospitalization_dh_age3 = modeldailyHospitalization_dh_age3(tStart:tEnd,:); 

modeldailyHospi1use_dh_age3 = modeldailyHospitalization_dh_age3(ismember(modeldailyHospitalization_dh_age3(:,1),hospitalizationHKUSZH_dh.date(~isnan(hospitalizationHKUSZH_dh.dh_age59over))),:); 
hospidata1use_dh_age3 = [hospitalizationHKUSZH_dh.dh_age59over(ismember(hospitalizationHKUSZH_dh.date,modeldailyHospi1use_dh_age3(:,1))),modeldailyHospi1use_dh_age3(:,2)];
dailyHospiLogL_dh_age3(iiWave) = sum(log(binopdf(hospidata1use_dh_age3(:,1),round(hospidata1use_dh_age3(:,2)),pSZHdh_age3)));  

dailyHospiLogL_dh_age3_Poisson(iiWave) = sum(log(poisspdf(hospidata1use_dh_age3(:,1),round(hospidata1use_dh_age3(:,2)))));

% L_from fever hosp_age3
modeldailyHospitalization_fc_age3 = pSZHfc_age3*sum(dailyHospitalization_fc_age3,2);  
modeldailyHospitalization_fc_age3 = [(dailyInc_age3(1)-1+(1:(length(modeldailyHospitalization_fc_age3))))',modeldailyHospitalization_fc_age3];  
modeldailyHospitalization_fc_age3 = modeldailyHospitalization_fc_age3(tStart:tEnd,:); 

modeldailyHospi1use_fc_age3 = modeldailyHospitalization_fc_age3(ismember(modeldailyHospitalization_fc_age3(:,1),hospitalizationHKUSZH_fc.date(~isnan(hospitalizationHKUSZH_fc.fc_age59over))),:); 
hospidata1use_fc_age3 = [hospitalizationHKUSZH_fc.fc_age59over(ismember(hospitalizationHKUSZH_fc.date,modeldailyHospi1use_fc_age3(:,1))),modeldailyHospi1use_fc_age3(:,2)];
dailyHospiLogL_fc_age3(iiWave) = sum(log(binopdf(hospidata1use_fc_age3(:,1),round(hospidata1use_fc_age3(:,2)),pSZHfc_age3)));  

dailyHospiLogL_fc_age3_Poisson(iiWave) = sum(log(poisspdf(hospidata1use_fc_age3(:,1),round(hospidata1use_fc_age3(:,2)))));



 Onset_age3 = sum(dailyHospitalization_all_age3,2);   
 Onset_age3 = [(dailyInc(1)-1+(1:(length(Onset_age3))))',Onset_age3];  
modeldailyHospuse_dh_age3 = Onset_age3(ismember(Onset_age3(:,1),hospitalizationHKUSZH_dh.date(~isnan(hospitalizationHKUSZH_dh.dh_age59over))),:); 
hospidata1use0504_dh_age3 = [hospitalizationHKUSZH_dh.dh_age59over(ismember(hospitalizationHKUSZH_dh.date,modeldailyHospuse_dh_age3(:,1))),modeldailyHospuse_dh_age3(:,2)];
hospidata1use0504_dh_age3 = round(hospidata1use0504_dh_age3);

X_multi3_age3 = [hospidata1use_dh_age3(:,1),hospidata1use_fc_age3(:,1),hospidata1use0504_dh_age3(:,2)-hospidata1use_dh_age3(:,1)-hospidata1use_fc_age3(:,1)]; 
X_multi3_age3(X_multi3_age3 == 0) = 1;  
prob_multi3_age3 = [pSZHdh_age3,pSZHfc_age3,1-pSZHdh_age3-pSZHfc_age3]; 
dailyHospiLogL_multi3_age3(iiWave) = sum(log(mnpdf(X_multi3_age3,prob_multi3_age3)));


 % Prevalence: Binomial likelihood
  pSens = p_ac;
  prevaData = [prevData.no_ever_positive,prevData.no_participants,pSens*dailyCumInc(prevData.date,2)/sum(totalPopulation)];  
  prevalenceLogL = log(binopdf(prevData.no_ever_positive,prevData.no_participants,pSens*dailyCumInc(prevData.date,2)/sum(totalPopulation)));

end

onsetLogL(onsetLogL==-Inf) = -1e9;  
prevalenceLogL(prevalenceLogL==-Inf) = -1e9;
% hkuszh_hospi_onsetLogL(hkuszh_hospi_onsetLogL==-Inf) = -1e9; 
% dailyHospiLogL_dh(dailyHospiLogL_dh==-Inf) = -1e9;  
dailyHospiLogL_dh_age1(dailyHospiLogL_dh_age1==-Inf) = -1e9;  
dailyHospiLogL_dh_age2(dailyHospiLogL_dh_age2==-Inf) = -1e9;  
dailyHospiLogL_dh_age3(dailyHospiLogL_dh_age3==-Inf) = -1e9;  
logL_gam_dh_hosp(logL_gam_dh_hosp==-Inf) = -1e9; 

% dailyHospiLogL_fc(dailyHospiLogL_fc==-Inf) = -1e9;  
dailyHospiLogL_fc_age1(dailyHospiLogL_fc_age1==-Inf) = -1e9;  
dailyHospiLogL_fc_age2(dailyHospiLogL_fc_age2==-Inf) = -1e9;  
dailyHospiLogL_fc_age3(dailyHospiLogL_fc_age3==-Inf) = -1e9;  
logL_gam_fc_hosp(logL_gam_fc_hosp==-Inf) = -1e9; 

logL_gam_all_hosp(logL_gam_all_hosp==-Inf) = -1e9; 

dailyHospiLogL_multi3_age1(dailyHospiLogL_multi3_age1==-Inf) = -1e9;
dailyHospiLogL_multi3_age2(dailyHospiLogL_multi3_age2==-Inf) = -1e9;
dailyHospiLogL_multi3_age3(dailyHospiLogL_multi3_age3==-Inf) = -1e9;

dailyHospiLogL_dh_age1_Poisson(dailyHospiLogL_dh_age1_Poisson==-Inf) = -1e9;
dailyHospiLogL_fc_age1_Poisson(dailyHospiLogL_fc_age1_Poisson==-Inf) = -1e9;
dailyHospiLogL_dh_age2_Poisson(dailyHospiLogL_dh_age2_Poisson==-Inf) = -1e9;
dailyHospiLogL_fc_age2_Poisson(dailyHospiLogL_fc_age2_Poisson==-Inf) = -1e9;
dailyHospiLogL_dh_age3_Poisson(dailyHospiLogL_dh_age3_Poisson==-Inf) = -1e9;
dailyHospiLogL_fc_age3_Poisson(dailyHospiLogL_fc_age3_Poisson==-Inf) = -1e9;

totalLogL = exactGenTimeLogL+intervalGenTimeLogL+sum(sum(onsetLogL))+sum(sum(prevalenceLogL))+logL_gam_dh_hosp+logL_gam_fc_hosp+sum(sum(dailyHospiLogL_dh_age1_Poisson))+sum(sum(dailyHospiLogL_dh_age2_Poisson))+sum(sum(dailyHospiLogL_dh_age3_Poisson))+sum(sum(dailyHospiLogL_fc_age1_Poisson))+sum(sum(dailyHospiLogL_fc_age2_Poisson))+sum(sum(dailyHospiLogL_fc_age3_Poisson));


end

