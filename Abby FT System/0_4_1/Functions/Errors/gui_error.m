function gui_error(metadata)
%GUI_ERROR Detects faults in the basic set-up.
%     This protocol detects errors in the metadata file, ensuring the values
%     are within allowwed bounds, are the correct type of data, etc. This
%     section could always use improving and I encourage you to thing about
%     how you can make it better to make your Abby system run better.
% 
%     Preconditions: A metadata structure.
% 
%     Postconditions: No returns. Throw and error if any are detected.

errorMessage = [];

if ischar(metadata.numTrials)
    errorMessage = [errorMessage 'The "Number of Trials" is not a positive integer.\n'];
end
% if metadata.trialStyle == 1
%     errorMessage = [errorMessage 'No Fitts Task style has been chosen.\n'];
% end
number = metadata.ID;
if ischar(number) || number < 1 || number > 7, clear number
    errorMessage = [errorMessage 'The Index of Difficulty is outside the allowed range.\n'];
end
if metadata.startPos == 1
    errorMessage = [errorMessage 'Starting Area position is not configured.\n'];
end

%--
%Add more here as nessisary.
%--

if ~isempty(errorMessage)
    errorMessage = ['Abby could not start your session because these issues occured:   ' errorMessage ':( \n'];
    errordlg(errorMessage, 'Invalid Settings')
    error('MATLAB:Abby:InvalidSettings', 'Invalid settings.');
end
