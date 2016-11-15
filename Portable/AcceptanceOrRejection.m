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
lowThreshold = random('uniform',0.999,1.100,length(journal),1).*journals(journal,3);
editorialRejection = (r2 < lowThreshold) & (r1 < journal./105);
for iNoScreening = 1:length(journal)
    if (isempty(find(journal(iNoScreening) == noEditorialScreening, 1)) == 0) || (cascade(iNoScreening) == 1)
        editorialRejection(iNoScreening) = 0;
    end
end

% Compare last evaluation with the quality of the paper for cascade
% submissions
if (isempty(find(cascade == 1, 1)) == 0)
    editorialAssessment = random('uniform',0.90.*finalQuality',1.10.*finalQuality');
    possiblyNewReviews = zeros(length(cascade),1);
    indxs = find(decision.lastEvaluation~=0);
    
    possiblyNewReviews(indxs) = abs(editorialAssessment(indxs) - decision.lastEvaluation(indxs))./decision.lastEvaluation(indxs) > 0.10;
    
    factor = -rand(length(finalQuality),1) + rand(length(finalQuality),1).*(editorialAssessment - decision.lastEvaluation);
    probabilityOfNewReviews = (exp(factor))./(1 + exp(factor));
    randFactor = rand(length(finalQuality),1);
    
    newReviews = (possiblyNewReviews == 1); 

    firstRound = (editorialRejection == 0) & (resubmissionProbability > 0) & (newReviews == 1);
else
    % First round of reviews
    firstRound = (editorialRejection == 0) & (resubmissionProbability > 0);
end

%% Reviewer evaluates the paper's quality
[ scientists, qualityEvaluated(firstRound == 1) ] = Evaluation( scientists, journal(firstRound == 1), finalQuality(firstRound == 1) );


% Accepted immediately
secondRoundCascade = zeros(length(finalQuality),1);
indexes1 = zeros(length(finalQuality),1);
indexes2 = zeros(length(finalQuality),1);

for i = 1:length(cascade)
    highThreshold = journals(journal(i),4);
    if (cascade(i) == 1) && (editorialRejection(i) == 0)
        % Cascaded submissions
        acceptCascadedPaper = decision.lastEvaluation(i) >= highThreshold;
        
        if (acceptCascadedPaper == 1) 
            % Immediately accept cascaded paper without new reviews
            decision.reviewer(i) = 10; 
            indexes1(i) = i;
        elseif (acceptCascadedPaper == 0) && (newReviews(i) == 0)
            % Allow for revisions to match previous reviews
            [ authors.resources(i), papers.percentage(i), papers.improvedQuality(i), totalResourcesInvested(i) ] = ... 
                UpdateOfQuality( authors.resources(i), authors.level(i), papers.firstQuality(i), totalResourcesInvested(i));
            
            assessment = random('uniform', 0.9*papers.improvedQuality(i), 1.1*papers.improvedQuality(i));
            if assessment >= journals(journal(i),4)
                decision.reviewer(i) = 10;
                indexes1(i) = i;
            else
                decision.reviewer(i) = 0;
                resubmitAfterCascade(i) = resubmitAfterCascade(i) - 0.5;
                indexes2(i) = i;
            end

        elseif (acceptCascadedPaper == 0) && (newReviews(i) == 1)
            if (qualityEvaluated(i) >= highThreshold)
                 % Accepted with new reviews
                decision.reviewer(i) = 1;
            end
        end
    elseif (cascade(i) == 0) && (editorialRejection(i) == 0) && (resubmissionProbability(i) > 0)
        % No cascade
        if (qualityEvaluated(i) >= highThreshold)
            decision.reviewer(i) = 1; % Normal submission accepted
        end
    end
end


%% Second round of reviews
secondRound = zeros(length(firstRound),1);

% Defining the papers that go to the second round of reviews
for k = 1:length(secondRound)
    if (firstRound(k) == 1) && (qualityEvaluated(k) >= lowThreshold(k)) && (decision.reviewer(k) == 0)
        secondRound(k) = 1;
    end
end

% Updating the quality of the papers due to the first round of reviews
[ authors.resources(secondRound == 1), papers.percentage(secondRound == 1), papers.improvedQuality(secondRound == 1), ... 
    totalResourcesInvested(secondRound == 1) ] = UpdateOfQuality( authors.resources(secondRound == 1), ...
    authors.level(secondRound == 1), papers.firstQuality(secondRound == 1), totalResourcesInvested(secondRound == 1));       

% Second evaluation of the papers
[ scientists, qualityEvaluated(secondRound == 1) ] = Evaluation( scientists, papers.journal(secondRound == 1), ...
    papers.improvedQuality(secondRound == 1)' );

% Accepted at the second round
for l = 1:length(decision.reviewer)
    highThreshold = journals(papers.journal(l),4);
    if (qualityEvaluated(l) >= highThreshold) && secondRound(l) == 1
        decision.reviewer(l) = 1;
    end
end

indexes1(indexes1==0) = [];
indexes2(indexes2==0) = [];

decision.lastEvaluation = qualityEvaluated;
decision.lastEvaluation(resubmissionProbability == 0) = 0;
decision.joint(secondRound == 1) = decision.reviewer(secondRound == 1) + 3;
decision.joint(secondRound == 0 & firstRound == 1) = decision.reviewer(secondRound == 0  & firstRound == 1);
decision.joint(indexes1) = 10;
decision.joint(indexes2) = 2;
decision.joint(editorialRejection == 1 & (resubmissionProbability > 0)) = 2;
