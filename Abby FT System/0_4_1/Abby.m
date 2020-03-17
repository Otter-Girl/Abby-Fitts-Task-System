%% Program Start File
%This script sets up the digital enviroment for the Abby program. Run this
%script when you want to start Abby.
%
%Preconditions: None
%
%Postconditions: The Abby Fitts Task Program running at the Paramaters
%screen.

load('programdata.mat')

%--
%Checks to see if initialise.m has been run. Read 'help initialise.m' to
%learn more.

if programData.firsttimerunning == 1
    answer = questdlg("This seems to be your first time running the Abby system. Do you want to run initialise.m?");
    if answer == "Yes"
        run(fullfile(pwd, 'Functions', 'Utility', 'installation.m'));
    end
end

%--
%Cross reference the known homefolder to ensure file integrity. 

if programData.homeFolderFlag
    answer = questdlg("There seems to be an issue with your homefolder and program files that you told Abby to ignore on last start-up.", "Home Folder Error", "I resolved the issue", "Continue start-up", "Cancel", "Cancel");
    switch answer
        case "I resolved the issue"
            programData.homeFolderFlag = 0;
        case "Continue start-up"
        otherwise
            e.identifier = "MATLAB:Abby:HomeFolderIssue";
            e.message = "Start-up ended at user request.";
            error(e)
    end
elseif strcmp(pwd, programData.homefolder) == 0  %pwd = the full directory of MATLAB's current folder
    answer = questdlg("Abby has been moved from the homefolder.", "Moved Program Files", "Change the home folder", "Do not change the home folder", "Cancel", "Cancel");
    switch answer
        case "Change the home folder"
            programData.homefolder = pwd;
        case "Do not change the home folder"
            programData.homeFolderFlag = 1;
        otherwise
            e.identifier = "MATLAB:Abby:HomeFolderIssue";
            e.message = "Start-up ended at user request.";
            error(e)
    end
    clear answer
end

%--
%Final set-up.

addpath(genpath("Functions"))   %NB; Do not remove or change. This innitialises all the Abby functions into the MATLAB search path. Removing or changing this will result in errors and the prevention of Abby from working as intended.
folders_error()                 %Checks folder integrity.
save programdata.mat programData
Parameters                      %Starts Paramaters.m.