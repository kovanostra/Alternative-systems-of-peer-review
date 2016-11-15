function [ index ] = Index2( qualityOfPaper )

if (qualityOfPaper(2) ~= 0)
    index = 2;
else
    index = 1;
end

end

