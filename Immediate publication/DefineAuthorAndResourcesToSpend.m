function [ authors, scientistLevel, resourcesInvested ] = DefineAuthorAndResourcesToSpend( scientists, weeklySubmissions )
% Defines the index of the author who submits his work 
% and the amount of the resources he invests to it


authors = randperm(length(scientists),weeklySubmissions);                  % The author that submits his work

willNotSubmit = find(scientists(authors,2) <= 1 | isnan(scientists(authors,2)) == 1);
if (isempty(willNotSubmit) == 0)
    authors(willNotSubmit) = [];
end

discountFactor = random('uniform',0.2,0.7,length(authors),1);              % The percentage of his resources that is discounted for the submission
scientistLevel = scientists(authors,4);                                    % The authors' scientific level
resourcesInvested = (discountFactor(:).*scientists(authors,2))';           % The amount of his invested resources


end

