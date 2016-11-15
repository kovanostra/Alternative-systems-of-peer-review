function [ journals ] = QualityToThreshold( scientists, journals, time, weeksInAYear )

global scientistsPopulation journalsPopulation

N = scientistsPopulation;
J = journalsPopulation;

if ( mod(time,weeksInAYear) == 0 )
    
    [ ~, scientistLevel, totalResourcesInvested ] = DefineAuthorAndResourcesToSpend( scientists, N );
    [ sampleQualityOfPapers ] = QualityCalculation( scientistLevel, totalResourcesInvested, 0 );
    
    sampleSorted = sort(sampleQualityOfPapers,'ascend');
    sampleQualities = zeros(J,1);
    intervals = (1:J).*floor(length(sampleQualityOfPapers)/J);
    for iSample = 1:length(intervals)
        sampleQualities(iSample) = sampleSorted(intervals(iSample));
    end
    sampleQualities(1) = (sampleQualities(1) + sampleQualities(2))/2;
    
    %noise1 = random('beta',2.8927,10.0237,J,1)./(5*max(random('beta',2.8927,10.0237,J,1)));%,'descend');
    raiseThresholdOfTopJournals = zeros(J,1);
    raiseThresholdOfTopJournals(end-20:end,1) = 1;
    noise1 = random('uniform',0.01,0.15,J,1) - sort(random('normal',0.00,0.045,J,1)) + raiseThresholdOfTopJournals(:,1).*sort(random('normal',0.00,0.015,J,1));% mean(random('normal',0.00,0.045,J,1));
    noise2 = noise1 - 0.095;
    
    journals(:,3) = 0.90.*sampleQualities + noise1;
    journals(:,4) = 1.20.*journals(:,3) + noise2;
    
end 
end