function [ resources, percentage, improvedQuality, totalResourcesInvested ] = UpdateOfQuality( resources, level, firstQuality, totalResourcesInvested )

%% Update the quality of the paper because of the reviewers' comments

timeSpentToUpdateThePaper = random('normal',8,1,length(resources),1);
 
extraResourcesUsed = totalResourcesInvested' + (timeSpentToUpdateThePaper./12).*0.2.*...
    (resources - totalResourcesInvested');

[ improvedQuality ] = QualityCalculation( level', extraResourcesUsed, 1 );

percentage = (improvedQuality' - firstQuality)./firstQuality;
            
totalResourcesInvested = extraResourcesUsed;

end