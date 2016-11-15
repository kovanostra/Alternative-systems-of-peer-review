
global authorBias               resourcesParameter              sclContributionToQuality ...
       sclParameter             thirdReviewerProbability        scientistsPopulation ...
       epsilon                  resourcesContributionToQuality  timeSpent ...
       journalsPopulation       competitiveProbability          noEditorialScreening ...
       
       
       
 %% Definition of parameters and constants   

% Initialisation of the "scientists" and "journals" variables
[ scientists, journals ] = InitialiseScientistsAndJournals( );   

% Time variables     
reinitialisation = 1;
iTime = 1;
years = 10;
weeksInAYear = 52;
time = years*weeksInAYear + weeksInAYear;

% General parameters
numberOfPapers = 1;

% Parameters that define the quality of a paper
authorBias = 0.1;
sclContributionToQuality = 0.2;
resourcesContributionToQuality = 0.8;
sclParameter = 0.01;
resourcesParameter = 0.1;

% Submission and reviewing parameters
epsilon = 0.1;
thirdReviewerProbability = 0.2;
totalTimeSpentForReviewing = zeros(round(time/52) + 1,1);
reviewingTime = zeros(scientistsPopulation,1);

%% Defining the metrics

% Quality, Improved quality, percentage of improvement, 
% resubmissions, journal, time to publish, author
qualityOfPapers = zeros(20*scientistsPopulation,7);
weeklyResubmissionFlow = cell(time);

% Quality that was published, scientific information that 
% was published, was it a correct publication or not
publishedQuality = [ 0 0 0 ];                     

% Quality that should have been published, scientific information
% that should have been published, was it accepted or not
shouldBePublished = [ 0 0 0 ];                                             
                         
% Initial resources, final resources, relative difference,
% ratio, author
resourcesCounter = zeros(20*scientistsPopulation,5);

% Journals to update metric
journalsToUpdate = [];

% Information metrics
totalScientificInformation = zeros(time,1);
cummulativeScientificInformation = zeros(time,1);

% Reviewing behaviour
competitiveProbability = linspace(0.10,0.66,journalsPopulation);

% Journals that do not screen editorially
noEditorialScreening = randperm(journalsPopulation - 10,5);

%% Define the time spent by the reviewers
lengthHelp = 10000;
B = zeros(lengthHelp,1);

r = rand(lengthHelp,1);
parfor iLength = 1:lengthHelp
    [ timeSpentTemp(iLength) ] = TimeEstimation( B(iLength), r(iLength) );
end
timeSpent = timeSpentTemp;

clear B r lengthHelp iLength