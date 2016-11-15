function [ historyOfPapers, publish, journalsToUpdate ] = WhenToPublish( decision, papers, journalsToUpdate )


% Track a paper's history of resubmissions
newJournals = find(isnan(journalsToUpdate(:,2)) == 1);
historyProducedThisWeek = newJournals(1):length(journalsToUpdate);
historyOfPapers = cell(length(decision.reviewer));
resubmissionHistoryIndexes = cell(length(decision.reviewer));

for iHistory = 1:length(decision.reviewer)
    historyOfPapers{iHistory,1} = [ papers.firstQuality(iHistory) papers.improvedQuality(iHistory) papers.journal(iHistory) ...
        decision.reviewer(iHistory) papers.author(iHistory) ];
    resubmissionHistoryTemp = find(journalsToUpdate(historyProducedThisWeek,5) == papers.author(iHistory));
    resubmissionHistoryIndexes{iHistory} = newJournals(1) + resubmissionHistoryTemp - 1;
    % Flow Of resubmissions and the conditions of the decision + if it was
    % on second round or not
    for iFlow = 1:length(resubmissionHistoryIndexes{iHistory})
        historyOfPapers{iHistory,2}(iFlow,:) = [journalsToUpdate(resubmissionHistoryIndexes{iHistory}(iFlow),1) ...
            journalsToUpdate(resubmissionHistoryIndexes{iHistory}(iFlow),4)]; 
    end
end

% For the update of the acceptance rates, the scientific information and the scientists' values
publish = zeros(length(decision.reviewer),1);
for iPublish = 1:length(decision.reviewer)
    timeSpentForSubmissions = 0;
    journalHistoryTemp = resubmissionHistoryIndexes{iPublish};
    decisionHistoryTemp = historyOfPapers{iPublish,2}(:,2); 
    
    % Total time for the paper until finally accepted or indexed
    for iHistoryOfPaper = 1:length(decisionHistoryTemp)
        timeHelp = TimeEstimationPublication(decisionHistoryTemp(iHistoryOfPaper));
        journalsToUpdate(journalHistoryTemp(iHistoryOfPaper),2) = timeSpentForSubmissions + timeHelp;
    end
           
    % Finally accepted or indexed
    if (decisionHistoryTemp(end) == 0) || (decisionHistoryTemp(end) == 2) ||(decisionHistoryTemp(end) == 3)
        publish(iPublish) = journalsToUpdate(journalHistoryTemp(iHistoryOfPaper),2) + 0.5;
    elseif (decisionHistoryTemp(end) == 1) || (decisionHistoryTemp(end) == 4)
        publish(iPublish) = journalsToUpdate(journalHistoryTemp(iHistoryOfPaper),2) + round(random('uniform',4,8));
    end
end

    
end

