function [ scientists, qualityEvaluated ] = Evaluation( scientists, journal, qualityOfPaper, reviewersAttracted )
% Here the reviewer is adopting a role; of the reliable, unreliable and
% competitive. The probability to adopt a behaviour is determined by the
% journal's impact factor. Finally, the total and per reviewer time spent
% for evaluation of their peers work is calculated each time.

global competitiveProbability  impactFactorsReverse

help1 = competitiveProbability;
help2 = impactFactorsReverse;
externalReviewers = 2 + binornd(1,0.2,length(qualityOfPaper),1);
qualityEvaluated = zeros(length(qualityOfPaper),1);

parfor iPapers = 1:length(qualityOfPaper)
    if isnan(qualityOfPaper(iPapers))
        qualityEvaluated(iPapers) = 0;
        continue;
    end
    totalReviewers = reviewersAttracted(iPapers) + externalReviewers(iPapers);
    
    rTimeError = rand(totalReviewers,1);
    help3 = help1;
    rCompetitive = help3(journal(iPapers))';
    rCompetitiveHelp = rand(totalReviewers,1);
    
    errorFactor = zeros(totalReviewers,1);
    competitive = zeros(totalReviewers,1);
    
    %% Define error factor
    % Reviewing time error
    errorFactor(rTimeError <= 0.65) = 0.1;
    errorFactor(rTimeError > 0.65 & rTimeError <= 0.87) = 0.05;
    errorFactor(rTimeError > 0.87) = 0.01;
    
    % Journal error
    reverseIF = help2;
    errorFactor = errorFactor + 0.15.*reverseIF(journal(iPapers));  
    
    % Quality error
    errorFactor = errorFactor - 0.05.*qualityOfPaper(iPapers);
    
    % Competitive
    help = random('uniform',0.01,0.05,totalReviewers,1);
    competitive(rCompetitiveHelp >= rCompetitive) = help(rCompetitiveHelp >= rCompetitive);
    
    % Evaluation
    evaluationMean = qualityOfPaper(iPapers) - competitive';
    errorFactor(errorFactor < 0) = 0;
    evaluationSTD = qualityOfPaper(iPapers).*errorFactor';
    if (totalReviewers > 1)
        averageEvaluationFromComments = mean(random('normal',evaluationMean(1:end - 1), evaluationSTD(1:end - 1)));
        weight = 1 + 2*externalReviewers(iPapers);
        qualityEvaluated(iPapers) = (averageEvaluationFromComments + 2*externalReviewers(iPapers)*random('normal',evaluationMean(end), evaluationSTD(end)))./weight;
    elseif (totalReviewers == 1)
        qualityEvaluated(iPapers) = random('normal',evaluationMean, evaluationSTD);
    end

end

end