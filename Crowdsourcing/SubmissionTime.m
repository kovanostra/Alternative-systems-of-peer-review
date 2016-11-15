function [ nextSubmission ] = SubmissionTime( population )

r = rand(1, population);
year = 52;
nextSubmission = zeros(1,population);

for iPopulation = 1:population
    if (r(iPopulation) <= 0.84)
        nextSubmission(iPopulation) = randi(year/4);
    elseif (r(iPopulation) <= 0.95) 
        nextSubmission(iPopulation) = randi(round(year/5));
    elseif (r(iPopulation) <= 0.98)
        nextSubmission(iPopulation) = randi(round(year/6));
    elseif (r(iPopulation) <= 0.99)
        nextSubmission(iPopulation) = randi(round(year/7));
    elseif (r(iPopulation) <= 1)
        division = randi([8,15]);
        nextSubmission(iPopulation) = randi(round(year/division));
    end
end


end

