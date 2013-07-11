function load_img(frame2load)

%% --- LOAD workspace variables:
ws_base= evalin('caller','who');
varNames= ws_base;
for i= 1 : length(varNames)
      varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
      S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---


%% load frame2use
if strcmp(fileType,'image files') || strcmp(fileType,'url link')
    
    A = importdata([pathName imgStorage(frame2load,:)]); %works with raw & manipulated files (e.g. im. substraction)
    
    %-- open img file
    if isnumeric(A) 
        %.case if upload = .jpg, .tiff, file
        
        if numel(size(A))==3 
            %.case if 3 component imagery data (RGB)
            imgRaw_rgb = A;
            imgRaw_idx = rgb2ind(imgRaw_rgb, gray, 'nodither');
            imgRaw = double(imgRaw_idx); %NB: rgb2idx output = uint8 => unsigned elts => uint8 - uint8 always >0
        else
            %.case if 2 component imagery data 
            %	NB: var imgRaw_rgb still defined eventhough not RGB, 
            %   because data non-radiometric => GUI fig-monitor options = imgRaw_rgb & imgRaw_idx => need to be defined in case plot requested
            imgRaw_rgb = A;
            imgRaw_idx = double(A); %NB: if A = uint8 => unsigned elts => uint8 - uint8 always >=0
            imgRaw = double(A);
        end
        
        
     elseif isstruct(A)
        
        fieldName_list = fieldnames(A);
        [~,field]=strtok(fieldName_list(2),'_');
               
        if isfield(A,'cdata') 
            %.case if format = .bmp, ...
            if numel(size(A.cdata))==2 %case if 2 component data
                imgRaw_rgb = A.cdata; %NB: if A = uint8 => unsigned elts => uint8 - uint8 always >=0
                imgRaw_idx = double(imgRaw_rgb);
                imgRaw = double(imgRaw_rgb);
            elseif numel(size(A.cdata))==3
                disp('WARNING: 3-component (24 bit) BMP images not yet supported. Tracking aborted.')
            end
        else
            %elseif strcmp(field{1}(2:end), 'DateTime')
            %.case if format = .mat file formated by FLIR software
            fieldName = cell2mat(fieldName_list(1)); %1st field in structure holds image; field name may be different from file name if the latter has been changed manually
            imgRaw_kelvin = A.(fieldName);
            imgRaw = imgRaw_kelvin - 273.15;          %img in °C
            
        end
    end
    
elseif strcmp(fileType,'video file')
    
    %-- open img file
    if isfield(imgStorage,'cdata')
        imgRaw_rgb = imgStorage(frame2load).cdata;
        imgRaw_idx = rgb2ind(imgRaw_rgb, gray, 'nodither');
        imgRaw = double(imgRaw_idx); %NB: rgb2idx output = uint8 => unsigned elts => uint8 - uint8 always >0
    else
        imgRaw_rgb = read(imgStorage, frame2load);
        imgRaw_idx = rgb2ind(imgRaw_rgb, gray, 'nodither');
        imgRaw = double(imgRaw_idx); %NB: rgb2idx output = uint8 => unsigned elts => uint8 - uint8 always >0
    end
end


%% -- EXPORT variables to calling function whose names start with 'plumeInfo'
var_img = who('img*');
for i=1:numel(var_img)
    assignin('caller',var_img{i},eval(var_img{i}));
end