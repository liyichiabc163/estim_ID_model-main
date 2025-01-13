function [out,dymRtDaily] = SEIR_memory(scaleRt,...
    contactMatrHome,childSuscept,genTime,seedSize,...
    totalPopulation,durExposed,dataMTR,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,sa,sag1)

maxTime = (tEnd-tStart)+1;  

% SEIR model from Wu et al, PLOS Pathogens
numAgeGroup = length(totalPopulation);  
% Intermediate variables
dSdt = zeros(1,numAgeGroup);   
dEdt = zeros(numEstate,numAgeGroup);    
dIdt = zeros(numIstate,numAgeGroup); 
% Record variables
incidence = zeros(maxTime/dt,numAgeGroup); 
dailyprevalence =zeros(maxTime/dt,numAgeGroup);  
% Duration of sub-E and sub-I states
subEduration = durExposed/numEstate;  
durInfectious = 2*(genTime-durExposed)*numIstate/(numIstate+1);  
subIduration = durInfectious/numIstate;  

% Contact matrix
contactMatr = cell(1,maxTime);    
iiMobility = zeros(maxTime,1);  
ngmBeta = zeros(maxTime,1);  
for iiMatr = 1:maxTime
    if iiMatr <= length(dataMTR)   
        iiMobility(iiMatr,:) = repmat(dataMTR(iiMatr,1),1,1);  
    else
        iiMobility(iiMatr,:) = repmat(mean(dataMTR((end-6):end,1)),1,1);
    end
end   

iiMobility = movmean(iiMobility,5); 
contactMatrOct = cell(maxTime,1);  

