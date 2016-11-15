% Here the journal based on the evaluation that the referees submit defines
% whether the paper gets accepted or not. There is also an 80% probability
% that the paper gets rejected by the editor if it does not fullfil the
% journal's requirements.
global noEditorialScreening


% The specific journal that the paper is submitted 
journal = papers.journal;

% Fix paper's quality if there has been an improvement
[ finalQuality ] = Index( papers, resubmissionProbability );

% The initial scientific information and the amount of reviewers attracted
initialScientificInformation = journals(journal,10).*finalQuality';
initialScientificInformation(resubmissionProbability == 0 | isnan(initialScientificInformation) == 1) = 0;
finalQuality(isnan(initialScientificInformation) == 1) = 0;

meanSI = mean(initialScientificInformation);
if meanSI < 0.05
    meanSI = 0.05;
end

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

%% Accepted immediately

for i = 1:length(decision.reviewer)
    if(qualityEvaluated(i) >= journals(journal(i),4)) && (decision.reviewer(i) == 0)
        decision.reviewer(i) = 1;
    end
end

%% Second round of reviews
secondRound = zeros(length(firstRound),1);

% Defining the papers that go to the second round of reviews
for k = 1:length(secondRound)
    if (firstRound(k) == 1) && (qualityEvaluated(k) >= r3(k)) && (decision.reviewer(k) == 0)
        secondRound(k) = 1;
    end
end

% Updating the quality of the papers due to the first round of reviews
[ authors.resources(secondRound == 1), papers.percentage(secondRound == 1), papers.improvedQuality(secondRound == 1), ... 
    totalResourcesInvested(secondRound == 1) ] = UpdateOfQuality( authors.resources(secondRound == 1), ...
    authors.level(secondRound == 1), papers.firstQuality(secondRound == 1), totalResourcesInvested(secondRound == 1));       

% Second evaluation of the papers
[ scientists, qualityEvaluated(secondRound == 1) ] = Evaluation( scientists, journal(secondRound == 1), ...
    papers.improvedQuality(secondRound == 1)');

% Accepted at the second round
for l = 1:length(decision.reviewer)
    if (qualityEvaluated(l) >= journals(papers.journal(l),4)) && secondRound(l) == 1
        decision.reviewer(l) = 1;
    end
end

decision.joint(secondRound == 1) = decision.reviewer(secondRound == 1) + 3;
decision.joint(secondRound == 0 & firstRound == 1) = decision.reviewer(secondRound == 0  & firstRound == 1);
decision.joint(editorialRejection == 1 & (resubmissionProbability > 0)) = 2;