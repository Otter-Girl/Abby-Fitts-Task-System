function tempRow = makeTarget(s, targetInfo)
%MAKETARGET Creates the targetArea object identity.
%     Go to makeCursor.m for more information on what 'object identity' is.
% 
%     TargetArea is identified according to Fitt's Law and the parameters
%     given to the function. A random position is choosen within the range of
%     the screen width and the starting area and the the appropriote width is
%     calculated to match the choosen Index of Difficulty. If targetArea's
%     bounds exceed the screen width or overlap with startingArea, the
%     function will cease and try again.
% 
%     Preconditions: Screen details (s), choosen ID, startingArea (the
%     identifying matrix) and the starting position (numbered 1-4).
% 
%     Postconditions: Returns the identifying matrix for targetArea.
% 
% 
%     Explination of ambiguous variables.
%     s = 
% 
%     struct with fields (only the required fields shown):
% 
%               colours: [5×3 double]
%             creenXpix: 1920
%             creenYpix: 1080
%     creenFlipInterval: 0.0083
%                  tyle: 1
%               ourceID: double(0x0)
% 
%     targetInfo (inputs are double or NaN)=
% 
%     targetDistance   targetWidth     startingPosition      indexOfDifficulty      blockType

%% Set up.


if isnan(targetInfo(3))
   targetInfo(3) = 1;
end

if s.ourceID ~= 2   %SourceID 2 is blockMaker.m, the remaining souce for calling this function is main.m > metadataManipulation.m
    if targetInfo(5) == 1
        Xposition = (((s.creenXpix/3)) + (s.creenXpix-((s.creenXpix/3)*1.5))*rand);  
        Yposition = (((s.creenYpix/3)) + (s.creenYpix-((s.creenYpix/3)*1.5))*rand);
    else
        Xposition = (((s.creenXpix/2.05)) + (s.creenXpix-((s.creenXpix/2.05)*1.5))*rand);  
        Yposition = (((s.creenYpix/2.05)) + (s.creenYpix-((s.creenYpix/2.05)*1.5))*rand);
    end
    if targetInfo(3) ~= 1
        Xposition = s.creenXpix - Xposition;
        Yposition = s.creenYpix - Yposition;
        distanceX = Xposition - (11 * s.creenXpix/12);
        distanceY = Yposition - (11 * s.creenYpix/12);
    else
	    distanceX = Xposition - s.creenXpix/12;
        distanceY = Yposition - s.creenYpix/12;
    end

    calculatedXwidth = (2*(abs(distanceX))) / pow2(targetInfo(4));
    calculatedYwidth = (2*(abs(distanceY))) / pow2(targetInfo(4));

    if (Xposition + (calculatedXwidth / 2) > s.creenXpix + 1) || ...
       (Yposition + (calculatedYwidth / 2) > s.creenYpix + 1) %Check for errors
        makeTarget(s, targetInfo);
    end
else
    if s.tyle == 1
        distanceX = targetInfo(1);
        calculatedXwidth = targetInfo(2);
    else
        distanceY = targetInfo(1);
        calculatedYwidth = targetInfo(2);
    end
    if targetInfo(5) ~= 1
        Xposition = s.creenXpix/2 + targetInfo(2)/2;
        Yposition = s.creenYpix/2 + targetInfo(2)/2;
    end
    if targetInfo(3) ~= 1
        Xposition = s.creenXpix - Xposition;
        Yposition = s.creenYpix - Yposition;
    end
    if (Xposition + (calculatedXwidth / 2) > s.creenXpix + 1) || ...
       (Yposition + (calculatedYwidth / 2) > s.creenYpix + 1) %Check for errors
        makeTarget(s, targetInfo);
    end
end

targetRefMat = ... 
                [Xposition s.creenYpix/2 calculatedXwidth s.creenYpix abs(distanceX) calculatedXwidth; ...
                s.creenXpix/2 Yposition s.creenXpix  calculatedYwidth abs(distanceY) calculatedYwidth; ... 
                Xposition Yposition calculatedXwidth calculatedYwidth NaN NaN];     %2d implementation not complete: contact harry.carr@mail.dcu with questions.

tempRow = targetRefMat(s.tyle, :);

%% Identity.

baseTargetRect = [0 0 tempRow(1, 3) tempRow(1, 4)];                                
targetIdentifier = CenterRectOnPointd(baseTargetRect, tempRow(1, 1), tempRow(1, 2));
tempRow = [targetIdentifier tempRow(5:6)];

%One can see all six elements of 'target' are used to make the target area.
%The final two values are clerical values included in the returned matrix for convienience.
