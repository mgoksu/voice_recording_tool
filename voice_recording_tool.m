function varargout = voice_recording_tool(varargin)
% VOICE_RECORDING_TOOL MATLAB code for voice_recording_tool.fig
%      VOICE_RECORDING_TOOL, by itself, creates a new VOICE_RECORDING_TOOL or raises the existing
%      singleton*.
%
%      H = VOICE_RECORDING_TOOL returns the handle to a new VOICE_RECORDING_TOOL or the handle to
%      the existing singleton*.
%
%      VOICE_RECORDING_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOICE_RECORDING_TOOL.M with the given input arguments.
%
%      VOICE_RECORDING_TOOL('Property','Value',...) creates a new VOICE_RECORDING_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voice_recording_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voice_recording_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voice_recording_tool

% Last Modified by GUIDE v2.5 29-May-2018 11:44:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voice_recording_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @voice_recording_tool_OutputFcn, ...
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


% --- Executes just before voice_recording_tool is made visible.
function voice_recording_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voice_recording_tool (see VARARGIN)

% set the sample rate (Hz)
handles.Fs       = 48000;
% create the recorder
handles.recorder = audiorecorder(handles.Fs,16,1);

handles.counter = 1;
feature('DefaultCharacterSet','UTF-8');

set(handles.counter_info, 'String', ['Current counter: ', num2str(handles.counter)]);
set(handles.sentence_field, 'String', '');
set(handles.console, 'String', '');

% Choose default command line output for voice_recording_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voice_recording_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voice_recording_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Start_button.
function Start_button_Callback(hObject, eventdata, handles)
% hObject    handle to Start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

record(handles.recorder);
set(handles.console, 'String', 'Starts recording...');
disp('Starts recording...');
% guidata(hObject, handles);


% --- Executes on button press in Stop_button.
function Stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.recorder);
handles.y = getaudiodata(handles.recorder);
set(handles.console, 'String', 'Recording stopped.');
disp('Recording stopped.');
plot(handles.y);
% save file
filename = [handles.filename, '_', num2str(handles.counter), '.wav'];
audiowrite(filename, handles.y, handles.Fs);
set(handles.console, 'String', ['The record is saved to ', filename]);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Previous_button.
function Previous_button_Callback(hObject, eventdata, handles)
% hObject    handle to Previous_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter == 1
    handles.counter = 1;
else
    handles.counter = handles.counter - 1;
end

set(handles.counter_info, 'String', ['Current counter: ', num2str(handles.counter)]);
if isfield(handles,'text_data')
    set(handles.sentence_field, 'String', handles.text_data{1}{handles.counter});
end
guidata(hObject, handles);

% --- Executes on button press in Next_button.
function Next_button_Callback(hObject, eventdata, handles)
% hObject    handle to Next_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.counter = handles.counter + 1;
set(handles.counter_info, 'String', ['Current counter: ', num2str(handles.counter)]);
if isfield(handles,'text_data')
    set(handles.sentence_field, 'String', handles.text_data{1}{handles.counter});
end
guidata(hObject, handles);


% --- Executes on button press in Save_button.
function Save_button_Callback(hObject, eventdata, handles)
% hObject    handle to Save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = [handles.filename, '_', num2str(handles.counter), '.wav'];
audiowrite(filename, handles.y, handles.Fs);
set(handles.console, 'String', ['The record is saved to ', filename]);


% --- Executes on button press in Play_button.
function Play_button_Callback(hObject, eventdata, handles)
% hObject    handle to Play_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.y, handles.Fs);
set(handles.console, 'String', 'The record is being played now.');
guidata(hObject, handles);


% --- Executes on button press in Load_text_file.
function Load_text_file_Callback(hObject, eventdata, handles)
% hObject    handle to Load_text_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath]=uigetfile({'*.txt','All Files'}, 'Select a txt file');
handles.filename = filename;
set(handles.console, 'String', [filepath, filename, ' is loaded.']);
fileID = fopen([filepath, filename]);
handles.text_data = textscan(fileID, '%s',...
    'delimiter', '\n');
fclose(fileID);
handles.counter = 1;
set(handles.counter_info, 'String', ['Current counter: ', num2str(handles.counter)]);
set(handles.sentence_field, 'String', handles.text_data{1}{handles.counter});
guidata(hObject, handles);
