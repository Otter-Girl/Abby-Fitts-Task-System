%--
%Setup

function varargout = control(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @control_OpeningFcn, ...
                   'gui_OutputFcn',  @control_OutputFcn, ...
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

function control_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for control
handles.output = hObject;

load('metadata.mat');
[handles.metadata] = metadata;

set(handles.text_listbox, 'Value', handles.metadata.textSize);
set(handles.contrastMode_checkbox, 'Value', handles.metadata.highContrast);
set(handles.colour_listbox, 'Value', handles.metadata.colourMode);
set(handles.directory_edit, 'String', handles.metadata.dataSaveDirectory);
set(handles.numBlocks_edit, 'string', num2str(handles.metadata.numBlocks));
if strcmp(handles.metadata.preferedOrientation{1}, 'Hor')
   set(handles.horizontal_radiobutton, 'Value', 1); 
end
if handles.metadata.inputType == 2
    set(handles.pendulum_radiobutton, 'Value', 1);
end
if handles.metadata.touchType == 2
    set(handles.continuous_radiobutton, 'Value', 1);
end    

guidata(hObject, handles);
% uiwait(handles.figure1);

function varargout = control_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function figure1_CloseRequestFcn(hObject, eventdata, handles)
metadata = handles.metadata;
save metadata.mat metadata
delete(hObject);


%--
%Accessibility uipannel


function ToParameters_pushbutton_Callback(hObject, eventdata, handles)
metadata = handles.metadata;
save metadata.mat metadata
closereq;
Parameters;

function text_listbox_Callback(hObject, eventdata, handles)
handles.metadata.textSize = get(handles.text_listbox, 'Value');
guidata(hObject, handles);

function colour_listbox_Callback(hObject, eventdata, handles)
handles.metadata.colourMode = get(handles.colour_listbox, 'Value');
guidata(hObject, handles);

function contrastMode_checkbox_Callback(hObject, eventdata, handles)
handles.metadata.highContrast = get(handles.contrastMode_checkbox, 'Value');
guidata(hObject, handles);

function readout_checkbox_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

%--
%Saved Data uipannel

function directory_edit_Callback(hObject, eventdata, handles)
if isempty(get(hObject, 'String'))
    set(hObject,'String','Saving disabled');
    handles.metadata.dataSaveDirectory = ''
else 
    handles.metadata.dataSaveDirectory = get(hObject, 'String');
end
guidata(hObject, handles);

function changeDirectory_pushbutton_Callback(hObject, eventdata, handles)
dir = uigetdir;
if dir == 0
    set(handles.directory_edit, 'string', 'Saving Disabled');
    handles.metadata.dataSaveDirectory = '';
else
    set(handles.directory_edit, 'string', dir);
    handles.metadata.dataSaveDirectory = dir;
end
guidata(hObject, handles);

function viewData_pushbutton_Callback(hObject, eventdata, handles)
explorer(handles.metadata.dataSaveDirectory)


%--
%Block Options uipannel

function numBlocks_edit_Callback(hObject, eventdata, handles)
handles.metadata.numBlocks = str2double(get(hObject, 'string'));
guidata(hObject, handles);

function vertical_radiobutton_Callback(hObject, eventdata, handles)
handles.metadata.preferedOrientation = {'Vert', 'Hor'};
guidata(hObject, handles);

function horizontal_radiobutton_Callback(hObject, eventdata, handles)
handles.metadata.preferedOrientation = {'Hor', 'Vert'};
guidata(hObject, handles);

function discrete_radiobutton_Callback(hObject, eventdata, handles)
handles.metadata.touchType = 1;
guidata(hObject, handles);

function continuous_radiobutton_Callback(hObject, eventdata, handles)
handles.metadata.touchType = 2;
guidata(hObject, handles);

%--
%Input type uibuttongroup

function touch_radiobutton_Callback(hObject, eventdata, handles)
handles.metadata.inputType = 1;
guidata(hObject, handles);

function pendulum_radiobutton_Callback(hObject, eventdata, handles)
handles.metadata.inputType = 2;
guidata(hObject, handles);


%--
%"Create Function" functions


function text_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function colour_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function numBlocks_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function directory_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
