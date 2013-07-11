function save_sv(filename,varargin)
%save_sv(filename,varargin)
%
%ArgIN:
%   Compulsory: filename = string used as figure name (no need for \ before underscore !)
%   Optional: 
%       varargin n°1: 'fig', 'jpg', 'jpgHQ', 'emf', 'eps', and/or 'png' depending on wanted extension for output figure
%           NB: figure format can be a cell input: figformat=[{'jpg','emf'}] or [{'jpg'},{'emf'}], save_sv(figname,figformat)
%       varargin n°2, IF 'jpgHQ' chosen => possibility to choose dpi
%       resolution 
%OUTPUT = current figure as .fig or .jpg depending on chosen ArgIn

if iscell(varargin{1}) %if cell input (ex: [{'jpg','emf'}] or [{'jpg'},{'emf'}])
    if size(varargin,2)>1 %resolution specif for jpgHQ
        resolution=varargin{2};
    end
    
    varargin=varargin{1};

    %     a=varargin{1};
    %     for i=1:size(varargin{1},2)
    %         varargin(1,i)=a{i};
    %     end
elseif ~iscell(varargin{1}) && numel(varargin)>1
    resolution=varargin{2};
end

if strmatch('fig',varargin(1,:),'exact')
    %Save in FIG
    %saveas(gcf,filename,'fig') %pb: if filename contains period than extension not written in saved figure
    saveas(gcf,[filename '.fig'])
end

if strmatch('jpg',varargin(1,:),'exact')
    %Save in JPG
    %NB: saveas(gcf,filename,'jpg') gives bad rendering => code to what GUI>saveas would do:
    set(gcf,'filename',[filename '.jpg']);
    %filemenufcn(gcf,'FileExportSetup') %function for pop ip menu File export setup
    filemenufcn(gcf,'FileSave')
end

if strmatch('jpgHQ',varargin(1,:),'exact')
   
    if ~exist('resolution','var')
        figName=[filename 'HQ'];
        print('-djpeg90',figName)
    elseif exist('resolution','var')
        figName=[filename 'HQ' resolution];
        print('-djpeg90',['-' resolution],figName)
    end
    
end

if strmatch('eps',varargin(1,:),'exact')
    %saveas(gcf,filename,'eps') %renders in black and white
    saveas(gcf,[filename '.eps'],'psc2') %renders in color
end

if strmatch('emf',varargin(1,:),'exact')
    %saveas(gcf,filename,'emf') %pb: if filename contains period than extension not written in saved figure
    saveas(gcf,[filename '.emf'])
end

if strmatch('png',varargin(1,:),'exact')
    saveas(gcf,filename,'png')
end