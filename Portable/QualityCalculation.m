function [ qualityOfPaper ] = QualityCalculation( scientistLevel, resourcesInvested, improvement )
% Calculation of the expected and the real quality of the
% paper. Afterwards this value is stored to a vector that 
% contains all the qualities of all the papers ever submitted

global  sclContributionToQuality authorBias resourcesContributionToQuality sclParameter resourcesParameter

% Calculates the contribution of the scientific level of the author in the
% quality of the paper
scientistLevelFactor = sclContributionToQuality*(sclParameter*scientistLevel)./(sclParameter*scientistLevel + 1);

% Calculates the contribution of the invested resources of the author in the
% quality of the paper
resourcesFactor = resourcesContributionToQuality*(resourcesParameter*resourcesInvested)./(resourcesParameter*resourcesInvested + 1);

% Calculates the estimated quality of the paper
expectedQualityOfPaper = scientistLevelFactor + resourcesFactor';
expectedQualityOfPaper(expectedQualityOfPaper < 0) = 0;
                
% Finds what is the actual quality of the paper by sampling it from a
% normal distribution. Also stores the quality of every submitted paper in
% a relevant vector
if (improvement == 0)
    % First submission
    qualityOfPaper = random('normal',expectedQualityOfPaper,expectedQualityOfPaper*authorBias);
elseif (improvement == 1)
    % Second round of review
    improvementBias = authorBias*1;
    qualityOfPaper = random('normal',expectedQualityOfPaper,expectedQualityOfPaper*improvementBias);
elseif (improvement == 2)
    % Resubmission
    resubmissionBias = authorBias*1;
    qualityOfPaper = random('normal',expectedQualityOfPaper,expectedQualityOfPaper*resubmissionBias);
end

end