%FITTSTASK Fitts Tast using Matlab and PsycheToolBox (PTB).
%   This is the main digital space for the Abby Fitts Task system. 
%
%   This function creates the PTB digital space and also handles any
%   clerical information required by the Abby system outside of the GUI.
%   Feel free to click around and enter functions from here. Follow the
%   metadata tag to get a good taste of things.
%
%   Before any and all modifications to this or any related code, save a
%   backup to revert to if things go bottom-up. Any and all modifications
%   to this code or derivations of code contained in any files related to
%   the Abby Fitts Task system, other than those created by the Abby
%   system, belong to the Abby system and are under creative rights
%   protection laws.
%
%   Preconditions: An input of parameters for the Fits Task trial; refeer
%   to the user manuel and consult your technician for data parameters
%   before each day of testing.
%
%   Postconditions: No returns. A stimulus is presented and the task is
%   run. A folder with the data gathered during the Fitts trials (and all
%   conditions) found in "Abby\Data".

%% Set-up.

%--
%Pre-allocation
%     It's good habbit to allocate the largest arrays to memeory first to
%     make MATLAB's job easier. You'll see this later on as making even
%     small variables takes a couple miliseconds, however, that's a timing
%     precaution, this case is a memory precaution.

positionPlot = nan(10000, 10);	%Records the cursor position on every frame, m x 7. Is cut or grown depending on size. 300 rows = ~5seconds.


%--
%Set up the digital space.

load metadata.mat
Screen('Preference','SkipSyncTests', 1);                        %NOTE; Remove before shipping.
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2);                                           %A default PTB configuation, only change if you know what you are doing.
screens = Screen('Screens');                                    %an array [0 1 2 ... n] who's max is the number of available screens (with zero being the entire availble space). Edit outside of MATLAB.
screenNumber =  1;                                              %max(screens); %getpreference(screens)
                clear screens;
s.colours =   colour([metadata.highContrast metadata.colourMode]);	
textSize =  [25 35 40];                                        	%NOTE put this section in maniputlateMetadta.m 
textSize =  textSize(metadata.textSize);                      	%NOTE; Probobably redundant?! Number should origionate from GUI.
[window] =  PsychImaging ...                                    %This is our digital window where the paitent will see the Fits Task.
            ('OpenWindow', screenNumber, s.colours(4,:));  
            clear screenNumber; 
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);  
Screen('TextSize', window, textSize);           clear textSize;         
Screen('TextFont', window, 'Ariel');
[s.creenXpix, s.creenYpix] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);    %The 'Inter-Frame Interval' or 1/hertz 
waitframes = 1;                             %Operates how often the screen should 'Flip', this setting flips every frame a flip is available at 60 hz.
s.creenFlipInterval =   (waitframes - 0.5) * ifi; 
                        clear ifi waitframes


%--
%Data preperations.

[metadata, blockData, s] = parametersPrep(metadata, s);
if metadata.touchType{1} == 2
	blockData = discrete2reciprocal(blockData, s);
end

    
%--
%Make directories

mkdir('Data', ['Participant_' num2str(metadata.participantID)]);	%Turn off directory warnings in MATLAB with: warning('off','MATLAB:MKDIR:DirectoryExists')
mkdir([metadata.dataSaveDirectory filesep 'Participant_' num2str(metadata.participantID)], [metadata.sessionID '_' metadata.touchType{2} '_' metadata.trialStyle]);
s.dataPath = ([metadata.dataSaveDirectory filesep 'Participant_' num2str(metadata.participantID) filesep metadata.sessionID '_' metadata.touchType{2} '_' metadata.trialStyle]);
%NOTE; touch type{2}                                

%--
%Check for paitent participation previous to this? Fucntion.

%--
if metadata.tutorialOn                                              %Tutorial.
    tutorial(window, 'the tutorial');
    metadata.tutorialOn = 'Yes';
else
    metadata.tutorialOn = 'No';
end



%% Paitient Initiates.

%--
%Final preperations.

topPriorityLevel = MaxPriority(window);	%Two commands that ensure the Fitts Task loop is given sufficient processing power, even on older machines.
Priority(topPriorityLevel);             %Please do not change this unless you know what you are doing!
clear topPriorityLevel

%--
%Trial

if metadata.touchType{1} == 1
    
    for i = 1:metadata.numBlocks
        discrete(positionPlot, window, s, metadata, blockData, i)
        if i ~= metadata.numBlocks
            tutorial(window, 'a rest between blocks')
        end
    end
    if metadata.orientationChange == 1
        if i ~= metadata.numBlocks
            tutorial(window, 'the time to change the tablet orientation')
        end
        blockData(1, 4) = 2;
        for i = 1:metadata.numBlocks 
            discrete(positionPlot, window, s, metadata, blockData, i)
            if i ~= metadata.numBlocks
                tutorial(window, 'a rest between blocks')
            end
        end
    end
    
else
        
    for i = 1:metadata.numBlocks
        reciprocal(positionPlot, window, s, metadata, blockData, i)
        if i ~= metadata.numBlocks
            tutorial(window, 'a rest between blocks')
        end
    end
    if metadata.orientationChange == 1
        if i ~= metadata.numBlocks
            tutorial(window, 'the time to change the tablet orientation')
        end
        blockData(1, 4) = 2;
        for i = 1:metadata.numBlocks 
            reciprocal(positionPlot, window, s, metadata, blockData, i)
            if i ~= metadata.numBlocks
                tutorial(window, 'a rest between blocks')
            end
        end
    end
    
end






metadata.touchType = metadata.touchType{2};



%--
%Cleanup.


sca;
blockData = blockData(:,1:11);
if metadata.savingOn
    if ~isempty(metadata.dataSaveDirectory)
        save([s.dataPath filesep 'metadata.mat'], 'metadata');
        save([s.dataPath filesep 'blockData.mat'], 'blockData');
    end
    save([pwd filesep 'SessionImport' filesep 'Most_recent'], 'blockData');
end
clearvars -except handles hObject programData
Priority(0);                                                                                                                                                      


