function blockMaker(blockData, filename)
%BLOCKMAKER Makes a blockData file.
%     Makes a blockData file from an incomplete blockData file. This is not
%     a universal function and connot turn any set of data into a block
%     maker file.
%     Please refer to your user manuel.
% 
%     Preconditions: A blockdata template in matrix or file format and the
%     desired name for the output file.
%     Current supported file types include excel files and text files.
% 
%     Postconditions: No returns. A filled blockData file saved to
%     homefolder/SessionImport/'yourFilename'.mat

%% --
%Setup

%--
%Read from file.

if ~isnumeric(blockData)
    if contains(blockData, '.xl')
            [~, ~, blockData] = xlsread(blockData);
    elseif contains(blockData, '.txt' ) || contains(blockData, '.rtf') || contains(blockData, '.tex') || contains(blockData, '.doc')
            blockData = dlmread(blockData); clear fileID formatSpec
%     elseif 
%             fileID = fopen(blockData, 'r');
%             formatSpec = '%f';
%             blockData = fscanf(fileID, formatSpec);
%     elseif 
%             fileID = fopen(blockData, 'r');
%             formatSpec = '%f';
%             blockData = fscanf(fileID, formatSpec);
%     elseif 
%             fileID = fopen(blockData, 'r');
%             formatSpec = '%f';
%             blockData = fscanf(fileID, formatSpec);
    else
            error('Please enter an allowable format. \n')
    end
end



%--
%Allocation


%% --
%Missing/Incorrect Data Checks
%--

warning = [];

%--
%Checks the number of trials available

e1 = [];

if isnan(blockData{1, 1})
    e1 = 'No numTrials entered.';
% elseif ~isdouble(blockData{1, 1}) 
%     e1 = 'NumTrials is not an integer.';
elseif blockData{1, 1} ~= size(blockData, 1) - 1
    e1 = 'NumTrials does not match the number of trial rows.';
end
if ~isempty(e1)
    answer = questdlg(['Abby encountered the issue: ' e1 '/s/nThe number of trial rows in your block is ' num2str(size(blockData, 1) - 1) './s/nWould you like to use this number?'], 'Missing numTrials', 'Yes', "No, I'll fix the issue myself.", "No, I'll fix the issue myself.");
    switch answer
        case 'Yes'
            blockData{1, 1} = size(blockData, 1) - 1;
        case "No, I'll fix the issue myself."
            if strcmp(e1, 'NumTrials does not match the number of trial rows.')
                answer = questdlg(["You entered '" num2str(blockData{1, 1}) "' number of trials./s/n Would you like to change the block matrix to have " num2str(blockData{1, 1}) " active rows?/s/n (" num2str(blockData{1, 1 + 1}) " rows total.)"], 'Yes', 'No, this requires human finecce!', 'No, this requires human finecce!');
                switch answer
                    case 'Yes'
                        blockData = blockData(1:blockData{1, 1} + 1,:);
                        e1_1 = true;
                    otherwise
                        e1_1 = false;
                end
            end
            if e1_1
                return
            end
            e.identifier = 'MATLAB:Abby:BlockMakerNumTrials';
            e.message = 'User ended blockMaker.m over bad numTrials';
            e.cause = {e1};
            error(e);
        otherwise
            e.identifier = 'MATLAB:Abby:BlockMakerNumTrials';
            e.message = 'blockMaker.m cancled by user';
            e.cause = {e1};
            error(e);
    end
end
clear e1

%blockData{1, 1}= checkNumTrials(blockData{1, 1}, size(blockData, 1) - 1);

%--
%Checks the horizontal size of the matrix. 
%     Must be done after checking that the number of trials corrolates
%     correctly to the number of active rows in the matrix.

if size(blockData, 2) ~= 11
   rem = 11 - size(blockData, 2);
   blockData = [blockData NaN(blockData{1, 1} + 1, rem)];
   try
       mustBePositive(rem)
       
   catch
       blockData = blockData(1:11, :);
   end
end


%--
%Checks that a block type is available.

% e2 = [];
% 
% if isnan(blockData{1, 2})
%     warning = [warning 'You have no input for the block type (either discrete or reciprocal)'];
% elseif ~strcmpi(blockData{1, 2}, 'discrete') || ~strcmpi(blockData{1, 2}, 'reciprocal')
%     warning = [warning 'You have an invalid input for the block type (either discrete or reciprocal)'];
% elseif ~strcmp(blockData{1, 2}, 'discrete') || ~strcmp(blockData{1, 2}, 'reciprocal')
%     blockData{1, 2} = lower(blockData{1, 2});
% end



%% -- 
%Block creation and data fill!

%--
%Get Screen Data

s.ourceID = 2;
screens = Screen('Screens');                                    %an array [0 1 2 ... n] who's max is the number of available screens (with zero being the entire availble space). Edit outside of MATLAB.
screenNumber =  1;                                              %max(screens); %getpreference(screens)
                clear screens;
Screen('Preference', 'SkipSyncTests', 1)
[window] =  PsychImaging ...                                    %This is our digital window where the paitent will see the Fits Task.
            ('OpenWindow', screenNumber, 0);  %, s.colours(4,:)
            clear screenNumber; 
[s.creenXpix, s.creenYpix] = Screen('WindowSize', window);
%Relative to starting position
sca;

%Fill important missing fields

s.tyle = blockData{1, 6};
if isnan(s.tyle)
    s.tyle = 1;
end

%ObjectID calculation

for i = 2:blockData{1, 1} + 1
    area1Ident  = makeStart(s, blockData{i, 7}, blockData{1, 2});
    [blockData{i, 8}, blockData{i, 8}, blockData{i, 10}, blockData{i, 11}] = area1Ident; %[area1Ident(1) area1Ident(2) area1Ident(3) area1Ident(4)];
    blockData{i, 1:4}   = makeTarget(s, [blockData{i, 5:7} NaN blockData{1, 2}]);
end






if ~isempty(warning)
    
end

%% -- 
%Cleanup/Warnings/Checks
clear warning i
save filename blockData
cd ..

function numTrials = checkNumTrials(numTrials, sizeBlockData)
% CHECKNUMTRIALS Asks the user to correct a numTrials mistake.
% 
% Asks the user to correct a conflict between the entered "number of
% trials" and the "size of the block matrix - 1"—"size of the block matrix
% - 1" being the number of trials that Abby will play givne then amount of
% complete, available data.
% 
% Preconditions: Blockdata.
% 
% Postconditions: A better blockdata (hopefully).

