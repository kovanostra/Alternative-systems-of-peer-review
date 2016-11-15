if ( iTime == weeksInAYear ) && ( reinitialisation == 1)
%% Definition of parameters and constants   

    % General parameters
    numberOfPapers = 1;
    reviewingTime = zeros(scientistsPopulation,1);
    %% Defining the metrics

    % Quality, Improved quality, percentage of improvement, 
    % resubmissions, journal, time to publish, author
    qualityOfPapers = zeros(20*scientistsPopulation,7); 
    weeklyResubmissionFlow = cell(time - weeksInAYear);

    % Quality that was published, scientific information that 
    % was published, was it a correct publication or not
    publishedQuality = [ 0 0 0 ];                     

    % Quality that should have been published, scientific information
    % that should have been published, was it accepted or not
    shouldBePublished = [ 0 0 0 ];                                             

    % Initial resources, final resources, relative difference,
    % ratio, author
    resourcesCounter = zeros(20*scientistsPopulation,5);

    % Information metrics
    totalScientificInformation = zeros(time - weeksInAYear,1);
    cummulativeScientificInformation = zeros(time - weeksInAYear,1);

    reinitialisation = 0;
    iTime = 0;
    time = time - weeksInAYear;

end
