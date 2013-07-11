function maximize_figure
%set current figure to screen size

scrsz = get(0,'ScreenSize');
set(gcf,'Position',[scrsz(1) scrsz(2)+scrsz(4)/20 scrsz(3) scrsz(4)*17/20]); 

% jFrame = get(handle(gcf),'JavaFrame');
% jFrame.setMaximized(true);