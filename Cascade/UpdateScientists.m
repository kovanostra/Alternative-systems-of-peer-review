function [ authors ] = UpdateScientists( update, authors, bonusOrDiscountedResources )
% Update of the scientists values depending on if there is acceptance of a
% paper (update = 1) or rejection (update = 2). Also if update = 0 there is
% update to the values due to the passage of a week as defined by the
% model.

% Condition for updating at acceptance
if update == 1            
    authors(2) = authors(2) + bonusOrDiscountedResources(1);               % Update of scientist's resources due to publication
    authors(3) = authors(3) + 1;                                           % Update the number of the scientist's published articles
    authors(4) = authors(4) + 1 + bonusOrDiscountedResources(1) - ...
        bonusOrDiscountedResources(2);                                     % Update of the scientist's scientific level

% Condition for updating at rejection
elseif update == 2
    authors(4) = authors(4) - bonusOrDiscountedResources;                  % Update of the scientist's scientific level
    
end
    
end

