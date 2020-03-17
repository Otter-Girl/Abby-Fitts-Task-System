%% Run this file BEFORE any others. 
%This script sets up important data the program will use such as the home
%directory and the size of the screen. Running this script before any
%others will prevent data loss, courrupted data and mismatched data. Please
%run this first.
%
% It's not nessesary to run this function again after the first time
% however Abby does not reccomened you deleate this file after the fact.
%%

cd ..
cd ..
load('programdata.mat')

if programData.firsttimerunning == 0
    msgbox("You're ready to go!")
else
    
    %--
    %Ends innitialisation if user declares the program is not in the
    %correct home folder.
    %   The home folder is [can be moved]. Abby will try to correct its
    %   settings to match a changing home folder but it might not always
    %   succeed in preventing errors. Pick a homefolder you like before
    %   venturing out into experimentation. For the health of the system
    %   this is the reccomendation Abby gives.
    
    
    answer = questdlg("Before we start, is the current folder the correct home folder for your Abby?");
    if answer == "No"
        error("Program files are not in the correct home folder. Ending initialisation.")
    end
    clear answer
    
    
    %--
    %Set home folder and then check folder integrity.

    programData.homefolder = pwd;
    try
        run(fullfile(pwd, 'Functions', 'Errors', 'folders_error.m'))
    catch
        e = lasterror;
        if strcmp(e.identifier,'MATLAB:Abby:folders_error')
        	errordlg("Abby found that the named folders in the 'Abby\Function' do not match the default. This could mean that those folders don't exist or have been renamed. This is preventing continuation.");
        	throw(e);
        else
            errordlg("Unexpected error")
            rethrow(e)
        end 
    end
    
    %--
    %Set data and end initialisation.
    
    programData.installdate = datetime;
    programData.firsttimerunning = 0;
    
    %--
    %Save program data.
    
    save('programdata.mat', 'programData');
end