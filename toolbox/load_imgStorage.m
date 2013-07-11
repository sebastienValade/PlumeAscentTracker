function load_imgStorage
%open imgStorage 
%   . if images => folder
%   . if video => videoObject 


%--- LOAD workspace variables:
ws_base= evalin('caller','who');
varNames= ws_base;
for i= 1 : length(varNames)
      varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
      S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---


if strcmp(fileType,'image files') || strcmp(fileType,'url link')
    %-- get filesInfolder
    searchfile_optn = 'sortByDate';
    [list_fileNamesSpecif]=get_filesInfolder(pathName,searchfile_optn);
    if isempty(list_fileNamesSpecif), disp('WARNING: no file found with the demanded fileSpecification in the chosen source folder. Execution terminated.'), return, end
    imgStorage=list_fileNamesSpecif;
    nbFrames=size(list_fileNamesSpecif,1);
    if strcmp(frameEnd,'last'), frameEnd=size(list_fileNamesSpecif,1); end
    
elseif strcmp(fileType,'video file')
    %-- get video object
    disp('Uploading video file, please wait...')
    try
        videoObj = VideoReader([pathName videoName]);
        
        imgStorage=videoObj;
        frameRate_video = videoObj.FrameRate;
        nbFrames=videoObj.NumberOfFrames;
            
    catch
       disp('... upload with VideoReader function unsuccessful ...') 
       disp('... upload attempt with mmread function ...')
       try
           [videoObj, audio] = mmread([pathName videoName]);
           imgStorage = videoObj.frames;
           nbFrames = videoObj.nrFramesTotal;
           frameRate_video = videoObj.rate;
       catch
           disp('... upload with mmread function unsuccessful.')
           return
       end
    end
    disp('... upload successful.'); videoObj
        
    if strcmp(frameEnd,'last'), frameEnd=nbFrames; end
    assignin('caller','frameRate_video',frameRate_video);
end


%-- EXPORT variables to calling function whose names start with 'plumeInfo'
var = {'imgStorage','nbFrames','frameEnd'};
for i=1:numel(var)
    assignin('caller',var{i},eval(var{i}));
end