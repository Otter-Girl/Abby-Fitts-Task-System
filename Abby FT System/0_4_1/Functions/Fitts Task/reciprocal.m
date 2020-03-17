function reciprocal(positionPlot, window, s, metadata, blockData, blockNumber, blockState)
%DISCRETE Work function for discrete Fitts' Tasks.
%     This function contains all the variables required to present a
%     discrete Fitts' Task stimulous to the specifications of the user.
% 
%     Preconditions: Pre-allocated data, a PTB window, screen data (s),
%     metadata, blockdata for the trials. If a trial or block
%     is being re-run, blockState is passed to indicated where the program
%     should run from.
% 
%     Posconditions: No returns. A stimulus block is presented to the
%     participant. A number of data files are made and saved along side the
%     meta and block data in the directories made in main.m.



if nargin < 7
    blockState = 1;
end
data.comment = metadata.commentBox;
data.participantID = metadata.participantID;
data.positionPlot = nan(10000, 10);        %The above positionPlot is allocated to this space later as it's easier for MATLAB to edit the above smaller matrix than it is to edit this large data structure.
data.validationTime = 0.8;      %Change this to alter the waiting times between when a paitent enters an objective zone and when a change takes place based on that action.
data.timeTaken = NaN;                   
data.taskStartTime = NaN;
data.taskTargetTime = NaN;      
data.targetDistance = [NaN; NaN];
data.intention2move = NaN;
data.peakVelocity = NaN;
data.cursorStartPosition = [NaN; NaN];
data.startingAreaPosition = [NaN; NaN];
data.startingAreaDimentions = [NaN; NaN];
data.targetArea = NaN(1, 4);    %The current trial's target area information.
data.targetAreaPosition = [NaN; NaN];
data.targetAreaDimentions = [NaN; NaN];
tabletRecievedTime = 1;                     %Used to adjust for discrepancies between the recorded time and the time the paitent sees the stimulous.
stylusPressue = 1;                          %Currently redundent variable but recorded for future potential.
validationTime = data.validationTime;    	



%--
%Variable Dump
%     This cacophany of variables and functions is the list of objects that
%     will be used in the main while loop of functions and variables that
%     _haven't_ already been called. This is called pre-allocation; since
%     it takes MATLAB a couple of miliseconds to create each vaiable doing
%     this will lessen the liklihood that the 'flip' functions misses a
%     deadline, which would result in off-set data for that frame. Hence
%     doing this makes the program more accurate while changing nothing
%     about how it functions or handles memory. Do not remove any off this
%     code! Better yet if you see a function I haven't included in here,
%     add it yourself! And assign it zero so that it's as quick as
%     possible.
%Variables
trigger3 = false;
trigger2 = false;
trigger1 = false;
check1 = false;                 
check2 = false;
check3 = 0;
check4 = 0;
frameCounter = NaN;               
trialStartTime = NaN;
mx = NaN;
my = NaN;
o2 = [NaN NaN NaN NaN];
filename = NaN;
paitentError = false;
inaccuracy = 0;
repCounter = 0;

%Functions
IsInRect(NaN, NaN, [NaN NaN NaN NaN]);
makeCursor(s,0,0);
GetSecs;
GetMouse(window);
KbCheck; clear keyIsDown



%--
%Screen flip
%     Tells the graphics card when to display new screens, is called as
%     late as possible so the first flip stimulus isn't missed. This helps
%     pin down timing issues with the program.
vbl = Screen('Flip', window);               


