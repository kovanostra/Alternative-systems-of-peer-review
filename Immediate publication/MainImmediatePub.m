%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SIMULATION OF THE CROWDSOURCING PEER REVIEW SYSTEM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                   %% MAIN PART %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise the constants of the simulation
InitialiseConstantsAndGlobals
reviewsCounter = 0;
publishTime = zeros(20*scientistsPopulation,1);
while (iTime <= time)

    %% The submission process
    SubmissionProcess
    totalScientificInformation(iTime) = sum(qualityOfPapers(weekRange,1).*journals(qualityOfPapers(weekRange,5),10));

    %% The whole peer review and publication process
    reviewersAttracted = zeros(length(resubmissionProbability),time);
    reviewersAttractedFinal = zeros(length(resubmissionProbability),20);
    ThePeerReviewProcess

    %% Finalising calculations
    %timeToPublish(weekRange)
    numberOfPapers = numberOfPapers + length(weekRange);
    %weeklyResubmissionFlow{iTime} = historyOfPapers;

    % Resources related again
    [ resourcesCounter ] = ResourcesCounter( resourcesCounter, totalResourcesInvested, qualityOfPapers, weekRange);

    % Update of the per-time step and of the cummulative scientific 
    % information that is released to the system   
    [ scientists, qualityOfPapers, totalScientificInformation(iTime), publishedQuality, resourcesCounter ] = ScientificInformation( scientists, journals, ...  
        qualityOfPapers, numberOfPapers, publishedQuality, resourcesCounter, totalScientificInformation(iTime) );

    % Update of the scientific's community level due to the new publications
    [ scientists, cummulativeScientificInformation ] = UpdateTheScientificCommunity( scientists, totalScientificInformation, publishedQuality, iTime );

    % Update of the time that papers need in order to be published
    qualityOfPapers(1:numberOfPapers - 1,6) = qualityOfPapers(1:numberOfPapers - 1,6) - 1;

    % Update acceptance rates
    [ scientists, journals, journalsToUpdate, reviewingTime, totalScientificInformation(iTime), reviewsCounter ] = ...
        UpdateJournals( scientists, journals, journalsToUpdate, reviewingTime, totalScientificInformation(iTime), reviewsCounter );

    % Calculation of yearly time spent in peer review and of the yearly amount of published papers
    YearlyReviewingTimeAndPapers

    % Now that the thresholds have been set the system is reinitialised in order to work in a calibrated way
    Reinitialise

    % Update the time
    iTime = iTime + 1;       


 end