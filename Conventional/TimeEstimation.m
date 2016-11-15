function [ timeSpent ] = TimeEstimation( B, r )
% Estimates the time that the reviewer needs to evaluate the article by
% using data from Mulligan et al. (2013) for two different fields; Medicine
% and Physics. 
% The probability to spend a certain amount of time in the
% reviewing process corresponds to the percentage of the researchers that 
% said the process takes them that specific amount of time. 
% For the unreliable and the competitive reviewer no data exist, so the
% amount of time they spend reviewing an article is hypothesised.

%% In Medicine

% Reliable reviewer
if (r <= 0.65)
    timeSpent = random('uniform',2,5);
elseif (r <= 0.87)
    timeSpent = random('uniform',6,10);
elseif (r <= 0.95)
    timeSpent = random('uniform',11,20);
elseif (r <= 0.97)
    timeSpent = random('uniform',21,30);
elseif (r <= 0.99)
    timeSpent = random('uniform',31,50);
else
    timeSpent = random('uniform',51,100);
end


end

