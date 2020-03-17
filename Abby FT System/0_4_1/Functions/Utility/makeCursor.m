function cursorPointer = makeCursor(s, mx, my)
%MAKECURSOR Creates the cursorPointer object identity.
%     In this digital space the best way to think about the stimuli and
%     objects the paitent see is like this.
% 
%--Paramaters make> Object Identity facillitate> Object creation on screen then> Object is drawn by GPU on screen--
% 
%     This is how PTB deals with stimuli on screen which is why the makeX
%     functions say they are making the object identity and not the object
%     itself, because those two things happen in different places. The
%     objects are 'made' during the work loop in either discrete.m or
%     reciprocal.m.
% 
%     Preconditions: The cursor's current position, screen details (s).
% 
%     Postconditions: Returns the identifying matrix for cursorPointer



if s.tyle == 0 %This statement simply gets around preallocation, preventing 'cannotfind' errors and such.
else %% Set up.
cursorRefMat = [mx s.creenYpix/2 2 s.creenYpix; ...    %Horizontal trial. Mouse pointer position and size
                s.creenXpix/2 my s.creenXpix 2; ...   	%Vertical trial. Mouse pointer position and size.
                mx my 2 2]; ...                    	%2D trial. Mouse pointer position and size.         

cursor = cursorRefMat(s.tyle, :);            


%% Identity.

basePointerRect = [0 0 cursor(1, 3) cursor(1, 4)]; %The 'base' simply determines the size of the rectangle which will make up the object.
cursorPointer = CenterRectOnPointd(basePointerRect, cursor(1, 1), cursor(1, 2)); %This is the object's identity, including both its size and position on screen. However it does not exist on screen just yet.        
end