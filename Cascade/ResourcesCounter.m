function [ resourcesCounter ] = ResourcesCounter( resourcesCounter, totalResourcesInvested, qualityOfPapers, weekRange)

% Resources related again
resourcesCounter(weekRange,2) = totalResourcesInvested;
resourcesCounter(weekRange,3) = (resourcesCounter(weekRange,2) - resourcesCounter(weekRange,1))./resourcesCounter(weekRange,2);
resourcesCounter(weekRange,4) = (resourcesCounter(weekRange,2) - resourcesCounter(weekRange,1))./(qualityOfPapers(weekRange,6));


end

