%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理主程序
%作者：胡一浪
%功能：完成三种交通标志的识别
%版本：5.1
%时间：2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = base_FPGA_image_handle(varargin)
% BASE_FPGA_IMAGE_HANDLE MATLAB code for base_FPGA_image_handle.fig
%      BASE_FPGA_IMAGE_HANDLE, by itself, creates a new BASE_FPGA_IMAGE_HANDLE or raises the existing
%      singleton*.
%
%      H = BASE_FPGA_IMAGE_HANDLE returns the handle to a new BASE_FPGA_IMAGE_HANDLE or the handle to
%      the existing singleton*.
%
%      BASE_FPGA_IMAGE_HANDLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASE_FPGA_IMAGE_HANDLE.M with the given input arguments.
%
%      BASE_FPGA_IMAGE_HANDLE('Property','Value',...) creates a new BASE_FPGA_IMAGE_HANDLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before base_FPGA_image_handle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to base_FPGA_image_handle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help base_FPGA_image_handle

% Last Modified by GUIDE v2.5 20-Apr-2018 15:07:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @base_FPGA_image_handle_OpeningFcn, ...
                   'gui_OutputFcn',  @base_FPGA_image_handle_OutputFcn, ...
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


% --- Executes just before base_FPGA_image_handle is made visible.
function base_FPGA_image_handle_OpeningFcn(hObject, eventdata, handles, varargin)
    set(handles.start_button,'Enable','off');
    set(handles.stop_button,'Enable','off');
    setappdata(handles.Main,'continue_mode',0);
    %初始化变量
%     set(handles.stop_button,'Enable','off');%只有打开文件夹模式，启动和停止按钮才可以用
%     set(handles.start_button,'Enable','off');
%     setappdata(handles.Main,'run_mode',0);%1表示打开文件，2表示打开文件夹
%     setappdata(handles.Main,'continue_mode',0);%1表示运行，2表示停止
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to base_FPGA_image_handle (see VARARGIN)

% Choose default command line output for base_FPGA_image_handle
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes base_FPGA_image_handle wait for user response (see UIRESUME)
% uiwait(handles.Main);


% --- Outputs from this function are returned to the command line.
function varargout = base_FPGA_image_handle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function my_open_file_Callback(hObject, eventdata, handles)
    %初始化变量
%     set(handles.stop_button,'Enable','off');%只有打开文件夹模式，启动和停止按钮才可以用
%     set(handles.start_button,'Enable','off');
    setappdata(handles.Main,'continue_mode',0);
    %提取原图
    [filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png;*.jpeg', 'Image Files (*.bmp, *.jpg, *.png,*.jpeg)'; '*.*', 'All Files (*.*)'},'选择一张图片');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    fpath=[pathname filename];
    t1=clock;%识别一张计时
    img_src=imread(fpath);
    %图像处理
    RGB_extract_basic(img_src,handles);
    disp(['etime程序读取单个图片运行时间：',num2str(etime(clock,t1))]);
% hObject    handle to my_open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function my_open_folder_Callback(hObject, eventdata, handles)
    setappdata(handles.Main,'continue_mode',0);
    [filename, pathname] = uigetfile('C:*.jpg','选择图片文件夹');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    setappdata(handles.Main,'continue_mode',1);
    set(handles.start_button,'Enable','off');
    set(handles.stop_button,'Enable','on');
    
    while(1)
        continue_mode = getappdata(handles.Main,'continue_mode');
        if(continue_mode == 0)
            return;
        end
        image = read_newest_jpg(pathname);%输出一张最新生成合理的有效的图片
        RGB_extract_basic(image,handles);%图像处理
        fprintf('%s\n','处理了一张图片');
    end
% hObject    handle to my_open_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function my_close_Callback(hObject, eventdata, handles)
    setappdata(handles.Main,'continue_mode',0);
    close(handles.Main);
% hObject    handle to my_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in start_button.
% function start_button_Callback(hObject, eventdata, handles)
%     setappdata(handles.Main,'continue_mode',1);%1表示运行，2表示停止
%     set(handles.start_button,'Enable','off');
%     set(handles.stop_button,'Enable','on');
%     feval(@my_open_folder_Callback,handles.my_open_folder,eventdata,handles);
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_button.
% function stop_button_Callback(hObject, eventdata, handles)
%     setappdata(handles.Main,'continue_mode',2);%1表示运行，2表示停止
%     set(handles.stop_button,'Enable','off');
%     set(handles.start_button,'Enable','on');
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
    set(handles.start_button,'Enable','off');
    set(handles.stop_button,'Enable','on');
    feval(@my_open_folder_Callback,handles.my_open_folder,eventdata, handles);
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
    set(handles.start_button,'Enable','on');
    set(handles.stop_button,'Enable','off');
    setappdata(handles.Main,'continue_mode',0);
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
