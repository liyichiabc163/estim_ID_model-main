function out = negTotalLogLikelihood(x0,...
    dataBeijing,genTimeData,prevData,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,hospitalizationHKUSZH_fc)


scaleRt = x0(1:2);
genTime = x0(3);
seedSize = x0(4);
propReport = x0(5);
p_ac = x0(6);
a_dh = x0(7);
b_dh = x0(8);
a_fc = x0(9);
b_fc = x0(10);


pSZHdh_age1 = x0(11);
pSZHdh_age2 = x0(12);
pSZHdh_age3 = x0(13);
pSZHfc_age1 = x0(14);
pSZHfc_age2 = x0(15);
pSZHfc_age3 = x0(16);

                             pH_HKUSZH_dh = 0;
                             pH_HKUSZH_fc = 0;
                             a_all = 0.92;  %dont change
                             b_all = 0.75;  %dont change


totalLogL = totalLogLikelihood(dataBeijing,genTimeData,prevData,...
    scaleRt,genTime,seedSize,propReport,...
    contactMatr,childSuscept,totalPopulation,durExposed,...
    numEstate,numIstate,dt,tStart,tEnd,dateChange,pdfIncubation,sa,sag1,datahkuszh1hospi,pH_HKUSZH_dh,p_ac,pdfOHP_HKUSZH,hospitalizationHKUSZH_dh,a_dh,b_dh,a_fc,b_fc,a_all,b_all,hospitalizationHKUSZH_fc,pH_HKUSZH_fc,pSZHdh_age1,pSZHdh_age2,pSZHdh_age3,pSZHfc_age1,pSZHfc_age2,pSZHfc_age3);

out = -totalLogL;

end

