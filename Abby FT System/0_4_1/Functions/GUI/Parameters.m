%PARAMATERS Controls the Paramaters window, the main interface for the Abby
%system.
%   This function houses the logic for Paramaters.fig. Paramaters is the
%   interfact between the user and the Abby system. This script controls
%   what data is sent to the Abby system using the 'metadata.mat' file.
%   When the user interacts with the GUI they are in effect editing
%   metadata.mat. 
% 
%   Abby suggests you read the user manual for for information and also
%   take a look at the saved metadata.mat variable in the MATLAB inteface.
%
%   For more information on MATLAB GUI use the 'help GUIDE' command for
%   further reading.
%
%   Preconditions: metadata.mat and programdata.mat
%
%   Postconditions: The Paramaters GUI and a dynamically updated
%   metadata.mat.



%--
%Setup
%     The first four of the functions relate the to figure (GUI) itself and
%     the window is resides in. As per MATLAB instructions, do not edit the
%     first.
function varargout = Parameters(varargin)
% PARAMETERS MATLAB code for Parameters.fig
%      PARAMETERS, by itself, creates a new PARAMETERS or raises the existing
%      singleton*.
%
%      H = PARAMETERS returns the handle to a new PARAMETERS or the handle to
%      the existing singleton*.
%
%      PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERS.M with the given input arguments.
%
%      PARAMETERS('Property','Value',...) creates a new PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Parameters

% Last Modified by GUIDE v2.5 02-Aug-2018 10:31:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @Parameters_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function Parameters_OpeningFcn(hObject, eventdata, handles, varargin)   %Paramaters_OpeningFnc is essential for re-loading Paramaters after is has been closed. Paramaters_OpeningFcn
handles.output = hObject;

currentDate = date;
load('programdata.mat')
load('metadata.mat');
[handles.programData] = programData;
[handles.metadata] = metadata;
if handles.metadata.date == currentDate
    set(handles.session_edit, 'string', handles.metadata.sessionID);
else
    handles.metadata.sessionID = '01';
    handles.metadata.date = currentDate;
end

%set(textsize, etc)
%set(contrast, etc)
%set(colourmode, etc)
%set(date, etc)
%set(input, etc)
%set(touch, etc)

if isempty(metadata.importDir)
    if ~ischar(metadata.numTrials)
        set(handles.trials_edit, 'string', metadata.numTrials)
    else
        set(handles.trials_edit, 'string', '0')
    end
    set(handles.style_popupmenu, 'value', metadata.trialStyle)
    if ischar(metadata.ID)
        set(handles.ID_slider, 'value', get(handles.ID_slider,'Min'))
        set(handles.ID_edit, 'string', 'ID')
    else
        set(handles.ID_slider, 'value', metadata.ID)
        set(handles.ID_edit, 'string', metadata.ID)
    end
    set(handles.startPos_popupmenu, 'value', metadata.startPos)
else
    set(handles.trials_edit, 'string', '-')
    set(handles.style_popupmenu, 'value', 1)
    set(handles.ID_slider, 'value', get(handles.ID_slider,'Min'))
    set(handles.ID_edit, 'string', 'Importing session')
    set(handles.import_checkbox, 'value', 1)
    set(handles.startPos_popupmenu, 'value', 1)
    set(handles.import_pushbutton, 'enable', 'on')
end

set(handles.tutorial_checkbox, 'value', metadata.tutorialOn)
set(handles.session_edit, 'string', metadata.sessionID)
set(handles.participantID_edit, 'string', metadata.participantID)

savedConditions = ls('SessionImport\*.mat');
if isempty(savedConditions)
    savedConditions = 'No import files found!'
end
set(handles.import_popupmenu, 'string', savedConditions);

guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = Parameters_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function figure1_CloseRequestFcn(hObject, eventdata, handles)
metadata = handles.metadata;
save metadata.mat metadata
delete(hObject);



%--
%Buttons
%     These button do pretty significant things so I left them at the top
%     to themselves.
function toControl_pushbutton_Callback(hObject, eventdata, handles)
metadata = handles.metadata;
save metadata.mat metadata
closereq
control

function go_pushbutton_Callback(hObject, eventdata, handles)

%Pre-execution error handling.
metadata = handles.metadata;
programData = handles.programData;
if get(handles.import_checkbox, 'value') == 1 && isempty(metadata.importDir)
    errordlg('We have no session to run! Import a session to GUI with the pushbutton first.', 'No Session')
    error('MATLAB:Abby:NoSession', 'Import a session.')
