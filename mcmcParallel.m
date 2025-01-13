function [iPar,iiLogL] = mcmcParallel(countryText,mcSteps,...
    dataBeijing,genTimeData,prevData,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,...
    parameters,parameterSteps,lowerLimit,upperLimit,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc)

goodMC = false;
pAccept = 0.5*ones(1,length(parameters));
numWhileLoop = 0;
numPars = length(parameters);

while goodMC == false
    numWhileLoop = numWhileLoop+1;
    iPar=zeros(mcSteps,numPars); 
    iiLogL=zeros(mcSteps,1);
    nAccept = zeros(1,numPars);
    parameterSteps(pAccept > 0.7) = parameterSteps(pAccept > 0.7)*1.2;
    parameterSteps(pAccept < 0.3) = parameterSteps(pAccept < 0.3)/1.25;
    parameterSteps = min([parameterSteps;upperLimit-lowerLimit]);
    % Current loglikelihood
    parameters_c = parameters;
    logLikelihood = calcMCMCTotalLogLikelihood(parameters_c,...
        dataBeijing,genTimeData,prevData,...
        contactMatr,childSuscept,totalPopulation,durExposed,...
        numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc);
    for tt = 1:mcSteps
        tempNew = mcmcProposal(parameters_c,parameterSteps,lowerLimit,upperLimit);
        for ii = 1:numPars
            parameters_mc = parameters_c;
            parameters_mc(ii) = tempNew(ii);
            logLikelihood_new = calcMCMCTotalLogLikelihood(parameters_mc,...
                dataBeijing,genTimeData,prevData,...
                contactMatr,childSuscept,totalPopulation,durExposed,...
                numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc);
            alpha = min(1,exp(logLikelihood_new-logLikelihood));
            uu = rand;
            if uu <= alpha
                parameters_c = parameters_mc;
                logLikelihood = logLikelihood_new;
                nAccept(ii) = nAccept(ii)+1;
            end
        end
        iiLogL(tt,:) = logLikelihood;
        iPar(tt,:) = parameters_c;
        % Check MCMC
        if mod(tt,mcSteps/100) == 0
            pAccept = nAccept/tt;
            write_matrix_new(parameterSteps,strcat('mcmc_result/',countryText,'_parameter_step.csv'),'w',',','dec');
            write_matrix_new(iPar,strcat('mcmc_result/',countryText,'_mcmc_res.csv'),'w',',','dec');
            write_matrix_new(iiLogL,strcat('mcmc_result/',countryText,'_log_likelihood.csv'),'w',',','dec');
            disp('MCMC');
            display(tt/mcSteps);
            disp('Acceptance probability');
            display(pAccept);
            if any(pAccept > 0.7) || any(pAccept < 0.3)
                goodMC = false;
                if numWhileLoop < 20
                    if tt/mcSteps >= 0.02
                       break;
                       % goodMC = true;
                    end
                else
                    goodMC = true;
                end
            else
                goodMC = true;
            end
        end     
    end
end

end



