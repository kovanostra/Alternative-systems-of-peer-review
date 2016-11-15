%% Statistical fitting tests

X = zeros(length(journals(:,7)) + length(acceptanceRatesTotal),2);
X(1:length(journals(:,7)),1) = journals(:,7);
X(1:length(journals(:,7)),2) = 1;
X(length(journals(:,7)) + 1:end,1) = acceptanceRatesTotal;
X(length(journals(:,7)) + 1:end,2) = 2;
AnDarksamtest(X,0.05);

Y = zeros(length(journals(:,9)) + length(acceptanceRatesEditor),2);
Y(1:length(journals(:,9)),1) = journals(:,9);
Y(1:length(journals(:,9)),2) = 1;
Y(length(journals(:,9)) + 1:end,1) = acceptanceRatesEditor;
Y(length(journals(:,9)) + 1:end,2) = 2;
AnDarksamtest(Y,0.05);

%resubmissionsReal = [0.15,0.47,0.23,0.12,0.02,0.01,0.01];
resubmissionsReal = [0.146,0.469,0.226,0.117,0.024,0.005,0.006];
% theoreticalDistribution = makedist('Multinomial','Probabilities',resubmissionsReal);
% adtest(qualityOfPapers(1:numberOfPapers-1,4),'Distribution',theoreticalDistribution)

%% Some result outputs
finalDecisionsTemp = find(qualityOfPapers(1:numberOfPapers - 1,6) < 0);
finalDecisions = qualityOfPapers(finalDecisionsTemp,:);
publishedPapersTemp = find(mod(finalDecisions(:,6),1) == 0);
publishedPapers = finalDecisions(publishedPapersTemp,:);
unpublishedPapersTemp = find(mod(finalDecisions(:,6),1) ~= 0);
unpublishedPapers = finalDecisions(unpublishedPapersTemp,:);

% Comparisson of quality of published vs unpublished
qualityOfPublished = zeros(length(publishedPapers),1);
qualityOfUnpublished = zeros(length(unpublishedPapers),1);

for iPublished = 1:length(publishedPapers)
    if (publishedPapers(iPublished,2) ~= 0)
        qualityOfPublished(iPublished) = publishedPapers(iPublished,2);
    else
        qualityOfPublished(iPublished) = publishedPapers(iPublished,1);
    end
end

for iUnpublished = 1:length(unpublishedPapers)
    if (unpublishedPapers(iUnpublished,2) ~= 0)
        qualityOfUnpublished(iUnpublished) = unpublishedPapers(iUnpublished,2);
    else
        qualityOfUnpublished(iUnpublished) = unpublishedPapers(iUnpublished,1);
    end
end

% Quality depending on the amount of resubmissions for the published papers
maxResubmissions = max(publishedPapers(:,4));
qualityPerResubmission = cell(maxResubmissions);
meanQualityPerResubmission = zeros(maxResubmissions,2);
for iResubmissions = 1:maxResubmissions
    indexes = publishedPapers(:,4) == iResubmissions;
    qualityPerResubmission{iResubmissions} = qualityOfPublished(indexes);
    meanQualityPerResubmission(iResubmissions,:) = [mean(qualityOfPublished(indexes)) std(qualityOfPublished(indexes))];
    indexes = [];
end


% Publications comparisson
r = rand(1,length(scientists));
initialPublications = zeros(length(scientists),1);
parfor iScientist = 1:length(scientists)
    if (r(iScientist) <= 0.14)
        initialPublications(iScientist) = randi([1,5]);
    elseif (r(iScientist) <= 0.27)
        initialPublications(iScientist) = randi([6,10]);
    elseif (r(iScientist) <= 0.45)
        initialPublications(iScientist) = randi([11,20]);
    elseif (r(iScientist) <= 0.71)
        initialPublications(iScientist) = randi([21,50]);
    elseif (r(iScientist) <= 0.89)
        initialPublications(iScientist) = randi([51,100]);
    else
        initialPublications(iScientist) = randi([100,200]);
    end
end

averageInitialPublications = [mean(initialPublications) std(initialPublications)];
averageFinalPublications = [mean(scientists(:,3)) std(scientists(:,3))];
comparissonOfProductivity = (averageFinalPublications - averageInitialPublications)./averageInitialPublications;

initialResources = initialPublications.*random('uniform',1,10,length(scientists),1);
finalResources = scientists(:,2);
%% Results


percentageOfRevisedPapers = 100*length(find(publishedPapers(:,2) ~= 0))/length(publishedPapers)
percentageOfImprovedPapers = 100*length(find(publishedPapers(:,3) > 0))/length(publishedPapers);
percentageOfImprovedPapersOutOfAllRevised = 100*length(find(publishedPapers(:,3) > 0))/length(find(publishedPapers(:,2) ~= 0))

totalTimeSpentForReviewing = sum(reviewingTime);
timeSpentByTheEditors = sum(random('uniform',1,3,1,(length(publishedPapers(:,1)) + sum(publishedPapers(:,4)))));

% Main results
resubmissions = hist(publishedPapers(:,4),20);
resubmissions = resubmissions/length(publishedPapers);
resubmissions(resubmissions == 0) = [];
resubmissionsFinal(:,1) = round(100*resubmissionsReal',1);
resubmissionsFinal(:,2) = round(100*resubmissions(1:length(resubmissionsReal)),1)';
resubmissionsFinal(:,3) = resubmissionsFinal(:,2) - resubmissionsFinal(:,1)

papers = yearlyPublishedPapers(2:end) - yearlyPublishedPapers(1:end-1);
mean(papers)
std(papers)

time = yearlyTimeSpentForReviewing(2:end-2)' - yearlyTimeSpentForReviewing(1:end-3)';
time = (time/8)./(365 - 2*52 - 25.3);
mean(time)
std(time)


%% Figures
% Total acceptance rates
% figure(1)
% subplot(2,1,1)
% histogram(journals(:,7),100)
% hold on
% histogram(acceptanceRatesTotal,100)
% subplot(2,1,2)
% ecdf(journals(:,7))
% hold on
% ecdf(acceptanceRatesTotal)
AcceptanceRatesComparisson(journals(:,7), acceptanceRatesTotal)

% Editorial rejection
% figure(2)
% subplot(2,1,1)
% histogram(journals(:,9),100)
% hold on
% histogram(acceptanceRatesEditor,100)
% subplot(2,1,2)
% ecdf(journals(:,9))
% hold on
% ecdf(acceptanceRatesEditor)
EditorialRejectionRatesComparisson(journals(:,9), acceptanceRatesEditor)

% % % Resubmission distributions
% ComparissonOfResubmissionDistributions(resubmissionsFinal(:,[1,2]))
% 
% % % Published vs Unpublished
% ComparissonsPublishedUnpublished(qualityOfPublished, qualityOfUnpublished)
% % 
% % % Initial vs final publications
% ComparissonsPublicationsInitialFinal(initialPublications, scientists(:,3))
% % 
% % % Initial vs final resources
% InitialVsFinalResources(initialResources, finalResources)
% % 
% % % Comparisson of quality based on the amount of resubmissions before
% % % publication
% ComparissonsDependingOnResubmissions(qualityPerResubmission{1, 1}, ...
%     qualityPerResubmission{2, 1}, ...
%     qualityPerResubmission{3, 1}, ...
%     qualityPerResubmission{4, 1}, ...
%     qualityPerResubmission{5, 1}, ...
%     qualityPerResubmission{6, 1})