end
%gui_error(metadata)
newParticipant = true;
while newParticipant
    for i = 1: size(programData.participantlist, 1)
        if contains(programData.participantlist(i,:), metadata.participantID)
            list = ls(strcat("Data\Participant_", metadata.participantID));
            for i = 1:size(list, 1)
                if contains(list(i, :), metadata.sessionID)
                    answer = questdlg(  ["Participant with ID:" metadata.participantID "Already has a session called:" metadata.sessionID "In your data folder, this session may be replaced. Would you like to continue?"], ...
                                        "Duplicate Name Warning.");
                    switch answer
                        case 'Yes'
                        otherwise
                            error("Session Cancled.");
                    end
                end
                break
            end
            newParticipant = false;
        end
    end
	programData.participantlist = [programData.participantlist; metadata.participantID];
	programData.uniqueParticipants = size(programData.participantlist(1));
end



%Main file and then cleanup.
save metadata.mat metadata
try
    main;
catch
    sca;
    psychrethrow(psychlasterror);
end
save programdata.mat programData                        %Will only save if a full session is run without issue.
set(handles.comment_edit, 'Enable', 'inactive');
set(handles.comment_edit, 'string', 'Comment Box...');
handles.metadata.commentBox = {'no comment'};
savedConditions = ls('SessionImport\*.mat');
set(handles.import_popupmenu, 'string', savedConditions);
guidata(hObject, handles);



%-- 
%Simple-setup and comment box.
%     First uipannel and the comment box callbacks.
function comment_edit_Callback(hObject, eventdata, handles)
handles.metadata.commentBox = cellstr(get(handles.comment_edit, 'String'));
guidata(hObject, handles);

function comment_edit_ButtonDownFcn(hObject, eventdata, handles)
set(hObject, 'string', '');
set(hObject, 'Enable', 'On');
uicontrol(hObject);
guidata(hObject, handles);

function trials_edit_Callback(hObject, eventdata, handles)
if isnan(str2double(get(hObject, 'string')))
    set(hObject, 'string', 'invalid') 
    handles.metadata.numTrials = get(handles.trials_edit, 'String');
else
    handles.metadata.numTrials = str2double(get(handles.trials_edit, 'String'));
end
guidata(hObject, handles);

function style_popupmenu_Callback(hObject, eventdata, handles)
handles.metadata.trialStyle = get(handles.style_popupmenu, 'Value');
guidata(hObject, handles);

function ID_slider_Callback(hObject, eventdata, handles)
handles.metadata.ID = get(handles.ID_slider, 'value');
set(handles.ID_edit, 'string', get(handles.ID_slider, 'value'));
guidata(hObject, handles);

function ID_edit_Callback(hObject, eventdata, handles)
number = str2double(get(hObject, 'string'));
if number < 1 || number > 7 || isnan(number)
    message = 'Your entry is outside the possible ID range';
    if isnan(str2double(get(hObject, 'string')))
        message = [message ' and is not a number'];
    end
    message = [message ', please make an entry between 1 and 7.'];
    warndlg(message, 'Index of Difficulty');
    set(handles.ID_slider, 'value', get(handles.ID_slider, 'min'))
    set(handles.ID_edit, 'string', 'error')
    handles.metadata.ID = get(handles.ID_edit, 'string');
else
    set(handles.ID_slider, 'value', str2double(get(hObject, 'string')));
    handles.metadata.ID = get(handles.ID_slider, 'value');
end
guidata(hObject, handles);

function startPos_popupmenu_Callback(hObject, eventdata, handles)
handles.metadata.startPos = get(handles.startPos_popupmenu, 'Value');
guidata(hObject, handles);

function exampleSave_checkbox_Callback(hObject, eventdata, handles)
if get(hObject, 'value')
    handles.metadata.savingOn = true;
else
    handles.metadata.savingOn= false;
end
guidata(hObject, handles);


%--
%Experiement set-up
%     Second uipannel and import option callbacks.
function import_checkbox_Callback(hObject, eventdata, handles)
if get(hObject, 'value')
    set(handles.trials_edit, 'string', '-');
    set(handles.style_popupmenu, 'value', 1);
    set(handles.ID_slider, 'value', get(handles.ID_slider,'Min'));
    set(handles.ID_edit, 'string', 'Importing session');
    set(handles.startPos_popupmenu, 'value', 1);
    handles.metadata.importDir = 'None Selected';
    set(handles.trials_edit, 'enable', 'inactive');
    set(handles.style_popupmenu, 'enable', 'inactive');
    set(handles.ID_slider, 'enable', 'inactive');
    set(handles.ID_edit, 'enable', 'inactive');
    set(handles.startPos_popupmenu, 'enable', 'inactive');
    set(handles.import_popupmenu, 'enable', 'on');
    set(handles.import_pushbutton, 'enable', 'on');
    set(handles.randomisedOrder_checkbox, 'enable', 'on');
    handles.metadata.savingOn = true;
    savedConditions = ls('SessionImport\*.mat');
    if isempty(savedConditions)
        savedConditions = 'No import files found!'
    end
    set(handles.import_popupmenu, 'string', savedConditions);
