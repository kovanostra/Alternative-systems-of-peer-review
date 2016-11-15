% Here the journal based on the evaluation that the referees submit defines
% whether the paper gets accepted or not. There is also an 80% probability
% that the paper gets rejected by the editor if it does not fullfil the
% journal's requirements.
global noEditorialScreening


% The specific journal that the paper is submitted 
journal = papers.journal;

% Fix paper's quality if there has been an improvement
[ finalQuality ] = Index( papers, resubmissionProbability );

decision.reviewer = zeros(length(finalQuality),1);
decision.joint = zeros(length(finalQuality),1);
qualityEvaluated  = zeros(length(finalQuality),1);

% Editorial phase
r1 = random('uniform',0.00,0.40,length(finalQuality),1);
r2 = random('uniform',0.90.*finalQuality',1.10.*finalQuality');
r3 = random('uniform',0.999,1.100,length(journal),1).*journals(journal,3);
editorialRejection = (r2 < r3) & (r1 < journal./105);
for iNoScreening = 1:length(journal)
    if (isempty(find(journal(iNoScreening) == noEditorialScreening, 1)) == 0)
        editorialRejection(iNoScreening) = 0;
    end
end

% First round of reviews
firstRound = (editorialRejection == 0) & (resubmissionProbability > 0);

% Reviewer evaluates the paper's quality
[ scientists, qualityEvaluated(firstRound == 1) ] = Evaluation( scientists, journal(firstRound == 1), finalQuality(firstRound == 1) );

%% Accepted papers
for i = 1:length(decision.reviewer)
    if(qualityEvaluated(i) >= journals(journal(i),4)) && (decision.reviewer(i) == 0)
        decision.reviewer(i) = 1;
    end
end


% Updating the quality of the papers due to the reviews
[ authors.resources(firstRound == 1), papers.percentage(firstRound == 1), papers.improvedQuality(firstRound == 1), ... 
    totalResourcesInvested(firstRound == 1) ] = UpdateOfQuality( authors.resources(firstRound == 1), ...
    authors.level(firstRound == 1), papers.firstQuality(firstRound == 1), totalResourcesInvested(firstRound == 1));       


%% Editorial assessment
for i = 1:length(decision.reviewer)
    if(firstRound(i) == 1) && (decision.reviewer(i) == 0)
        assessment = random('uniform', 0.9*papers.improvedQuality(i), 1.1*papers.improvedQuality(i));
        if assessment >= journals(journal(i),4)
            decision.reviewer(i) = 1;
        end
    end
end


decision.joint(firstRound == 1) = decision.reviewer(firstRound == 1);
decision.joint(editorialRejection == 1 & (resubmissionProbability > 0)) = 2;