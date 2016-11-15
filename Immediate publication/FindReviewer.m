function [ reviewerSpentTime, scientists, countReviewers] = FindReviewer( scientists, journal, reviewerSpentTime )
% Selects a reviewer that is relevant to the journal's impact factor

global thirdReviewerProbability scientistsPopulation journalsPopulation ...
    timeSpent

% Normally two reviewers evaluate a paper, but in the case of disagreement
% a third reviewer is called to help with amother report. Here only one reviewer
% is used, in order to simplify the procedure, but the time he spent is
% calculated as if there were 2 or 3 reviewers. This serves the purpose of
% estimating the total time the reviewers spent in evaluating the work of
% their peers.
r = rand(length(journal));
numberOfReviewers( r <= thirdReviewerProbability) = 3;
numberOfReviewers( r >  thirdReviewerProbability) = 2;
countReviewers = 0;

% Storing and sorting the scientists to a different vector in a descending
% order of their scientific level
scientistsTemp = sortrows(scientists,4);
scientistsRanked = scientistsTemp(end:-1:1,:);

% Defines the ranking (in percentage) of the scientist with the lowest
% scientific level that the journal accepts to be a reviewer
quantile = 0.1*floor(10*journal/journalsPopulation) - 0.1;

% Finds the reviewer with the lowest and the highest
% scientific level that the journal will 
% call to evaluate the paper
minReviewer(quantile > 0)  = quantile(quantile > 0)*scientistsPopulation;
minReviewer(quantile <= 0) = 1;
maxReviewer(quantile > 0)  = (quantile(quantile > 0) + 0.1)*scientistsPopulation;
maxReviewer(quantile <= 0) = 0.1*scientistsPopulation;

%% Selection of the reviewers among all the possible candidates
for iJournals = 1:length(journal)
    reviewersIndexes = round(random('uniform',minReviewer(iJournals),maxReviewer(iJournals),1,numberOfReviewers(iJournals)));
    countReviewers = countReviewers + numberOfReviewers(iJournals);
    randomIndex = randi(length(timeSpent),length(reviewersIndexes),1);
    help = timeSpent(randomIndex)';
    reviewerSpentTime(reviewersIndexes(:)) = reviewerSpentTime(reviewersIndexes(:)) + help(:);
    
    % Update the reviewer's scientific level
    scientistsRanked(reviewersIndexes(:),4) = scientistsRanked(reviewersIndexes(:),4) + 0.001.*rand(length(reviewersIndexes(:)),1); 
    scientists(scientistsRanked(reviewersIndexes(:),1),:) = scientistsRanked(reviewersIndexes(:),:);
end

end

