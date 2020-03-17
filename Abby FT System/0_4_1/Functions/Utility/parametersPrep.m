function [metadata, blockData, s] = parametersPrep(metadata, s)
%MANIPULATEMETADATA Processing of metadata.
% 
%     Takes in neumerical aspects of metadata and returns string arrays in
%     their place. Some values are exempt from this, such as
%     'metadata.style', as their values are used throughout the script
%     'main.m'.
% 
%     Preconditions: An input of unfiltered metadata structure.
%
%     Postconditions: An output of corrected metadata structure. An output
%     of a partially filled blockData to be used in this trial (see
%     mannuel). A variable "choosen style" used later in the script.

%--
%Variable assignment.

s.ourceID = 1;
% if (metadata.sessionNum < 10 || str2double(metadata.sessionNum) < 10) && length(metadata.sessionNum) == 1%Session Number
% %Add a '0' to the front of single digit session numbers, this makes
% %indexing saved files easier. :)
%     metadata.sessionNum = ['0' num2str(metadata.sessionNum )];
% else
%     metadata.sessionNum = num2str(metadata.sessionNum);
% end
%               From the programmer: I'm pretty sure this isn't needed, but
%               I've left it in just in case. If you're having issues with
%               how the directories are being named it might help to
%               uncomment this section.

if metadata.inputType == 1 %Input
    metadata.inputType = 'Tablet';
else
    metadata.inputType = 'Pendulum';
end

%--
if isempty(metadata.importDir)  %Creation of blockData
    s.tyle = metadata.trialStyle;
    blockData = NaN(metadata.numTrials + 1, 11);
    blockData(1, 1:7) = [metadata.numTrials metadata.touchType 1 1 metadata.ID metadata.startPos s.tyle];        
    if metadata.startPos == 1
        blockData(2:metadata.numTrials + 1, 7) = ones(metadata.numTrials, 1);        
    elseif metadata.startPos == 2
        blockData(2:metadata.numTrials + 1, 7) = ones(metadata.numTrials, 1) + 1;
    else
        rng('shuffle');                     %Re-seeds RNG to ensure pseduo-randomness. 
                                            %Potential exception with older versions of MATLAB, use rng('seed') with older machines. Raise exception here and change the phrase automatically? 
                                            %__Review.__
        randomStartingPositions = randi(2, metadata.numTrials, 1);
        blockData(2:metadata.numTrials + 1, 7) = randomStartingPositions; clear randomStartingPositions
    end
    for i = 2:metadata.numTrials + 1
        blockData(i, 8:11) = makeStart(s, blockData(i, 7));
        blockData(i, 1:6)  = makeTarget(s, blockData(i, 8:11), [NaN NaN blockData(i, 7) metadata.ID metadata.touchType]);
    end
else                            %Importation of blockData
    load(metadata.importDir);
    s.tyle = blockData(1, 6);
    for i = 2:metadata.numTrials
        blockData(i, 8:11) = makeStart(s, blockData(i, 7));
    end
    metadata.numTrials = blockData(1, 1);
    metadata.startPos = blockData(1, 7);
    metadata.ID = blockData(1, 5);

    if metadata.randomisedOrder == 1
        blockData = blockData([1 randperm(blockData(1, 1)) + 1],:);
    end

end

%--
%Metadata reassignment.

touchType = {'Discrete', 'Reciprocal'};
metadata.touchType = {metadata.touchType, touchType{metadata.touchType}}; clear touchType
styles = {'S-S', 'T-B', '2D'};
metadata.trialStyle = styles{blockData(1, 2)}; clear styles
startPosition = {'Default', 'Secondary', 'Varied'};
%metadata.startPos = startPosition{blockData(1, 5)}; clear startPosition
state = {'No', 'Yes'};
metadata.highContrast = state{metadata.highContrast + 1};
metadata.restsOn = state{metadata.restsOn + 1}; clear state
rmfield(s, 'ourceID')


