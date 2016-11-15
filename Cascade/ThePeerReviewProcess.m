[ authors, papers ] = Decompose( scientists, author, qualityOfPapers, weekRange );
firstUpdate = 1;
decision.lastEvaluation = zeros(length(resubmissionProbability),1);
cascade = zeros(length(resubmissionProbability),1);
resubmitAfterCascade = zeros(length(resubmissionProbability),1);

while (sum(resubmissionProbability) ~= 0.0) 

    % Acceptance or rejection of the paper based on the previous
    % evaluation
    AcceptanceOrRejection

    if ( firstUpdate == 1 )
        newJournals = find(isnan(journalsToUpdate(:,2)) == 1);
        journalsToUpdate(newJournals(1):end,3) = 0;
        journalsToUpdate(newJournals(1):end,4) = decision.joint;
        resubmissionProbability(decision.reviewer == 1) = 0;
        firstUpdate = 0;
    end
    
    % Here there is either a decision about resubmission of the
    % manuscript or for its acceptance/rejecion. Then update of
    % the scientists and the journals takes place
    ResubmissionOrDecision           

end

% Calculate the time that the paper will be published and whether this
% is a right decision or not
[ ~, papers.publish, journalsToUpdate ] = WhenToPublish( decision, papers, journalsToUpdate );
index = find(publishTime == 0);
start = index(1);
finish = start + length(papers.publish);
publishTime(start:finish - 1) = papers.publish;

[ scientists, qualityOfPapers ] = Recompose( scientists, authors, author, qualityOfPapers, papers, weekRange );
