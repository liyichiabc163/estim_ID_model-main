function totalPopulation = calcTotalPopulationArrOneYear(totalPop,ageDistributionOneyear,ageGroupDefRange)

ageDistrOneYear = totalPop*ageDistributionOneyear;
totalPopulation = zeros(1,(length(ageGroupDefRange)-1));

for ii = 1:(length(ageGroupDefRange)-1)
    if ageGroupDefRange(ii)<=0
        totalPopulation(ii) = sum(ageDistrOneYear(1:ageGroupDefRange(ii+1)));
    else
        totalPopulation(ii) = sum(ageDistrOneYear((ageGroupDefRange(ii)+1):ageGroupDefRange(ii+1)));
    end
end


end

