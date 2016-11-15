if (mod(iTime,52) == 0)
    yearIndex = round(iTime/52);
    yearlyTimeSpentForReviewing(yearIndex) = sum(reviewingTime);
    finalDecisions = find(qualityOfPapers(1:numberOfPapers - 1,6) < 0);
    publishedPapers = find(mod(qualityOfPapers(finalDecisions,6),1) == 0);
    yearlyPublishedPapers(yearIndex) = length(publishedPapers);
end
