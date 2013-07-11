function define_txtfileContent(handles)
%function enables user to select content of output txt file

%get variables to export => those in listboxes of plotXY fig
h_listbox = findobj(handles.plotXY_panel,'style','listbox');
listbox_str = get(h_listbox,'string');
varList=vertcat(listbox_str{:});
varList=flipud(varList); %in list order same as tab order of the listboxes

path2folder_outputs = handles.path2folder_outputs;

%=> create figure with uicontrols to define content of tab delimited file
default_sze = [560, 528, 560, 420];
resize_factor = [0.5, 1, 2, 1];
figure('position',default_sze.*resize_factor);
w=get(gcf,'position');

%.center img on screen
movegui(gcf,'center')

%.hide toolbar
set(gcf, 'menubar', 'none');

px = 20; %margin in px units

%.create table (empty)
W=850; H=100;
hTable=uitable('position',[w(3)-W-px w(4)-H-3*px W H],...
    'data',cell(1,12),...
    'RearrangeableColumns','on'); %'data',varList'
uicontrol('style','text','string','Tab-delimited file preview:',...
    'position',[w(3)-W-px, w(4)-1.8*px, W, px],...
    'fontSize',10,'horizontalAlignment','left',...
    'BackgroundColor',get(gcf,'color'));

%.create listbox with variables list
hList = uicontrol('style','listbox', ...
    'String', varList,...
    'Position', [px, px, w(3)-3*px-W, w(4)-4*px],...
    'CallBack',{@selectVar,hTable});
uicontrol('style','text','string','List of variables:',...
    'position',[px, w(4)-1.8*px, w(3)-3*px-W, px],...
    'fontSize',10,'horizontalAlignment','left',...
    'BackgroundColor',get(gcf,'color'));
uicontrol('style','text','string','    (hold ctrl-key to select several)',...
    'position',[px, w(4)-2.8*px, w(3)-3*px-W, px],...
    'fontSize',8,'horizontalAlignment','left',...
    'BackgroundColor',get(gcf,'color'));

%define column sizes
adapt_colWidth=0;
if adapt_colWidth
    %.get conversion factor from px units to char units
    size_pixels=get(hTable,'Position');
    set(hTable,'Units','characters')
    size_characters=get(hTable,'Position');
    f=size_pixels(3:4)./size_characters(3:4);
    %.get colum size
    varName_nbChar = cellfun(@numel, varList);
    varName_nbChar_px = varName_nbChar * f(1);
    %.set column width
    set(hTable,'ColumnWidth',num2cell(varName_nbChar_px)')
end

%push button 'store'
hStore = uicontrol('style','pushbutton', ...
    'String', 'store file structure',...
    'Position', [260 px+15 100 30],...
    'CallBack',{@store_txtfileStruct,hTable});
uicontrol('style','text', ...
    'String', '(with var of future runs)',...
    'horizontalAlignment','left',...
    'Position', [260 0 150 30],...
    'fontsize',7,...
    'BackgroundColor',get(gcf,'color'));

%push button 'save'
hSave = uicontrol('style','pushbutton', ...
    'String', 'save file',...
    'Position', [405 px+15 100 30],...
    'CallBack',{@save_txtfileStruct,hTable,path2folder_outputs});
uicontrol('style','text', ...
    'String', '(with var in current workspace)',...
    'horizontalAlignment','left',...
    'Position', [405 0 150 30],...
    'fontsize',7,...
    'BackgroundColor',get(gcf,'color'));

%push button 'cancel'
hCancel = uicontrol('style','pushbutton', ...
    'String', 'cancel',...
    'Position', [560 px+15 75 30],...
    'CallBack',{@closeFig,handles});


function selectVar(hObject,eventdata,hTable)
%collect picked elts in listbox and insert in table

%Enable mutliple selection:
% NB: "To enable multiple selection in a list box, you must set the Min and Max properties so that Max - Min > 1. You must change the default Min and Max values of 0 and 1 to meet these conditions. Use the Property Inspector to set these properties on the list box."
set(hObject,'max',2);

contents = cellstr(get(hObject,'String'));
selection_idx = get(hObject,'Value');
selection_txt=contents(selection_idx);

set(hTable,'data',selection_txt')


function closeFig(hObject,eventdata,handles)
%function called if 'cancel' button pressed

close(gcf)

%disable elts in gui
h_child = get(handles.saveTxtFile_panel,'children');
set(h_child, 'enable', 'off')
set(handles.saveTxtFile,'value',0);

function store_txtfileStruct(hObject,eventdata,hTable)
%function called if 'store' button pressed
%exports tab file structure create in table to the 'base' workspace

txtfileStruct = get(hTable,'data');
assignin('base','txtfileStruct',txtfileStruct)

close(gcf)

function save_txtfileStruct(hObject,eventdata,hTable,path2folder_outputs)

txtfileStruct = get(hTable,'data');
assignin('base','txtfileStruct',txtfileStruct)

ws_2upload = 'base';
save_var2txtfile(ws_2upload,path2folder_outputs)

close(gcf)