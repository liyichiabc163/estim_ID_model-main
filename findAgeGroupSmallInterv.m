function ageGroupIndex = findAgeGroupSmallInterv(ageVec,ageGroupDefRange)

ageGroupIndex = zeros(size(ageVec));

for ii = 1:length(ageVec)
    for jj = 1:(length(ageGroupDefRange)-1)
        if ageVec(ii) > ageGroupDefRange(jj) && ageVec(ii) <= ageGroupDefRange(jj+1)
            ageGroupIndex(ii) = jj;
            break;
        end
    end
end

end

