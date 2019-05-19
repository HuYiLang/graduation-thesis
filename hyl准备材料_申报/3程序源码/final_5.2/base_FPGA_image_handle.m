%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ����������
%���ߣ���һ��
%���ܣ�������ֽ�ͨ��־��ʶ��
%�汾��5.1
%ʱ�䣺2018/4/23
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
    %��ʼ������
%     set(handles.stop_button,'Enable','off');%ֻ�д��ļ���ģʽ��������ֹͣ��ť�ſ�����
%     set(handles.start_button,'Enable','off');
%     setappdata(handles.Main,'run_mode',0);%1��ʾ���ļ���2��ʾ���ļ���
%     setappdata(handles.Main,'continue_mode',0);%1��ʾ���У�2��ʾֹͣ
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
    %��ʼ������
%     set(handles.stop_button,'Enable','off');%ֻ�д��ļ���ģʽ��������ֹͣ��ť�ſ�����
%     set(handles.start_button,'Enable','off');
    setappdata(handles.Main,'continue_mode',0);
    %��ȡԭͼ
    [filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png;*.jpeg', 'Image Files (*.bmp, *.jpg, *.png,*.jpeg)'; '*.*', 'All Files (*.*)'},'ѡ��һ��ͼƬ');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    fpath=[pathname filename];
    t1=clock;%ʶ��һ�ż�ʱ
    img_src=imread(fpath);
    %ͼ����
    RGB_extract_basic(img_src,handles);
    disp(['etime�����ȡ����ͼƬ����ʱ�䣺',num2str(etime(clock,t1))]);
% hObject    handle to my_open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function my_open_folder_Callback(hObject, eventdata, handles)
    setappdata(handles.Main,'continue_mode',0);
    [filename, pathname] = uigetfile('C:*.jpg','ѡ��ͼƬ�ļ���');
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
        image = read_newest_jpg(pathname);%���һ���������ɺ������Ч��ͼƬ
        RGB_extract_basic(image,handles);%ͼ����
        fprintf('%s\n','������һ��ͼƬ');
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
%     setappdata(handles.Main,'continue_mode',1);%1��ʾ���У�2��ʾֹͣ
%     set(handles.start_button,'Enable','off');
%     set(handles.stop_button,'Enable','on');
%     feval(@my_open_folder_Callback,handles.my_open_folder,eventdata,handles);
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stop_button.
% function stop_button_Callback(hObject, eventdata, handles)
%     setappdata(handles.Main,'continue_mode',2);%1��ʾ���У�2��ʾֹͣ
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
