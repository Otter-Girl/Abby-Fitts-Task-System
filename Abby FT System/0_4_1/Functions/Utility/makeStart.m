function startingArea = makeStart(s, startingPosition, ~)
%MAKESTART Creates the startingArea object identity.
%   Go to makeCursor.m for a full explination of what 'object identity'
%   means.
%
%   Preconditions: Screen details (s) and the starting position.
%
%   Postconditions: Returns the identifying matrix for startingArea.

%% Set up.

if startingPosition == 1 %Decides where the starting position is.
    startPosition = [s.creenXpix/12 s.creenYpix/12];
elseif startingPosition == 2
    startPosition = [11 * s.creenXpix/12 11 * s.creenYpix/12];
end

startRefMat =  [startPosition(1) s.creenYpix/2 s.creenXpix/50 s.creenYpix; ...
                s.creenXpix/2 startPosition(2) s.creenXpix s.creenYpix/50; ...
                startPosition(1) startPosition(2) s.creenXpix/50 s.creenYpix/50];
start = startRefMat(s.tyle, :);


%% Identity.

baseStartRect = [0 0 start(1, 3) start(1, 4)];                                   
startingArea = CenterRectOnPointd(baseStartRect, start(1, 1), start(1, 2));