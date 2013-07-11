function save_animatedGif

%--- LOAD workspace variables:
ws_base= evalin('caller','who');
varNames= ws_base;
for i= 1 : length(varNames)
    varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
    S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---


if isempty(figName_GIF)
    figName_GIF = [path2folder_outputs 'monitorFig.gif'];
else
    figName_GIF = [path2folder_outputs figName_GIF '.gif'];
end

set(gcf, 'Renderer', 'zbuffer') 

frame = getframe(gcf);
%im = frame2im(frame);
[im,cm] = rgb2ind(frame.cdata,256,'nodither');


if i==frameStrt,
    imwrite(im,cm,figName_GIF,'gif', 'Loopcount',inf);
else
    imwrite(im,cm,figName_GIF,'gif','WriteMode','append');
end