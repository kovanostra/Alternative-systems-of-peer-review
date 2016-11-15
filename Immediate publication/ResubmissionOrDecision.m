% This function checks whether the paper is accepted or rejected. If it is
% rejected then there is a probability to be resubmitted to the same or to
% another journal. This probability gets lower and lower as the number of
% resubmission attempts increases.

r = rand(length(resubmissionProbability),1);

% The probability for a paper to be resubmitted
resubmitted = resubmissionProbability ~= 0;
resubmissionProbability(resubmitted) = (0.88).^(papers.resubmissions(resubmitted));
resubmission = (decision.reviewer == 0 & r <= resubmissionProbability);
unindexed = (r > resubmissionProbability & resubmissionProbability > 0);
accepted = (decision.reviewer == 1 & resubmissionProbability > 0);

%% Update the resubmission attempts
percentage = papers.percentage;
firstQuality = papers.firstQuality;
improvedQuality = papers.improvedQuality;
resubmissions = papers.resubmissions;
journal = papers.journal;
name = authors.name;
resources = authors.resources;
level = authors.level;
newJournals = find(isnan(journalsToUpdate(:,2)) == 1);

for iResubmission = 1:length(resubmissionProbability)

    if (resubmission(iResubmission) == 1)
        
        resubmissions(iResubmission) = resubmissions(iResubmission) + 1;
        lastJournal = journal(iResubmission);
        lastInitialSI = firstQuality(iResubmission)*journals(lastJournal,10);
        
        [ resources(iResubmission), percentage(iResubmission), improvedQuality(iResubmission), journal(iResubmission), ... 
            totalResourcesInvested(iResubmission) ] = UpdateForResubmission( journals, resources(iResubmission), ...
            level(iResubmission), firstQuality(iResubmission), totalResourcesInvested(iResubmission), decision.joint(iResubmission));   

        notUpdated0 = find(journalsToUpdate(newJournals(1):end,3) >= 1);
        rejectedAuthor = find(journalsToUpdate(notUpdated0:end,5) == name(iResubmission));
        if ( isempty(notUpdated0) == 0 && isempty(rejectedAuthor) == 0)
            journalsToUpdate(notUpdated0(1) + rejectedAuthor(end) - 1,4) = decision.joint(iResubmission);
        end

        newLength = length(journalsToUpdate) + 1;
        journalsToUpdate(newLength,1:6) = [ journal(iResubmission) NaN resubmissions(iResubmission) NaN name(iResubmission) lastJournal ];
        journalsToUpdate(newLength,7) = - lastInitialSI + improvedQuality(iResubmission)*journals(journal(iResubmission),10);
        
    elseif (unindexed(iResubmission) == 1)

        notUpdated1 = find(journalsToUpdate(newJournals(1):end,3) >= 1);
        rejectedAuthor = find(journalsToUpdate(notUpdated1:end,5) == name(iResubmission));
        journalsToUpdate(notUpdated1(1) + rejectedAuthor(end) - 1,4) = decision.joint(iResubmission);
        journalsToUpdate(notUpdated1(1) + rejectedAuthor(end) - 1,6) = journalsToUpdate(notUpdated1(1) + rejectedAuthor(end) - 1,1);

        % Those papers that will not be resubmitted
        resubmissionProbability(iResubmission) = 0;
    elseif (accepted(iResubmission) == 1)
        notUpdated2 = find(journalsToUpdate(newJournals(1):end,3) >= 1);
        acceptedAuthor = find(journalsToUpdate(notUpdated2:end,5) == name(iResubmission));

        journalsToUpdate(notUpdated2(1) + acceptedAuthor(end) - 1,4) = decision.joint(iResubmission);        

        % Those papers that will not be resubmitted
        resubmissionProbability(iResubmission) = 0;
    end
end

authors.resources = resources;
authors.level = level;
papers.firstQuality = firstQuality;
papers.improvedQuality = improvedQuality;
papers.percentage = percentage;
papers.resubmissions = resubmissions;
papers.journal= journal;