for iiMatr = 1:maxTime
    if iiMatr <= dateChange-sag1    
        contactMatrOct{iiMatr} = (1-exp(-iiMobility(iiMatr,1)))*scaleRt(1)*contactMatrHome; 
       
    else
        if iiMatr > dateChange-sag1 &&  iiMatr <= dateChange+sa    
            iiScale = scaleRt(1)+(scaleRt(2)-scaleRt(1))/(sa+sag1)*(iiMatr-dateChange+sag1);  
            contactMatrOct{iiMatr} = (1-exp(-iiMobility(iiMatr,1)))*iiScale*contactMatrHome;
        else
            contactMatrOct{iiMatr} = (1-exp(-iiMobility(iiMatr,1)))*scaleRt(2)*contactMatrHome;  
        end
    end   

    contactMatr{iiMatr} = contactMatrOct{iiMatr}.*[...
        childSuscept,1,1;
        childSuscept,1,1;
        childSuscept,1,1;];   
    [~,ngmDig] = eig(contactMatr{iiMatr}.*repmat(totalPopulation',1,numAgeGroup)*genTime);   % 3*3
    ngmEig = ngmDig((1:numAgeGroup)+numAgeGroup*(0:(numAgeGroup-1)));  % 1*3 
    ngmBeta(iiMatr,1) = max(ngmEig);     
    contactMatr{iiMatr} = contactMatr{iiMatr}; 
    % recRt(iiMatr,1) = ngmBeta(iiMatr,1)*max(ngmEig);
 
end



% Initial conditions
% 1. State S
stateS = totalPopulation - seedSize/sum(totalPopulation)*totalPopulation;   %1*3 

% 2. State E
stateE = repmat(seedSize/numEstate/sum(totalPopulation)*totalPopulation,numEstate,1);    %1*3 

% 3. State I
stateI = zeros(numIstate,numAgeGroup);  % 4*3 

% dymRt_age = zeros(maxTime/dt,numAgeGroup);  % 760*3
for tt = 1:(maxTime/dt-1)    %  1-759
    tday = tt*dt;  
    contactMatrWork = contactMatr{ceil(tday)};    
    for ii = 1:numAgeGroup  
        dSdt(ii) = - stateS(ii)*ngmBeta(ceil(tday),1)*...
            sum(contactMatrWork(ii,:).*sum(stateI));   
    end
    
    % Exposed states
    for ii = 1:numEstate  
        if ii == 1
            dEdt(ii,:) = - sum(dSdt,1) - stateE(ii,:)/subEduration;     
        else
            dEdt(ii,:) = stateE(ii-1,:)/subEduration - stateE(ii,:)/subEduration;   
        end
    end
   

    % Infectious states
    for ii = 1:numIstate   
        if ii == 1  
            dIdt(ii,:) = stateE(end,:)/subEduration - stateI(ii,:)/subIduration;   
        else  
            dIdt(ii,:) =  stateI(ii-1,:)/subIduration -  stateI(ii,:)/subIduration;  
        end
    end
    
    % Update state variables
    stateS = stateS + dSdt*dt;  
    stateE = stateE + dEdt*dt;  
    stateI = stateI + dIdt*dt;  
    stateItotal = sum(stateI,1);      
    % Update incidence record
    incidence(tt,:) = -sum(dSdt,1)*dt; 
    dailyprevalence(tt,:) = stateItotal*dt;  
    dymRt(tt) = sum(incidence(tt,:),2)/sum(sum(stateI))*genTime/dt;  
    dymRt_age(tt,:) = incidence(tt,:)./sum(stateI)*genTime/dt;  
    
end

dymRtDaily = dymRt((1/dt/2):(1/dt):end)';  
dymRtDaily_age2 = dymRt_age((1/dt/2):(1/dt):end,:); 

dailyInc = zeros(maxTime,1); 
dailyPrev = zeros(maxTime,1); 

for tt = 1:maxTime    
    lyc6 = ((tt-1)/dt+(1:1/dt));
    dailyInc(tt,:) = sum(sum(incidence((tt-1)/dt+(1:1/dt),:)));  
    dailyInc_age(tt,:) = sum(incidence((tt-1)/dt+(1:1/dt),:));  
end
% testdailyInc_age_xiangjian = sum(dailyInc_age,2) - dailyInc;  % pass
dailyInc_age1 = dailyInc_age(:,1);
dailyInc_age2 = dailyInc_age(:,2);
dailyInc_age3 = dailyInc_age(:,3);   

for tt = 1:maxTime   
    dailyPrev(tt,:) = sum(sum(dailyprevalence((tt-1)/dt+(1:1/dt),:)));  
end

%%%% add onset
meanIncubation = 3.5;
stdIncubation = 3.9/5.2*meanIncubation;
shapeIncu = (stdIncubation*stdIncubation)/meanIncubation;
scaleIncu = meanIncubation/shapeIncu;
numDays = tEnd-tStart;
pdfIncubation = gamcdf(2:(numDays+1),shapeIncu,scaleIncu) - gamcdf(1:numDays,shapeIncu,scaleIncu); 
pdfIncubation = pdfIncubation(1:20)';
cdfIncubation = cumsum(pdfIncubation);
cdfIncubation(length(cdfIncubation)) = 1;

dailyIncSEIR = [(tStart:tEnd)',dailyInc];
dailyOnsetSEIR = zeros(length(dailyIncSEIR)+length(pdfIncubation)-1,length(dailyIncSEIR(1,:))-1); 
    for iiDay = 1:length(dailyIncSEIR(:,1)) 
        for iiAge = 1:(length(dailyIncSEIR(1,:))-1)   
            dailyOnsetSEIR(iiDay:(iiDay+length(pdfIncubation)-1),iiAge) = dailyOnsetSEIR(iiDay:(iiDay+length(pdfIncubation)-1),iiAge)+...
                dailyIncSEIR(iiDay,iiAge+1)*pdfIncubation;  
        end
    end   

dailyOnsetSEIR2 = zeros(length(dailyInc), 1);
for iiDay2 = 1:length(dailyOnsetSEIR2)
    dailyOnsetSEIR2(iiDay2) = dailyOnsetSEIR(iiDay2, 1);
end

%%%%%% add hospitalization
pdfOHP_HKUSZHseir = readtable('data\onset_to_hospi_inferred_try0320_change_7_14_for_newSEIRmcmc.csv'); 
pdfOHP_HKUSZHseir = table2array(pdfOHP_HKUSZHseir);
pdfOHP_HKUSZHseir = double(pdfOHP_HKUSZHseir); 

% step2 convolute the hospitalizations in the model
dailyHospitalizationSEIR = zeros(length(dailyOnsetSEIR)+length(pdfOHP_HKUSZHseir)-1,length(dailyOnsetSEIR(1,:)));  
    for iiDay = 1:length(dailyOnsetSEIR(:,1))  
        for iiAge = 1:(length(dailyIncSEIR(1,:))-1) 
        dailyHospitalizationSEIR(iiDay:(iiDay+length(pdfOHP_HKUSZHseir)-1),iiAge) = dailyHospitalizationSEIR(iiDay:(iiDay+length(pdfOHP_HKUSZHseir)-1),iiAge)+...
                dailyOnsetSEIR(iiDay,iiAge)*pdfOHP_HKUSZHseir;   
       
        end
    end 

dailyHospitalizationSEIR2 = zeros(length(dailyInc), 1);
for iiDay3 = 1:length(dailyHospitalizationSEIR2)
    dailyHospitalizationSEIR2(iiDay3) = dailyHospitalizationSEIR(iiDay3, 1);
end



% out = [(tStart:tEnd)',dailyInc,cumsum(dailyInc),dailyPrev];   
% out = [(tStart:tEnd)',dailyInc,cumsum(dailyInc),dailyPrev,dailyOnsetSEIR2]; 
out = [(tStart:tEnd)',dailyInc,cumsum(dailyInc),dailyPrev,dailyOnsetSEIR2,dailyHospitalizationSEIR2,dailyInc_age1,dailyInc_age2,dailyInc_age3]; 
end

