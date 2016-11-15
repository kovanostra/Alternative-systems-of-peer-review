% The submission process for each one of the scientists that send their work for publication
weeklyAuthors = 850;
weeklySubmissions = round(random('normal',weeklyAuthors,0.1.*weeklyAuthors)); 

% Low and high thresholds change in accordance to the expected quality of publications
% if ( mod(iTime,weeksInAYear) == 0 )
%     thresholds = sort(random('beta',2.8927,10.0237,length(journals),1),'descend') + 0.3.*random('beta',2.8927,10.0237,length(journals),1);
%     journals(:,3) = 1.00 - 0.80.*thresholds;
%     journals(:,4) = 1.30 - 0.90.*thresholds;
% end 
[ journals ] = QualityToThreshold( scientists, journals, time, weeksInAYear );

% Finds who is the author and the amount of the resources he spends in order to submit his work
[ author, scientistLevel, totalResourcesInvested ] = DefineAuthorAndResourcesToSpend( scientists, weeklySubmissions );
weekRange = numberOfPapers:numberOfPapers + length(author) - 1;

% Store the author of each manuscript
qualityOfPapers(weekRange,7) = author;

% Subtract the invested resources
scientists(author,2) = scientists(author,2) - totalResourcesInvested';

% Calculation of the expected and the real quality of the paper. Afterwards this value is stored to a vector that 
% contains all the qualities of all the papers ever submitted
[ qualityOfPapers(weekRange,1) ] = QualityCalculation( scientistLevel, totalResourcesInvested, 0 );

% Finds in which journal to submit the paper
scientistTargeting = 1 - scientistLevel/sum(scientists(:,4));
scientistTargeting = 0.21;
[ qualityOfPapers(weekRange,5) ] = WhereToSubmit( journals, qualityOfPapers(weekRange,1), scientistTargeting );

% Variable that helps identify papers, journals and scientists
currentLength = length(journalsToUpdate) + 1;
futureLength = currentLength + length(weekRange) - 1;

journalsToUpdate(currentLength:futureLength,1) = qualityOfPapers(weekRange,5);  % Journal to update
journalsToUpdate(currentLength:futureLength,2) = NaN;                           % Time step to update
journalsToUpdate(currentLength:futureLength,3) = 0;                             % Submission attempts until this point
journalsToUpdate(currentLength:futureLength,4) = NaN;                           % Accepted or rejected
journalsToUpdate(currentLength:futureLength,5) = author;                        % Authors
journalsToUpdate(currentLength:futureLength,6) = qualityOfPapers(weekRange,5);  % Previous submission

% Store the initial amount of resources used for the paper and also its author
resourcesCounter(weekRange,1) = totalResourcesInvested;
resourcesCounter(weekRange,5) = author;

% This will check whether there will be resubmissions or not
resubmissionProbability = ones(length(weekRange),1);