else
    set(handles.trials_edit, 'string', 8);
    set(handles.style_popupmenu, 'value', 2);
    set(handles.ID_slider, 'value', 3);
    set(handles.ID_edit, 'string', 3);
    set(handles.startPos_popupmenu, 'value', 2);
    handles.metadata.importDir = '';
    set(handles.trials_edit, 'enable', 'on');
    set(handles.style_popupmenu, 'enable', 'on');
    set(handles.ID_slider, 'enable', 'on');
    set(handles.ID_edit, 'enable', 'on');
    set(handles.startPos_popupmenu, 'enable', 'on');
    set(handles.import_popupmenu, 'enable', 'off');
    set(handles.import_popupmenu, 'string', 'Importing Disabled');
    set(handles.import_popupmenu, 'value', 1);
    set(handles.import_pushbutton, 'enable', 'off');
    set(handles.randomisedOrder_checkbox, 'enable', 'inactive');
    set(handles.randomisedOrder_checkbox, 'value', 0);
    handles.metadata.savingOn= false;
end
guidata(hObject, handles);

function import_popupmenu_Callback(hObject, eventdata, handles)
filesAvail = get(hObject, 'String');
handles.metadata.importDir = fullfile(handles.programData.homefolder, 'SessionImport', filesAvail(get(hObject, 'Value'),:));
set(hObject, 'Enable', 'inactive');
guidata(hObject, handles);

function import_pushbutton_Callback(hObject, eventdata, handles)
try
    load(handles.metadata.importDir);
catch
    warndlg("No file found. Make sure you click on the option while in the dropdown menu.")
    error("No file selected.")
end
import_error(blockData)
set(handles.trials_edit, 'string', num2str(blockData(1, 1)));
set(handles.style_popupmenu, 'value', blockData(1, 6));
IDs = NaN(1, blockData(1,1));
for i = 1:blockData(1,1)
    IDs(i) = log2((2*blockData(i+1, 5))/blockData(i+1, 6));
end
set(handles.ID_slider, 'value', get(handles.ID_slider, 'min'));
set(handles.ID_edit, 'string', num2str(IDs));
set(handles.startPos_popupmenu, 'value', blockData(1, 7));
guidata(hObject, handles);

function importPath_pushbutton_Callback(hObject, eventdata, handles)
explorer(fullfile(handles.programData.homefolder, 'SessionImport'));

function randomisedOrder_checkbox_Callback(hObject, eventdata, handles)
handles.metadata.randomisedOrder = get(handles.randomisedOrder_checkbox, 'value');
guidata(hObject, handles);

%functions here to initialize the import
%     include things here like exceptions to scan the imported document to
%     see if it have to correct number of trials and the right size matirx,
%     etc etc.



%--
%Participant options
%     Options for the participant and clerical inputs.
function tutorial_checkbox_Callback(hObject, eventdata, handles)
handles.metadata.tutorialOn = get(handles.tutorial_checkbox, 'Value');
guidata(hObject, handles);

function participantID_edit_Callback(hObject, eventdata, handles)
ID = str2double(get(handles.participantID_edit, 'String'));
if ID < 10
    handles.metadata.participantID = ['0' num2str(ID)];
else
    handles.metadata.participantID = num2str(ID);
end
guidata(hObject, handles);

function session_edit_Callback(hObject, eventdata, handles)
sess = str2double(get(handles.session_edit, 'String'));
if isnan(sess)
    handles.metadata.sessionID = get(handles.session_edit, 'String');
    warning("A non-numeric session number entered. This will not prevent Abby from running.")
else
    if sess < 10
        handles.metadata.sessionID = ['0' num2str(sess)];
    else
        handles.metadata.sessionID = num2str(sess);
    end
end
guidata(hObject, handles);

function orientation_checkbox_Callback(hObject, eventdata, handles)
handles.metadata.orientationChange = get(handles.orientation_checkbox, 'value');
guidata(hObject, handles);

function styleChange_checkbox_Callback(hObject, eventdata, handles)
handles.metadata.styleChange = get(handles.styleChange_checkbox, 'value');
guidata(hObject, handles);



%--
%"Create Function" functions.
%     These functions are called when the object in question is first
%     created. In Abby they have no special purpose, they must remain
%     intact for the GUI to function properly.
function comment_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trials_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function style_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ID_slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ID_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function startPos_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function import_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function import_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function participantID_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function session_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
