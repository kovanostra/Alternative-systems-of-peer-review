function [ scientists, qualityOfPapers ] = Recompose( scientists, authors, author, qualityOfPapers, papers, weekRange )
scientists(author,1) = authors.name;
scientists(author,2) = authors.resources;
scientists(author,3) = authors.publications;
scientists(author,4) = authors.level;

qualityOfPapers(weekRange,1) = papers.firstQuality;
qualityOfPapers(weekRange,2) = papers.improvedQuality;
qualityOfPapers(weekRange,3) = papers.percentage;
qualityOfPapers(weekRange,4) = papers.resubmissions;
qualityOfPapers(weekRange,5) = papers.journal;
qualityOfPapers(weekRange,6) = papers.publish;
qualityOfPapers(weekRange,7) = papers.author;

end