for i = blockState:metadata.numTrials
    %% Pre-trial preperations.
    %     These parameters are re-set after each trial to set up the logic
    %     and memory.

    trigger3 = false;
    trigger2 = false;               %These two statements set up the logic for each trial. 
    trigger1 = false;               %They track the paitent's progress through the objectives.
    positionPlot = (nan(10000, 10));%Reallocated here (overwrites current memory) so that the matrix is reset every trial.
    frameCounter = 1;               %Simply tells positionPlot how many frames have passed
    trialStartTime = GetSecs;   	%Uses computer clock to get a starting time to high precision.
    taskWait = 0;                   %Logical tool used in conjunction with validationTime.   
    o1 = blockData(i+1, 8:11);
    o2 = blockData(i+1, 1:4);
    
    %--
    if metadata.restsOn == 1   %Paitent rest point. 
    %     Max once every eight trials. Approximates for trial numbers not
    %     divisible by eight.
        if rem(i, restGap) == 0
            restText(window);
        end
    end
    
    
    
    %% Trial block.    
    while trigger3 == false 
        %--
        %Frame Start, check for pausing
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown == 1
            if keyCode(82)
                DrawFormattedText(window, 'The task was paused by the experimnenter,\n please listen to their instructions.', 'center', 'center', 1);   
                vbl = Screen('Flip', window, vbl + s.creenFlipInterval);
                answer = questdlg('Trail Paused.\n What would you like to do?', 'Trial Paused', 'Run previous stimuli', 'Restart block', 'Restart current stimuli', 'Restart trial');
                if answer == 'Restart trial'
                    reciprocal(positionPlot, window, s, metadata, blockData, blockNumber, mostRecentCompleted)
                elseif answer == 'Restart session'
                    reciprocal(positionPlot, window, s, metadata, blockData, blockNumber, 1)
                else
                    reciprocal(positionPlot, window, s, metadata, blockData, blockNumber, i)
                end
            end
        end
        
        %--
        %Cursor info and position states.
        
        [mx, my] = GetMouse(window);           %Current mouse position.        
        cursorPointer = makeCursor(s, mx, my);          
        check1 = IsInRect(mx, my, o1);   %Determines if the cursor is inside the starting area.
        check2 = IsInRect(mx, my, o2);    %Determines if the cursor is inside the target area.

        
        
        %--     
        if trigger1 == false     %Trial logic.
            DrawFormattedText(window, 'Be as fast and accurate as possible!', 'center', 'center', 1);   
            if check1 == 1     %Start trigger.
            %     This statment's contents will trigger once after the
            %     paitent moves the cursor to the starting area. It will
            %     reset if a flase start or paitent mistake is detected,
            %     recording all of this.
                if taskWait == 0
                    taskWait = GetSecs;
                    paitentError = false;
                elseif GetSecs >= taskWait + validationTime
                    data.cursorStartPosition = [mx; my];
                    data.taskStartTime = GetSecs;
                    trigger1 = true;
                    check3 = frameCounter;
                    taskWait = 0;
                end
            elseif taskWait > 0
                    taskWait = 0;
                    paitentError = true;
                    inaccuracy = inaccuracy + 1;
            end
            
            
            
        else      
            if check1
                if trigger2 == true
                    repCounter = repCounter + 1;
                end
                trigger2 = false;
            elseif check2
                if trigger2 == false
                    repCounter = repCounter + 1;
                end
                trigger2 = true;
            end
            if repCounter == metadata.reps
                check4 = frameCounter;
                data.taskTargetTime = GetSecs;
                trigger3 = true;
            end
        end
        
        
        
        %--
        %Object drawing.
        
        if trigger1 == false
            if check1
                Screen('FillRect', window, s.colours(3,:), o1);
                
            else
                Screen('FillRect', window, s.colours(1,:), o1);
            end
        else
            if trigger2 == false
                Screen('FillRect', window, s.colours(3,:), o1);
                if check2
                    Screen('FillRect', window, s.colours(3,:), o2);
                else
                    Screen('FillRect', window, s.colours(1,:), o2);
                end
            else
                Screen('FillRect', window, s.colours(3,:), o2);
                if check1
                    Screen('FillRect', window, s.colours(3,:), o1);
                else
                    Screen('FillRect', window, s.colours(1,:), o1);
                end
            end
        end
        Screen('FillRect', window, s.colours(2,:), cursorPointer);
        
        
        
        %--
        %Frame finish! 
        %     From the start of the while look to here was less than 1/60
        %     seconds, computers are pretty fast it turns out. The while
        %     loop will only start again until after the vbl variable
        %     bellow triggers, which it's been told to only do until after
        %     1/60 seconds have passed since the last flip. PTB and MATLAB
        %     are pretty cool.

        vbl = Screen('Flip', window, vbl + s.creenFlipInterval);   %This is the command that finally tells the graphics card to draw the stimulous on the screen.
        positionPlot(frameCounter,:) =  [vbl - trialStartTime tabletRecievedTime mx my stylusPressue ...    %Here one can see all the important frame data being recorded with relevent recording time.
                                        trigger1 trigger2 check1 check2 paitentError];
        frameCounter =                  frameCounter + 1;             	%Counter!
    end

    

    %% Trial finish.
    
    %--
    %Distraction Text
    DrawFormattedText(window, 'Lift your pen and continue!', 'center', 'center', 1);   
    vbl = Screen('Flip', window, vbl + s.creenFlipInterval);   %This is the command that finally tells the graphics card to draw the stimulous on the screen.

    
    %--
    %Checks and Balences
    repCounter = 0;
    mostRecentCompleted = i;
    fprintf('\nTime taken:%8.4f seconds. \n', frameCounter/60)
    if size(positionPlot) < 10000
        positionPlot = matrixCutter(positionPlot);
        fprintf('Participant it taking exccedingly long. \n')
    end
    [data.peakVelocity, data.intention2move] = calcPeakVelocity(positionPlot(:, 1:s.tyle+1:4), check3, check4);
    fprintf('Inaccuracies:%2u in%2u trial(s). \n', inaccuracy, i)
    if data.intention2move < data.taskStartTime - trialStartTime
        fprintf('Of which one was a PREDICTIVE START this trial. \n')
    end
    
    
    %Includes inaccuracy, framcounter
    
    


    %--
    %Finalising data to save.
    
    if ~isempty(metadata.dataSaveDirectory)
        
        data.taskStartTime =            data.taskStartTime - trialStartTime;
        data.taskTargetTime =           data.taskTargetTime - trialStartTime;
        data.timeTaken =                data.taskTargetTime - data.taskStartTime;

        [starX, starY] =                RectCenter(o1);
        data.startingAreaPosition =     [starX; starY]; clear starX starY;
        data.startingAreaDimentions =   [o1(3) - o1(1); o1(4) - o1(2)];

        [tarX, tarY] =                  RectCenter(o2);
        data.targetAreaPosition =       [tarX; tarY];       clear tarX tarY;
        data.targetAreaDimentions =     [o2(3) - o2(1); o2(4) - o2(2)];
        data.targetArea =               o2;

        data.targetDistance =           data.targetAreaPosition - data.cursorStartPosition; 


        data.positionPlot =	array2table(                                                                    ...
                            positionPlot, 'VariableNames',                                                  ...
                            {'Time', 'TabletRecievedTime', 'CursorXpos', 'CursorYpos', 'StylusPressure',    ...
                            'StartTrial', 'EndTrial', 'IsInStart', 'IsInTarget', 'PaitentError'}           );

        %--
        %Processing
        %dataProcessing(variables)                

        %--
        %Save Data!
        if ~isempty(metadata.dataSaveDirectory) && metadata.savingOn
            filename = [metadata.preferedOrientation{blockData(1, 4)} '_' num2str(blockNumber) '.'];
            if i < 10
                filename = [filename '0'];
            end
            save([s.dataPath filesep filename num2str(i)], 'data');
        end
    end
    
    end
end    