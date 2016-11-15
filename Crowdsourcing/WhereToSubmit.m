function [ journalToSubmit ] = WhereToSubmit( journals, qualityOfPaper, percentage )
% Selects a journal, inside an appropriate range of impact factors, in
% order for the author to submit the paper

epsilon = abs(random('normal',qualityOfPaper/5,qualityOfPaper/20));
journalToSubmit = zeros(length(qualityOfPaper),1);
help = random('normal',percentage,0.01);
e1 = help.*(2.*epsilon);
e2 = (1 - help).*(2.*epsilon);

for iJournals = 1:length(qualityOfPaper)
    % Journals with threshold higher than qualityOfPaper - e1
    journalsToSubmit{1} = find(journals(:,3) >= qualityOfPaper(iJournals) - e1(iJournals));

    % Journals with threshold lower than qualityOfPaper + e2
    journalsToSubmit{2} = find(journals(:,3) <= qualityOfPaper(iJournals) + e2(iJournals));

    if (isempty(journalsToSubmit{1}) == 0) && (isempty(journalsToSubmit{2}) == 0) && (journalsToSubmit{1}(1) <= journalsToSubmit{2}(end))
        % Selects randomly a journal  that its least acceptable quality for
        % publication is: 
        index = randi([journalsToSubmit{1}(1),journalsToSubmit{2}(end)]);
        journalToSubmit(iJournals) = journals(index,1);
        
    elseif (isempty(journalsToSubmit{1}) == 0) && (isempty(journalsToSubmit{2}) == 0) && (journalsToSubmit{1}(1) > journalsToSubmit{2}(end))
        index = randi(2);
        if (index == 1)
            journalToSubmit(iJournals) = journals(journalsToSubmit{1}(1));
        else
            journalToSubmit(iJournals) = journals(journalsToSubmit{2}(end));
        end
    elseif (isempty(journalsToSubmit{2}) == 1)

        % This case is valid only if the paper is of extraordinary quality, so
        % the author submits it only to the best journal
        journalToSubmit(iJournals) = randi([journals(1,1), journals(10,1)]);
    elseif (isempty(journalsToSubmit{1}) == 1)
        % This case is valid only if the paper is of extraordinary quality, so
        % the author submits it only to the best journal
        journalToSubmit(iJournals) = randi([journals(end - 10,1), journals(end,1)]);
    end
end

end

