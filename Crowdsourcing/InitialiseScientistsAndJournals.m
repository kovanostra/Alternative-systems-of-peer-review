function [ scientists, journals ] = InitialiseScientistsAndJournals( )
%% Initialisation of the "scientists" and "journals" variables
global scientistsPopulation journalsPopulation impactFactorsReverse 
%% Defining scientists
scientistsPopulation = 25000;                                                                                                                                        
N = scientistsPopulation;

%% Initialise papers and resources as in Mulligan p.57
r = rand(1,N);
initialPublications = zeros(1,N);
parfor iScientist = 1:N
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

initialResources = initialPublications.*random('uniform',0.1,3,1,N);
initialScientificLevel = initialResources + initialPublications;
scientists = [(1:N);(initialResources);(initialPublications);(initialScientificLevel)]';

%% Defining journals
load('impactFactors.mat');
load('acceptanceRatesAfterEditor.mat')
journalsPopulation = length(impactFactors);
J = journalsPopulation;                                                    

in0 = zeros(1,J);
thresholds = sort(random('beta',2.8927,10.0237,1,J),'descend') + 0.3.*random('beta',2.8927,10.0237,1,J);

% Number, Impact factor, Low threshold, High threshold, Accepted papers, Rejected papers, Acceptance rate total, Editorial rejections, Editorial rejection rate
journals = [(1:J);(impactFactors(:,2)');(1.00 - 0.80.*thresholds);(1.30 - 0.90.*thresholds);(in0);(in0);(in0);(in0);(in0)]';
journals(:,end + 1) = acceptanceRateAfterEditor.*journals(:,2);


impactFactorsReverse = journals(end:-1:1,2);
end