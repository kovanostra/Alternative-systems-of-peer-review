function [ resources, percentage, improvedQuality, journal, totalResourcesInvested ] = UpdateForResubmission( journals, resources, level, ...
    firstQuality, totalResourcesInvested, decision )
%% Will search for another journal based on the quality of the manuscript before aking corrections

% Finds in which journal to submit the paper
reduction = firstQuality.*0.22;


[ journal ] = WhereToSubmit( journals, firstQuality - reduction, 0.50 );

%% Update the quality of the paper because of the reviewers' comments
if (decision ~= 2)
    timeSpentToUpdateThePaper = random('normal',10,1,length(resources),1);
    extraResourcesUsed = totalResourcesInvested' + (timeSpentToUpdateThePaper./12).*0.4.*...
        (resources - totalResourcesInvested');

    [ improvedQuality ] = QualityCalculation( level', extraResourcesUsed, 1 );

    percentage = (improvedQuality' - firstQuality)./firstQuality;
    totalResourcesInvested = extraResourcesUsed;
else
    timeSpentToUpdateThePaper = random('normal',1,0.1,length(resources),1);
    extraResourcesUsed = totalResourcesInvested' + (timeSpentToUpdateThePaper./12).*0.2.*...
        (resources - totalResourcesInvested');

    [ improvedQuality ] = QualityCalculation( level', extraResourcesUsed, 1 );

    percentage = (improvedQuality' - firstQuality)./firstQuality;
    totalResourcesInvested = extraResourcesUsed;
end

end