function [ finalQuality ] = Index( papers, resubmissionProbability )

% Fix paper's quality if there is an improvement
improvedQuality = papers.improvedQuality;
firstQuality = papers.firstQuality;
parfor iIndex = 1:length(resubmissionProbability)
    if (improvedQuality(iIndex) == 0)
        finalQuality(iIndex) = firstQuality(iIndex);
    else
        finalQuality(iIndex) = improvedQuality(iIndex);
    end
end

end

