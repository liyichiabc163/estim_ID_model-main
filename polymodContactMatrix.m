function [adOutputContactMatrix,AgeDistribution] = polymodContactMatrix(ageGroupDefRange,socialContactOneyear,ageDistributionOneyear,totalPopulation)

% Input parameters
% 1. Contact matrix 1-year interval
% 2. Population age distribution of that specific country
% 3. Total population of that specific country



% 1. Reformat contact matrix description array
% start year - end year - interval in between
for ii = 1:(length(ageGroupDefRange)-1)     
    descriptionArray(ii,:) = [ii,max(ageGroupDefRange(ii)+1,0),ageGroupDefRange(ii+1)-max(ageGroupDefRange(ii)+1,0)];   
   
end


% 2. Output matrix
outputContactMatrix = zeros(max(descriptionArray(:,1)),max(descriptionArray(:,1)));  
for ii = 1:max(descriptionArray(:,1))% contact
    for jj = 1:max(descriptionArray(:,1))% participant        
        sumContact = 0;
        % Find related contact matrix
        workingMatrix = socialContactOneyear((descriptionArray(ii,2)+1):(descriptionArray(ii,2)+descriptionArray(ii,3)+1),(descriptionArray(jj,2)+1):(descriptionArray(jj,2)+descriptionArray(jj,3)+1));       
        % Sum the matrix by column (by participant)
        sumColumnMatrix = zeros(1,(descriptionArray(jj,3)+1));        
        for kk = 1:(descriptionArray(jj,3)+1)
            sumColumnMatrix(kk) = sum(workingMatrix(:,kk));
        end
        % Sum the age distribution of this group
        sumAgeDistributionOneyear = sum(ageDistributionOneyear(descriptionArray(jj,2)+1:(descriptionArray(jj,2)+descriptionArray(jj,3)+1)));
        % Sum: sumColumnMatrix*ageDistribution
        for mm = 1:(descriptionArray(jj,3)+1)
            sumContact = sumContact+sumColumnMatrix(mm)*ageDistributionOneyear(descriptionArray(jj,2)+mm);
        end
        % output
        outputContactMatrix(ii,jj) = sumContact/sumAgeDistributionOneyear;
    end
end
 

% 5. Adjusted contact matrix, symmetric
AgeDistribution = zeros(1,max(descriptionArray(:,1)));    
for ii = 1:max(descriptionArray(:,1))
    AgeDistribution(ii) = sum(ageDistributionOneyear(descriptionArray(ii,2)+1:(descriptionArray(ii,2)+descriptionArray(ii,3)+1)));   
    
end
AgeDisPopulation = AgeDistribution*totalPopulation;
adOutputContactMatrix = zeros(max(descriptionArray(:,1)));
for ii = 1:max(descriptionArray(:,1))
    for jj = 1:max(descriptionArray(:,1))
        adOutputContactMatrix(ii,jj) = 0.5*(outputContactMatrix(ii,jj)/AgeDisPopulation(ii)+outputContactMatrix(jj,ii)/AgeDisPopulation(jj));   
        
    end
end


end

