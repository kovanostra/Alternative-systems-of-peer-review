function [ scientists, qualityEvaluated ] = Evaluation( scientists, journal, qualityOfPaper )
% Here the reviewer is adopting a role; of the reliable, unreliable and
% competitive. The probability to adopt a behaviour is determined by the
% journal's impact factor. Finally, the total and per reviewer time spent
% for evaluation of their peers work is calculated each time.

global competitiveProbability  impactFactorsReverse
rTimeError = rand(length(qualityOfPaper),1);
rCompetitive = competitiveProbability(journal)';
rCompetitiveHelp = rand(length(qualityOfPaper),1);

errorFactor = zeros(length(qualityOfPaper),1);
competitive = zeros(length(qualityOfPaper),1);

%% Define error factor
% Reviewing time error
errorFactor(rTimeError <= 0.65) = 0.1;
errorFactor(rTimeError > 0.65 & rTimeError <= 0.87) = 0.05;
errorFactor(rTimeError > 0.87) = 0.01;

% Journal error
reverseIF = impactFactorsReverse;
errorFactor = errorFactor + 0.15.*reverseIF(journal);

% Quality error
errorFactor = errorFactor - 0.05.*qualityOfPaper';

% Competitive
help = random('uniform',0.01,0.05,length(qualityOfPaper),1);
competitive(rCompetitiveHelp >= rCompetitive) = help(rCompetitiveHelp >= rCompetitive);

% Evaluation
evaluationMean = qualityOfPaper - competitive';
errorFactor(errorFactor < 0) = 0;
size(errorFactor);
size(qualityOfPaper);
evaluationSTD = qualityOfPaper.*errorFactor';
qualityEvaluated = random('normal',evaluationMean, evaluationSTD)'; 

qualityEvaluated = qualityEvaluated';

end