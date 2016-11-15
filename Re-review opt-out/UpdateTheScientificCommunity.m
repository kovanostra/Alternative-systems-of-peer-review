function [ scientists, cummulativeScientificInformation ] = UpdateTheScientificCommunity( scientists, totalScientificInformation, publishedQuality, iTime )

weeklySalary = random('uniform',0.1,1,length(scientists),1);
scientists(:,2) = scientists(:,2) + weeklySalary;
scientists(:,4) = scientists(:,4) + weeklySalary;
cummulativeScientificInformation(iTime) = sum(totalScientificInformation(1:iTime));

% Update of the scientific's community level due to the new publications
totalScientificInformationTemp = 0.1*mean(totalScientificInformation);

if (isempty(publishedQuality) == 0)
    if (totalScientificInformationTemp > 0)
        informationBias = totalScientificInformationTemp*0.1;
        scientists(:,4) = scientists(:,4) + random('normal', totalScientificInformationTemp , informationBias, length(scientists), 1);
    end
end



end