function tutorial(window, source)
%TUTORIAL This is the script for the tutorial!
%   When the tutorialOn function is activated in parameters this
%   function is called implicitly. It will delay the Fitts Task by
%   displaying all the important informaition the paitent needs to know
%   about the Fitts trial, including what it is, how to operate it and what
%   their goals are.
%
%   We reccomend leaving the setting on even if you have already explained
%   the Fitts Task to the paitent as it reinforces the behaviour we want to
%   see for good data.
% 
%   Preconditions: The PTB window the paitent sees.
% 
%   Postconditions: None.

%--
%Create and display tutorial text.

text = ['This is ' source '. Remember:' newline 'Your goal is to reach the red areas.' newline 'Do so as quickly and as accurately as possible!'];
DrawFormattedText(window, text, 'center', 'center', 1);   
Screen('Flip', window);

%       Include tutorial code here. NOTE; Meaning to add a visual example
%       of the Fitts Trial, not enough time though...

KbStrokeWait;   %This prevents the code from continuing until a keybord button is registered.
end

