function plot_imgMean


load_workspaceVar

totalNbFrames = numel(frameStrt:frameStep:frameEnd);

imgMean = imgSum ./ totalNbFrames;

%% figure set up
hFig = figure;
defPos = get(hFig,'position'); %[680, 558, 560, 420];
set(hFig,'position', [defPos(1:3), defPos(4)+0.1*defPos(4)])
movegui(hFig,'center')

%push button 'save'
hSave_imgM = uicontrol('style','pushbutton', ...
    'String', 'save image',...
    'Position', [230 30 75 30],...  %'Position', [270 15 75 30],...
    'CallBack',{@save_imgMatrix,imgMean,path2folder_outputs});


%% plot figure
imagesc(imgMean), axis image
colorbar

titleTxt = ['mean image (frames = ' num2str(frameStrt) ':' num2str(frameStep) ':' num2str(frameEnd) '; total frame nb = ' num2str(totalNbFrames) ')'];
h=title(titleTxt);
% set(h,'fontSize',7)



function save_imgMatrix(source,eventdata,imgMean,path2folder_outputs) 

fileName = 'imgMeanMatrix';
pathNfile = [path2folder_outputs fileName];

% SAVE image in .mat format (= saving .fig saves RGB values)
save(pathNfile, 'imgMean')

% SAVE image in .jpg format
h_ui = findobj(gcf,'type','uicontrol');
set(h_ui,'visible','off') %set user interface button invisible
save_sv(pathNfile,'jpg')
set(h_ui,'visible','on')

disp('Mean image saved (JPG + MAT formats) in /outputs folder.')
