function varargout = GUI_MAIN(varargin)
%GUI_MAIN M-file for GUI_MAIN.fig
%      GUI_MAIN, by itself, creates a new GUI_MAIN or raises the existing
%      singleton*.
%
%      H = GUI_MAIN returns the handle to a new GUI_MAIN or the handle to
%      the existing singleton*.
%
%      GUI_MAIN('Property','Value',...) creates a new GUI_MAIN using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_MAIN_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_MAIN('CALLBACK') and GUI_MAIN('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_MAIN.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_MAIN

% Last Modified by GUIDE v2.5 24-Mar-2013 12:27:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_MAIN_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_MAIN_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before GUI_MAIN is made visible.
function GUI_MAIN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

%% add subfolders to serach path


%% GA PARAMS
gaParams.pause = false;
gaParams.nIndivid = 10;
gaParams.ratioParents = (1/3);
gaParams.numKeep = ceil(gaParams.nIndivid*gaParams.ratioParents);
gaParams.mutationRate = 0.10;
gaParams.maxIter = 120;
gaParams.stopCrit = 1*10^-9;
gaParams.nGenIdle = 10;
gaParams.costWeights = [1;0]; %do not have to sum to 1!
gaParams.boundBox = [-15,15,9];
%gaParams.boundBox = [-30.2,30,17.8];
gaParams.numDisplay = 6;

%ARBITRARY MESH WITH ARBITRARY LOAD
% gaParams.mesh = read_wobj('Truss2.obj');
% gaParams.fixed = [6 7 8 9];
% gaParams.loaded = [2];
% gaParams.forces = [0 -6 -10];

%I MAKE TRUSS MESH #1
% gaParams.mesh = read_wobj('Truss1.obj');
% gaParams.fixed = [6 7 8 9];
% gaParams.loaded = [2];
% gaParams.forces = [0 0 -10];

%BUILT TRUSS MESH
% gaParams.mesh = read_wobj('Truss3.obj');
% gaParams.fixed = [5 17 18 19];
% gaParams.loaded = [25];
% gaParams.forces = [0 0 -10];

%BOX TRUSS MESH
gaParams.mesh = read_wobj('boxTrussTemplate.obj');
gaParams.fixed = [1 2 3 4];
gaParams.loaded = [5];
gaParams.forces = [0 0 -10];

setappdata(hObject,'gaData',gaParams); %data for initPop() to run

%% GA POP/initPop()
[pop,figureH,figureT,plotData] = initPop(handles,'gaData');
set(figureH, 'Name','Generation 0','NumberTitle','off');
gaParams.pop = pop;
gaParams.genVec = plotData(1,:);
gaParams.minVec = plotData(2,:);
gaParams.figureH = figureH;

%% GA PLOT DATA
updateGAPlot(gaParams,handles,1.3);

% plot(handles.gaPlot_gen, gaParams.genVec,gaParams.minVec,'Marker','.');
% xlabel(handles.gaPlot_gen,'generation');
% ylabel(handles.gaPlot_gen,'min cost');
% title(handles.gaPlot_gen,'Minimum Cost per Generation');
% set(handles.gaPlot_gen,'XLim',[0,2],'YLim',[0,gaParams.minVec(1)*1.3]);

%% SET DATA
setappdata(hObject,'gaData',gaParams);
dispGAParams(gaParams,handles)
printGAParams(gaParams);

% Choose default command line output for GUI_MAIN
handles.output = hObject;
set(handles.pauseButton, 'Value', 0,'String','Pause');
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GUI_MAIN wait for user response (see UIRESUME)
% uiwait(handles.figure1)

function custom_closefcn(src,event)
% User-defined close request function 
% to display a question dialog box 
   selection = questdlg('Close This Figure?',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         delete(gcf)
      case 'No'
      return 
   end




function varargout = GUI_MAIN_OutputFcn(hObject, eventdata, handles)
% --- Outputs from this function are returned to the command line.
%
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in printButton.
function printButton_Callback(hObject, eventdata, handles)
% hObject    handle to printButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MTLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of printButton
gaProps = getappdata(handles.figure1,'gaData');
printGAParams(gaProps);


% --- Executes on button press in initPopButton.
function initPopButton_Callback(hObject, eventdata, handles)
% hObject    handle to initPopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gaParams = getappdata(handles.figure1,'gaData');
nIndivid = gaParams.nIndivid;
mesh = gaParams.mesh;
fixed = gaParams.fixed;
loaded = gaParams.loaded;
forces = gaParams.forces;
boundBox = gaParams.boundBox;
numDisplay = gaParams.numDisplay;

if(ishandle(gaParams.figureH))
    fprintf('closed figureH\n');
    close(gaParams.figureH);
else
    fprintf('no figure to close\n');
end

%delete(gaParams.plot);

[pop,figureH,figureT,plotData] = initPop(handles,'gaData');
gaParams.genVec = plotData(1,:);
gaParams.minVec = plotData(2,:);
gaParams.pop = pop;
gaParams.figureH = figureH;

updateGAPlot(gaParams,handles,1.3);

setappdata(handles.figure1, 'gaData', gaParams);


% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of runButton

%fprintf('buttonClick, runGA\n');
%GA_MAIN();
%testLoop(gaParams,handles)
gaParams = getappdata(handles.figure1,'gaData');
nGenIdle = gaParams.nGenIdle;
numDisplay = gaParams.numDisplay;
figureH = gaParams.figureH;

GA_LOOP(handles,gaParams,nGenIdle,numDisplay,figureH);






function popSize_Callback(hObject, eventdata, handles)
% hObject    handle to popSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of popSize as text
%        str2double(get(hObject,'String')) returns contents of popSize as a double
gaParams = getappdata(handles.figure1,'gaData');
mesh = gaParams.mesh;
fixed = gaParams.fixed;
loaded = gaParams.loaded;
forces = gaParams.forces;
boundBox = gaParams.boundBox;
numDisplay = gaParams.numDisplay;

gaParams.nIndivid = str2double(get(hObject,'String'));
gaParams.numKeep = ceil(gaParams.nIndivid*gaParams.ratioParents);
nIndivid = gaParams.nIndivid;

if(ishandle(gaParams.figureH))
    fprintf('closed figureH, -popSize\n');
    close(gaParams.figureH);
else
    fprintf('no figure to close, -popSize\n');
end
setappdata(handles.figure1,'gaData',gaParams);


[pop,figureH,figureT,plotData] = initPop(handles,'gaData');
gaParams.genVec = plotData(1,:);
gaParams.minVec = plotData(2,:);
gaParams.pop = pop;
gaParams.figureH = figureH;

setappdata(handles.figure1,'gaData',gaParams);

updateGAPlot(gaParams,handles,1.3);
dispGAParams(gaParams,handles)
printGAParams(gaParams);


% --- Executes during object creation, after setting all properties.
function popSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ratioParents_Callback(hObject, eventdata, handles)
% hObject    handle to ratioParents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratioParents as text
%        str2double(get(hObject,'String')) returns contents of ratioParents as a double
gaProps = getappdata(handles.figure1,'gaData');

gaProps.ratioParents = str2double(get(hObject,'String'));
gaProps.numKeep = ceil(gaProps.nIndivid*gaProps.ratioParents);

setappdata(handles.figure1,'gaData',gaProps);

dispGAParams(gaProps,handles)
printGAParams(getappdata(handles.figure1,'gaData'));



% --- Executes during object creation, after setting all properties.
function ratioParents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratioParents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numKeep_Callback(hObject, eventdata, handles)
% hObject    handle to numKeep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numKeep as text
%        str2double(get(hObject,'String')) returns contents of numKeep as a double
gaProps = getappdata(handles.figure1,'gaData');
gaProps.numKeep = str2double(get(hObject,'String'));
gaProps.ratioParents = gaProps.numKeep/gaProps.nIndivid;
setappdata(handles.figure1,'gaData',gaProps);
dispGAParams(gaProps,handles);



% --- Executes during object creation, after setting all properties.
function numKeep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numKeep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function printGAParams(gaParams)
fprintf('pause:%d\n',gaParams.pause);
fprintf('nIndivid: %d\n',gaParams.nIndivid)
fprintf('ratioParents: %1.2f\n',gaParams.ratioParents);
fprintf('numKeep: %d\n',gaParams.numKeep);
fprintf('muatationRate: %1.2f\n',gaParams.mutationRate);
fprintf('uWeight: %d, mWeight: %d\n',gaParams.costWeights(1), gaParams.costWeights(2));
fprintf('maxIter: %d\n', gaParams.maxIter);
fprintf('nGenIdle: %d\n\n',gaParams.nGenIdle);

function dispGAParams(gaParams,handles)
%dispGAParams(gaProps,handles)
%update display on UI
%input:
%   gaProps = appdata struct that contains GA properties
%   handles = GUI handles struct that contains buttons, text, etc.
set(handles.popSize,'String',gaParams.nIndivid);
set(handles.ratioParents,'String',gaParams.ratioParents);
set(handles.numKeep,'String',gaParams.numKeep);
set(handles.mutationRate,'String',gaParams.mutationRate);
set(handles.genIdle_editBox,'String',gaParams.nGenIdle);
set(handles.maxIter_editBox,'String',gaParams.maxIter);
set(handles.uWeight_editBox,'String',gaParams.costWeights(1));
set(handles.mWeight_editBox,'String',gaParams.costWeights(2));

function updateGAPlot(gaParams,handles,yMaxScale)
%update the plot that shows data about the GA
plot(handles.gaPlot_gen, gaParams.genVec,gaParams.minVec,'Marker','.');
xlabel(handles.gaPlot_gen,'generation');
ylabel(handles.gaPlot_gen,'min cost');
title(handles.gaPlot_gen,'Minimum Cost per Generation');
set(handles.gaPlot_gen,'XLim',[0,2],'YLim',[0,gaParams.minVec(1)*yMaxScale]);



function mutationRate_Callback(hObject, eventdata, handles)
% hObject    handle to mutationRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mutationRate as text
%        str2double(get(hObject,'String')) returns contents of mutationRate as a double
gaProps = getappdata(handles.figure1,'gaData');
gaProps.mutationRate = str2double(get(hObject,'String'));
setappdata(handles.figure1,'gaData',gaProps);
dispGAParams(gaProps,handles);
printGAParams(gaProps);



% --- Executes during object creation, after setting all properties.
function mutationRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mutationRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gaProps = getappdata(handles.figure1,'gaData');
gaProps.pause = ~gaProps.pause;
setappdata(handles.figure1,'gaData',gaProps);
state = get(hObject,'Value');
%fprintf('pauseButtonVal: %d',val);
if(state == 1)
    %pressed down
    set(hObject,'String','Resume');
else
    %un- pressed
    uiresume;
    set(hObject,'String','Pause');
end

printGAParams(gaProps);



function genIdle_editBox_Callback(hObject, eventdata, handles)
% hObject    handle to genIdle_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of genIdle_editBox as text
%        str2double(get(hObject,'String')) returns contents of genIdle_editBox as a double
gaParams = getappdata(handles.figure1,'gaData');
gaParams.nGenIdle = str2double(get(hObject,'String'));
setappdata(handles.figure1,'gaData',gaParams);
dispGAParams(gaParams,handles);
printGAParams(gaParams)


% --- Executes during object creation, after setting all properties.
function genIdle_editBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to genIdle_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxIter_editBox_Callback(hObject, eventdata, handles)
% hObject    handle to maxIter_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIter_editBox as text
%        str2double(get(hObject,'String')) returns contents of maxIter_editBox as a double
gaParams = getappdata(handles.figure1,'gaData');
gaParams.maxIter = str2double(get(hObject,'String'));
setappdata(handles.figure1,'gaData',gaParams);
dispGAParams(gaParams,handles);
printGAParams(gaParams);


% --- Executes during object creation, after setting all properties.
function maxIter_editBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIter_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uWeight_editBox_Callback(hObject, eventdata, handles)
% hObject    handle to uWeight_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uWeight_editBox as text
%        str2double(get(hObject,'String')) returns contents of uWeight_editBox as a double
gaParams = getappdata(handles.figure1,'gaData');
gaParams.costWeights(1) = str2double(get(hObject,'String'));
setappdata(handles.figure1,'gaData',gaParams);
dispGAParams(gaParams,handles);
printGAParams(gaParams);


% --- Executes during object creation, after setting all properties.
function uWeight_editBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uWeight_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mWeight_editBox_Callback(hObject, eventdata, handles)
% hObject    handle to mWeight_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mWeight_editBox as text
%        str2double(get(hObject,'String')) returns contents of mWeight_editBox as a double
gaParams = getappdata(handles.figure1,'gaData');
gaParams.costWeights(2) = str2double(get(hObject,'String'));
setappdata(handles.figure1,'gaData',gaParams);
dispGAParams(gaParams,handles);
printGAParams(gaParams);


% --- Executes during object creation, after setting all properties.
function mWeight_editBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mWeight_editBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
