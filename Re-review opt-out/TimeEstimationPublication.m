function [ timeEstimation ] = TimeEstimationPublication( decision )

r = rand;

if decision == 2
    % Editorial rejection
    if r <= 0.15
        timeEstimation = 1;
    else
        timeEstimation = random('uniform',1,3);
    end
    
elseif decision == 0 
    % First decision (rejection)
    if r <= 0.69
        timeEstimation = random('uniform',4,11);
    elseif r <= 0.95
        timeEstimation = random('uniform',12,24);
    else 
        timeEstimation = random('uniform',25,52);
    end

elseif decision == 1
    % First decision (acceptance)
    if r <= 0.69
        timeEstimation = random('uniform',4,11);
    elseif r <= 0.95
        timeEstimation = random('uniform',12,24);
    else 
        timeEstimation = random('uniform',25,52);
    end
    
elseif decision == 3 
    % Revisions (rejection)
    if r <= 0.2
        timeEstimation = random('uniform',4,11);
    elseif r <= 0.72
        timeEstimation = random('uniform',12,24);
    else
        timeEstimation = random('uniform',25,52);
    end
    
elseif decision == 4
    % Revisions (acceptance)
    if r <= 0.2
        timeEstimation = random('uniform',4,11);
    elseif r <= 0.72
        timeEstimation = random('uniform',12,24);
    else
        timeEstimation = random('uniform',25,52);
    end
end       

timeEstimation = round(timeEstimation);
end

