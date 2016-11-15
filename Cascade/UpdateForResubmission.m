function [ resources, percentage, improvedQuality, journal, totalResourcesInvested, cascade ] = UpdateForResubmission( journals, journal, resources, level, ...
    firstQuality, totalResourcesInvested, decision, cascade, networks )
%% Will search for another journal based on the quality of the manuscript before aking corrections

% Finds in which journal to submit the paper
if cascade == 0
    reduction = firstQuality.*0.22;
    [ journal ] = WhereToSubmit( journals, firstQuality - reduction, 0.50 );
    cascade = 0;
elseif cascade == 1
    ntwrk = journals(journal,10);
    indx = find(networks{ntwrk} == journal);
    newJournalIndx = randi(5);
    if (indx + newJournalIndx < length(networks{ntwrk}))
        journal = networks{ntwrk}(indx + newJournalIndx);
    else
        journal = networks{ntwrk}(end);
    end
end

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