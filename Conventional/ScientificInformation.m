function [ scientists, qualityOfPapers, totalScientificInformation, publishedQuality, resourcesCounter ] = ScientificInformation( scientists, journals, ... 
    qualityOfPapers, numberOfPapers, publishedQuality, resourcesCounter )

% Finds the information relleased to the scientific community by the paper
% and the journal that it was published to. A paper contributes to the
% scientific information only at its exact time of publication.

papersToPublish = find(qualityOfPapers(1:numberOfPapers - 1,6) == 0);
totalScientificInformation = 0;
alreadyPublished = length(publishedQuality(:,1)) - 1;

if (isempty(papersToPublish) == 0)
    for iAcceptedPapers = 1:length(papersToPublish)
        paper = papersToPublish(iAcceptedPapers);
        journal = journals(qualityOfPapers(paper,5),:);
        author = qualityOfPapers(paper,7);
        
        % Fix paper's quality if there is an improvement
        [ index ] = Index2( qualityOfPapers(paper,:) );
        
        totalScientificInformation = totalScientificInformation + qualityOfPapers(paper,index).*journal(2);
            
        % Give the acceptance bonus due to publication 
        bonus = [(1 + random('normal',0.2,0.025))*resourcesCounter(paper,index) resourcesCounter(paper,index)];      
        scientist = scientists(author,:);
        [ scientist ] = UpdateScientists( 1, scientist, bonus );
        scientists(author,:) = scientist;
        
        % Store all the published quality and information that is released
        publishedQuality(alreadyPublished + iAcceptedPapers,1) = qualityOfPapers(paper,index);
        publishedQuality(alreadyPublished + iAcceptedPapers,2) = qualityOfPapers(paper,index)*journal(2);

        % Count the number of the correct publications
        if (qualityOfPapers(paper,index) >= journal(4))
            publishedQuality(alreadyPublished + iAcceptedPapers,3) = 1;
        else
            publishedQuality(alreadyPublished + iAcceptedPapers,3) = 0;
        end
    
    end
end

papersToReject = find(qualityOfPapers(1:numberOfPapers - 1,6) == 0.5);
if (isempty(papersToReject) == 0)
    for iRejectedPapers = 1:length(papersToReject)
        paper = papersToReject(iRejectedPapers);
        author = qualityOfPapers(paper,7);
        scientist = scientists(author,:);
        [ scientist ] = UpdateScientists( 2, scientist, resourcesCounter(paper,1) );
        scientists(author,:) = scientist;
    end
end


papersYetToDecide = find(qualityOfPapers(1:numberOfPapers - 1,6) >= 0.0);
if (isempty(papersYetToDecide) == 0)
    
    scientistsToLoseResources = zeros(length(papersYetToDecide),1);
    for iSubtract = 1:length(papersYetToDecide)
        scientistsToLoseResources(iSubtract) = qualityOfPapers(papersYetToDecide(iSubtract),7);
        scientists(scientistsToLoseResources(iSubtract),2) = scientists(scientistsToLoseResources(iSubtract),2) - resourcesCounter(papersYetToDecide(iSubtract),4);
        scientists(scientistsToLoseResources(iSubtract),4) = scientists(scientistsToLoseResources(iSubtract),4) - resourcesCounter(papersYetToDecide(iSubtract),4);
    end
   
end

end