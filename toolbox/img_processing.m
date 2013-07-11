function img_processing

%% --- LOAD workspace variables:
ws_base = evalin('caller','who');
varNames = ws_base;
for i= 1 : length(varNames)
      varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
      S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---


% %-- image transfomation (crop, rotate, ...)
% if imgTransformation
%     img_transformation;
% end


%% -- img processing (diff, sum, ...)

%. img diff
imgDiff_frameRef = imgRaw - imgRef;     %img difference with frameStart
imgDiff_framePrev = imgRaw - imgPrev;    %img difference with previousFrame

%. img sum
if currentFrame==frameStrt, imgSum = imgRaw;
else imgSum = imgSum + imgRaw;
end


%% -- EXPORT variables to calling function
var_img = who('img*');
for i=1:numel(var_img)
    assignin('caller',var_img{i},eval(var_img{i}));
end