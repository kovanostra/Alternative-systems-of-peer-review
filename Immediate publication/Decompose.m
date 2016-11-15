function [ authors, papers ] = Decompose( scientists, author, qualityOfPapers, weekRange )

%% Decompose to weekly submitting scientists
authors.name = scientists(author,1);
authors.resources = scientists(author,2);
authors.publications = scientists(author,3);
authors.level = scientists(author,4);

%% Decompose to weekly submitted papers papers
papers.firstQuality = qualityOfPapers(weekRange,1);
papers.improvedQuality = qualityOfPapers(weekRange,2);
papers.percentage = qualityOfPapers(weekRange,3);
papers.resubmissions = qualityOfPapers(weekRange,4);
papers.journal = qualityOfPapers(weekRange,5);
papers.publish = qualityOfPapers(weekRange,6);
papers.author = qualityOfPapers(weekRange,7);

end

