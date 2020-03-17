function allColours = colour(colourMode)
% COLOUR Alters the colour pallette for Abby.
%   Colour accessability options available in control. NOTE; This is
%   currently unfinished.
% 
%   Preconditions : Colour preferences taken from metadata.txt.
% 
%   Postconditions: An array of the colours to be used.



allColours =    [1 0 0; ...         %Red    - Objective
                1 1 0; ...          %Yellow - Cursor
                0 1 0; ...          %Green  - Completed Objective
                0 0 0
                1 1 1]; ...         %Black  - Back Drop

if colourMode(1) == 1 %High contrast colour mode.
    allColours(1,:) = [1 0.5 0.5];  %Pink
    allColours(2,:) = [1 1 0.5];    %Bright Yellow
    allColours(3,:) = [0.5 1 0.5];  %Bright Green
end
    
if colourMode(2) == 2 %(Colour mode option 1)
    allColours(1,:) = allColours(1,:) + [0 0.5 0];  %Yellow/Orange
    allColours(2,:) = allColours(2,:) + [0 0 0.5];  %
    
end

