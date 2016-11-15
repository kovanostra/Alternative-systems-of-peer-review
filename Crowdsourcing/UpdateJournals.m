function [ scientists, journals, journalsToUpdate, reviewerSpentTime, totalScientificInformation, reviewsCounter ] = ...
    UpdateJournals( scientists, journals, journalsToUpdate, reviewerSpentTime, totalScientificInformation, reviewsCounter )

tempAccept = journalsToUpdate(:,2) == 0 & (journalsToUpdate(:,4) == 1 | journalsToUpdate(:,4) == 4);
accept = journalsToUpdate(tempAccept,1);
tempReject = journalsToUpdate(:,2) == 0 & (journalsToUpdate(:,4) == 0 | journalsToUpdate(:,4) == 2 | journalsToUpdate(:,4) == 3);
reject = journalsToUpdate(tempReject,6);
newSubmissionRej = journalsToUpdate(tempReject,1);
remainingSIRej = journalsToUpdate(tempReject,7);

tempEditor = journalsToUpdate(:,2) == 0 & journalsToUpdate(:,4) == 2;
rejectEditor = journalsToUpdate(tempEditor,6);
newSubmissionEdi = journalsToUpdate(tempReject,1);
remainingSIEdi = journalsToUpdate(tempReject,7);

% Condition for updating at acceptance
for iUpdate = 1:length(accept)
    journals(accept(iUpdate),5) = journals(accept(iUpdate),5) + 1;
end

% Condition for updating at rejection
for iUpdate = 1:length(reject)
    journals(reject(iUpdate),6) = journals(reject(iUpdate),6) + 1;
    if newSubmissionRej(iUpdate) ~= reject(iUpdate)
        totalScientificInformation = totalScientificInformation + remainingSIRej(iUpdate);
    end
end

for iUpdate = 1:length(rejectEditor)
    journals(rejectEditor(iUpdate),8) = journals(rejectEditor(iUpdate),8) + 1;
    if newSubmissionEdi(iUpdate) ~= reject(iUpdate)
        totalScientificInformation = totalScientificInformation + remainingSIEdi(iUpdate);
    end
end

journals(:,7) = journals(:,5)./(journals(:,5) + journals(:,6));            % Update the journal's acceptance rate
journals(:,9) = journals(:,8)./(journals(:,5) + journals(:,6));            % Update the journal's editorial rejection rate

% Time to peer review estimation
tempFirstRound = journalsToUpdate(:,2) == 0 & (journalsToUpdate(:,4) == 0 | journalsToUpdate(:,4) == 1);
journal = journalsToUpdate(tempFirstRound,6);
if (isempty(journal) == 0)
    % Find a reviewer of a scientific level that matches to the journal's impact factor
    [ reviewerSpentTime, scientists, countReviewers ] = FindReviewer( scientists, journal, reviewerSpentTime );
    reviewsCounter = reviewsCounter + countReviewers;
end

% A second round of reviews needed
tempSecondRound = journalsToUpdate(:,2) == 0 & (journalsToUpdate(:,4) == 3 | journalsToUpdate(:,4) == 4);
journal = journalsToUpdate(tempSecondRound,1);

if (isempty(journal) == 0)
    % Find a reviewer of a scientific level that matches to the journal's impact factor
    for i = 1:2
        [ reviewerSpentTime, scientists, countReviewers ] = FindReviewer( scientists, journal, reviewerSpentTime );
        reviewsCounter = reviewsCounter + countReviewers;
    end
end

delete = journalsToUpdate(:,2) == 0;
journalsToUpdate(delete,:) = [];

journalsToUpdate(:,2) = journalsToUpdate(:,2) - 1;
end

