%Folders Error checks to make sure all the nessisary folders in the search path are
%presant.

if ~programData.homeFolderFlag
    cd(programData.homefolder)
end
p = 'Functions;Functions\Errors;Functions\Fitts Task;Functions\GUI;Functions\Utility;';
fold = genpath('Functions');
if ~strcmp(p, fold)
   errordlg("Abby found that the named folders in the 'Abby\Function' do not match the default. This could mean that those folders don't exist or have been renamed. This is preventing continuation.");
   e.identifier = 'MATLAB:Abby:folders_error';
   e.message = 'Missing/renamed folders';
   error(e);
end
clear p fold