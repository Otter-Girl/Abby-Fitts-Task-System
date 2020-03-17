function import_error(blockData)
% IMPORT_ERROR Scans the block data file for errors.
%     Scans the block data file for errors. Cross-references the guiding
%     data in the first row versus all the other data in the matrix.
% 
%     Preconditions: A blockData file
% 
%     Postconditions: No returns. Throw a warning for dubious
%     inconsistancies that will not break the program if run. Throw an
%     error for any occurance that will cause Abby to break.


errorMessage = [];
warningMessage = [];

% if size(blockData, 2) ~= 6
%     errorMessage = [errorMessage 'Your session matrix must have 6 columns'];
% end
if size(blockData, 1) ~= blockData(1, 1) + 1
    warningMessage = [warningMessage 'The "number of trials" does not reflect the true amount of trials in your session matrix.   '];
end

if blockData(1, 5) == 2 || blockData(1, 5) == 3
    if size(unique(blockData(2 : blockData(1, 1) + 1, 5)), 2) > 1
        warningMessage = [warningMessage 'The starting position changes during the session and does not reflect the option shown in the GUI.   '];
    elseif unique(blockData(2 : blockData(1, 1) + 1, 5)) ~= blockData(1, 5) - 1
        warningMessage = [warningMessage 'The starting position does not reflect the true starting position in your session matrix.   '];
    end
elseif blockData(1, 5) == 4
    if size(unique(blockData(2 : blockData(1, 1) + 1, 5)), 2) == 1
        warningMessage = [warningMessage 'The starting position is fixed during the session and does not reflect the option shown in the GUI.   '];
    end
end

if ~isempty(errorMessage)
    errorMessage = ['There is a critical error in the session you want to import, causing the import to cease. Abby found this: ' errorMessage 'D:   '];
    if ~isempty(warningMessage)
        errorMessage = [errorMessage 'Abby also found these notable errors in your session: ' warningMessage];
    end
    errordlg(errorMessage, 'Critical Import Error')
    error('MATLAB:Abby:BadImport', 'Abby can not run a Fitts Trial with this imported session.')
elseif ~isempty(warningMessage)
    warningMessage = ['There are some inconsistencies in the session you want to import. These errors include: ' warningMessage 'Abby can try run the session but it may result in inconsistent or unusable data sets! You should review the session and re-import. If you are using a previously working session try restarting Abby and re-importing!'];
    warndlg(warningMessage, 'Import Inconsistencies')
end
