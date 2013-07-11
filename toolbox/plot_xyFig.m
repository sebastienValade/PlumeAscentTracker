function plot_xyFig

load_workspaceVar

% % NB: because 'plumeTracker' is a function, it has its own workspace which is different than the 'base' workspace.
% % => the function 'load_workspaceVar' does not load the variables from 'plumeTracker'.
% % => way around it:
% 
% %get 'caller'
% workspaceVar_caller = evalin('caller','who');
% idx_caller = find(strcmp('caller',workspaceVar_caller));
% callerName = evalin('caller',workspaceVar_caller{idx_caller});
% 
% %--- LOAD workspace variables:
% if strcmp(callerName,'plumeTracker_GUI'); workspace = 'base';
% elseif strcmp(callerName,'plumeTracker_FCN'); workspace = 'caller';
% end
% 
% varNames = evalin(workspace,'who');
% for i= 1 : length(varNames)
%     varVal = evalin(workspace,varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
%     S.(varNames{i}) = varVal;
% end
% get_struct2var(S)
% %---


%Nota Bene:
%- dat          data
%- dat_legend 	text used in legend to characterize the data
%- dat_label    text used for axis label of the data (standard names to identify axis type, i.e. unit used)
%- dat_abbrev   text used as abbreveation for data, used in figName ...



%% Check if multiple time formats (tframe & (tsec||tmin))
% (if multiple_timeFormats => (1) replace NaN values in tsec, (2) set axis tight for both time axis so points of both lineplots overlap)

axCell = struct2cell(axStruct);
%.if multiple variables => keep only 1st (else pb with cell2mat)
idx_multVar = find(cellfun(@numel, axCell)>1);
if ~isempty(idx_multVar), 
    for i=1:numel(idx_multVar), axCell{idx_multVar(i)}=axCell{idx_multVar(i)}(1); end
end
%.find time formats
tFormat_frame=find(cell2mat(cellfun(@(x) strcmp(x,'t_frame'),axCell,'UniformOutput', false)));
tFormat_sec=find(cell2mat(cellfun(@(x) strcmp(x,'t_sec'),axCell,'UniformOutput', false)));
tFormat_min=find(cell2mat(cellfun(@(x) strcmp(x,'t_min'),axCell,'UniformOutput', false)));

tFormats = [tFormat_frame;tFormat_sec;tFormat_min];
if numel(tFormats)>1
    isempty([tFormat_frame,tFormat_sec,tFormat_min])
    multiple_timeFormats = 1;
    
    %create tsec vector, replacing the NaN values before the onset by negative values in seconds
    idxNan = find(isnan(plumeInfo_tsec));
    idx0 = find(plumeInfo_tsec==0);
    tsec_noNan = plumeInfo_tsec;
    tsec_noNan(idxNan) = (plumeInfo_frame(idxNan)-plumeInfo_frame(idx0)) / frameRate;
    tmin_noNan = tsec_noNan/60;
    
    %get time axes
    fieldN = fieldnames(axStruct);
    multiple_timeAx = [];
    if ~isempty(tFormat_frame), multiple_timeAx{numel(multiple_timeAx)+1} = fieldN{tFormat_frame}; end
    if ~isempty(tFormat_sec), multiple_timeAx{numel(multiple_timeAx)+1} = fieldN{tFormat_sec}; end
    if ~isempty(tFormat_min), multiple_timeAx{numel(multiple_timeAx)+1} = fieldN{tFormat_min}; end
    
else 
    multiple_timeFormats = 0;
    multiple_timeAx = [];
end



%% loop through axStruct fields (X1,X2, Y1,Y2)
fieldNames = fieldnames(axStruct);
for j=1:4
    
    axName = fieldNames{j};
    
    %--- initializations
    ax = axStruct.(axName);
    dat=cell(numel(ax),1); dat_legend=cell(numel(ax),1); dat_label=cell(numel(ax),1); dat_abbrev=cell(1,numel(ax));
    idx=0;
    
    %--- define data
    for i=1:numel(ax) %loop => sets time series in requested order
        
        idx=idx +1;
        
        %- time
        if strcmp('t_sec',ax{i})
            dat{idx}=plumeInfo_tsec; dat_legend{idx}='tsec'; dat_label{idx}='time [sec]'; dat_abbrev{idx}='t';
            if multiple_timeFormats
                dat{idx}=tsec_noNan; dat_legend{idx}='tsec'; dat_label{idx}='time [sec]'; dat_abbrev{idx}='t';
            end
        end
        if strcmp('t_min',ax{i})
            dat{idx}=plumeInfo_tmin; dat_legend{idx}='tmin'; dat_label{idx}='time [min]'; dat_abbrev{idx}='t';
            if multiple_timeFormats
                dat{idx}=tmin_noNan; dat_legend{idx}='tmin'; dat_label{idx}='time [min]'; dat_abbrev{idx}='t';
            end
        end
        if strcmp('t_frame',ax{i})
            dat{idx}=plumeInfo_frame; dat_legend{idx}='tframe'; dat_label{idx}='time [frame]'; dat_abbrev{idx}='t';
        end
        
        %- [m]
        %. heightTop 
        if strcmp('heightTop',ax{i})
            dat{idx}=plumeInfo_top_m; dat_legend{idx}='top (absolute) height'; dat_label{idx}='height above vent [m]'; dat_abbrev{idx}='topH';
        end
        if strcmp('heightTop_mean',ax{i})
            dat{idx}=plumeInfo_topMean_m; dat_legend{idx}='top (mean) height'; dat_label{idx}='height above vent [m]'; dat_abbrev{idx}='topHmean';
        end
        %if strcmp('heightTop_mtlb',ax{i}) %computed in track_contourMtlb.m
        %    dat{idx}=plumeInfo_topM_mtlb; dat_legend{idx}='top height (mtlb)'; dat_label{idx}='height above vent [m]'; dat_abbrev{idx}='topH';
        %end
        
        %. heightCentroid
        if strcmp('heightCentroid',ax{i})
            dat{idx}=plumeInfo_centroidM; dat_legend{idx}='centroid height'; dat_label{idx}='height above vent [m]'; dat_abbrev{idx}='centH';
        end        
        %if strcmp('heightCenter_mtlb',ax{i}) %computed in track_contourMtlb.m
        %    dat{idx}=plumeInfo_centerM_mtlb; dat_legend{idx}='center height (mtlb)'; dat_label{idx}='height above vent [m]'; dat_abbrev{idx}='centH';
        %end
        
        %. radius
        if strcmp('radiusMax',ax{i})
            dat{idx}=plumeInfo_radMax_m; dat_legend{idx}='radius max'; dat_label{idx}='radius [m]'; dat_abbrev{idx}='Radmax';
        end
        if strcmp('radiusMean',ax{i})
            dat{idx}=plumeInfo_radMean_m; dat_legend{idx}='radius mean'; dat_label{idx}='radius [m]'; dat_abbrev{idx}='Radmean';
        end
        if strcmp('radiusCentroid',ax{i})
            dat{idx}=plumeInfo_radCent_m; dat_legend{idx}='radius centroid'; dat_label{idx}='radius [m]'; dat_abbrev{idx}='Radcent';
        end
        
        %- volume
        if strcmp('volume',ax{i})
            dat{idx}=plumeInfo_volume; dat_legend{idx}='volume'; dat_label{idx}='volume [m^3]'; dat_abbrev{idx}='Vol';
        end
        
        %- surface
        if strcmp('surface_2D',ax{i})
            dat{idx}=plumeInfo_surface2D; dat_legend{idx}='surface (3D)'; dat_label{idx}='surface [m^2]'; dat_abbrev{idx}='Surf2D';
        end
        if strcmp('surface_3D',ax{i})
            dat{idx}=plumeInfo_surface3D; dat_legend{idx}='surface (2D)'; dat_label{idx}='surface [m^2]'; dat_abbrev{idx}='Surf3D';
        end
        
        %-velocity (centroid & top)
        %NB: discard first point (if plume pixels found on 1st frame (=> if frames(1)==frameStrt),
        %then 1st velocity pt should not be considered since we do not have the start time
        if strcmp('velocityCentroid',ax{i})
            dat{idx}=plumeInfo_velocCentroid; %dat{idx}(1)=NaN; %discard first point
            dat_legend{idx}='centroid velocity'; dat_label{idx}='velocity [m/s]'; dat_abbrev{idx}='centV';
        end
        if strcmp('velocityCentroid_inst',ax{i})
            dat{idx}=plumeInfo_velocCent_inst; %dat{idx}(1)=NaN; %discard first point
            dat_legend{idx}='centroid velocity (instantaneous)'; dat_label{idx}='velocity [m/s]'; dat_abbrev{idx}='centVi';
        end
        if strcmp('velocityTop',ax{i})
            dat{idx}=plumeInfo_velocTop; %dat{idx}(1)=NaN; %discard first point
            %dat{idx}=plumeInfo_velocTop_inst;
            dat_legend{idx}='top velocity'; dat_label{idx}='velocity [m/s]'; dat_abbrev{idx}='topV';
        end
        if strcmp('velocityTop_inst',ax{i})
            dat{idx}=plumeInfo_velocTop_inst;
            dat_legend{idx}='top velocity (instantaneous)'; dat_label{idx}='velocity [m/s]'; dat_abbrev{idx}='topVi';
        end
%         if strcmp('velocityCenter_mtlb',ax{i})
%             dat{idx}=plumeInfo_velocCenter_mtlb; dat{idx}(1)=NaN; %discard first point
%             dat_legend{idx}='center velocity (mtlb)'; dat_label{idx}='velocity [m/s]'; dat_abbrev{idx}='centV';
%         end
%         if strcmp('velocityTop_mtlb',ax{i})
%             dat{idx}=plumeInfo_velocTop_mtlb; dat{idx}(1)=NaN; %discard first point
%             dat_legend{idx}='top velocity (mtlb)'; dat_label{idx}='velocity [m/s]'; dat_abbrev{idx}='topV';
%         end
        
        %-acceleration (centroid & top)
        %NB: discard first two points
        if strcmp('accelerationCentroid',ax{i})
            dat{idx}=plumeInfo_accelCentroid; %dat{idx}(1:2)=NaN; %discard first 2 pts
            dat_legend{idx}='centroid acceleration'; dat_label{idx}='acceleration [m/s]'; dat_abbrev{idx}='centA';
        end
        if strcmp('accelerationCentroid_inst',ax{i})
            dat{idx}=plumeInfo_accelCent_inst; %dat{idx}(1:2)=NaN; %discard first 2 pts
            dat_legend{idx}='centroid acceleration (instantaneous)'; dat_label{idx}='acceleration [m/s]'; dat_abbrev{idx}='centAi';
        end
        if strcmp('accelerationTop',ax{i})
            dat{idx}=plumeInfo_accelTop; %dat{idx}(1:2)=NaN; %discard first 2 pts
            dat_legend{idx}='top acceleration'; dat_label{idx}='acceleration [m/s]'; dat_abbrev{idx}='topA';
        end
        if strcmp('accelerationTop_inst',ax{i})
            dat{idx}=plumeInfo_accelTop_inst; %dat{idx}(1:2)=NaN; %discard first 2 pts
            dat_legend{idx}='top acceleration (instantaneous)'; dat_label{idx}='acceleration [m/s]'; dat_abbrev{idx}='topAi';
        end
%         if strcmp('accelerationCenter_mtlb',ax{i})
%             dat{idx}=plumeInfo_accelCenter_mtlb; dat{idx}(1:2)=NaN; %discard first 2 pts
%             dat_legend{idx}='center acceleration (mtlb)'; dat_label{idx}='acceleration [m/s]'; dat_abbrev{idx}='centA';
%         end
%         if strcmp('accelerationTop_mtlb',ax{i})
%             dat{idx}=plumeInfo_accelTop_mtlb; dat{idx}(1:2)=NaN; %discard first 2 pts
%             dat_legend{idx}='top acceleration (mtlb)'; dat_label{idx}='acceleration [m/s]'; dat_abbrev{idx}='topA';
%         end
        
        %- densityRatio
        if strcmp('densityRatio_sphere',ax{i})
            dat{idx}=plumeInfo_densityRatio_sphere; dat_legend{idx}='bulkDensity/atmDensity (sphere model)'; dat_label{idx}='density ratio';  dat_abbrev{idx}='densRatioCyl';
        end
        if strcmp('densityRatio_cylinder',ax{i})
            dat{idx}=plumeInfo_densityRatio_cylinder; dat_legend{idx}='bulkDensity/atmDensity (cylinder model)'; dat_label{idx}='density ratio';  dat_abbrev{idx}='densRatioSph';
        end
        
        %- temperatures
        if strcmp('tempMean_C',ax{i})
            dat{idx}=plumeInfo_tempMean_C; dat_legend{idx}='temperature plume (mean)'; dat_label{idx}='temperature [°C]';  dat_abbrev{idx}='tempMean';
        end
        if strcmp('tempMeanTop_C',ax{i})
            dat{idx}=plumeInfo_tempMeanTop_C; dat_legend{idx}='temperature plume (mean top)'; dat_label{idx}='temperature [°C]';  dat_abbrev{idx}='tempMeanTop';
        end
        if strcmp('tempMax_C',ax{i})
            dat{idx}=plumeInfo_tempMax_C; dat_legend{idx}='temperature plume (max)'; dat_label{idx}='temperature [°C]';  dat_abbrev{idx}='tempMax';
        end
        if strcmp('tempAtm_C',ax{i})
            dat{idx}=atmInfo_refPx_tempC; dat_legend{idx}='temperature atm (refPx h=maxRadius)'; dat_label{idx}='temperature [°C]';  dat_abbrev{idx}='tempAtm';
        end
        if strncmp('temp_measureTool',ax{i},16) %compare first 16 nbers
            %NB: name defined in define_measureTools.m, function saveCoordinates 
            toolNber_txt = ax{i}(17);
            toolNber = str2num(toolNber_txt);
            dat{idx}=measurePts_maxT(:,toolNber); dat_legend{idx}=['max temperature °C (measure tool ' toolNber_txt ')']; dat_label{idx}='temperature [°C]';  dat_abbrev{idx}=['tempTool' toolNber_txt];
        end
        
        %- ash mass
        if strcmp('massAsh_methAshFraction_sphere',ax{i})
            dat{idx}=plumeInfo_massAsh_methAshFrac_sph; dat_legend{idx}='ash mass (meth ashFraction - sphere model)'; dat_label{idx}='mass [kg]';  dat_abbrev{idx}='ashM-methAFsph';
        end
        if strcmp('massAsh_methAshFraction_cylinder',ax{i})
            dat{idx}=plumeInfo_massAsh_methAshFrac_cyl; dat_legend{idx}='ash mass (meth ashFraction - cylinder model)'; dat_label{idx}='mass [kg]';  dat_abbrev{idx}='ashM-methAFcyl';
        end
        if strcmp('massAsh_methThermBalance',ax{i})
            dat{idx}=plumeInfo_massAsh_methThermBalance; dat_legend{idx}='ash mass (meth thermalBalance)'; dat_label{idx}='mass [kg]';  dat_abbrev{idx}='ashM-methTB';
        end
        
        %- densities
        if strcmp('densityAtm_isam',ax{i})
            dat{idx}=plumeInfo_densityAtm_isam; dat_legend{idx}='density atm (Intern. Atm. Model at alt=plumeCentroid)'; dat_label{idx}='density [kg/m^3]';  dat_abbrev{idx}='densAtmIsam';
        end
        if strcmp('densityPlume_sphere',ax{i})
            dat{idx}=plumeInfo_density_sph; dat_legend{idx}='density plume (sphere model)'; dat_label{idx}='density [kg/m^3]';  dat_abbrev{idx}='densPlumeSph';
        end
        if strcmp('densityPlume_cylinder',ax{i})
            dat{idx}=plumeInfo_density_cyl; dat_legend{idx}='density plume (cylinder model)'; dat_label{idx}='density [kg/m^3]';  dat_abbrev{idx}='densPlumeCyl';
        end
    end
    
    %assign data, legend, label & abbrev to structure
    struct_axName.data = dat;
    struct_axName.legend = dat_legend;
    struct_axName.label = dat_label;
    struct_axName.abbrev = dat_abbrev;
    
    %rename structure with appropriate axName
    if strcmp(axName,'X1'), X1 = struct_axName;
    elseif strcmp(axName,'X2'), X2 = struct_axName;
    elseif strcmp(axName,'Y1'), Y1 = struct_axName;
    elseif strcmp(axName,'Y2'), Y2 = struct_axName;
    end
    
end

%-- PLOT
plotGraph(X1,X2,Y1,Y2,plot_uniqueFig,figSave,figName,figFormat,path2folder_outputs,multiple_timeFormats,multiple_timeAx)

function plotGraph(X1,X2,Y1,Y2,plot_uniqueFig,figSave,figName,figFormat,path2folder_outputs,multiple_timeFormats,multiple_timeAx)

%define nber of axis
xaxis_whosEmpty = [isempty(X1.data), isempty(X2.data)];
axX_idx = find(xaxis_whosEmpty==0); %defines which axis number is non empty (i.e. X1 and/or X2)
axX_nb = numel(axX_idx);

yaxis_whosEmpty = [isempty(Y1.data), isempty(Y2.data)];
axY_idx = find(yaxis_whosEmpty==0); %defines which axis number is non empty (i.e. Y1 and/or Y2)
axY_nb = numel(axY_idx);

%initialize
h=[];
h_fig=figure;
addGrid = 1;


%--- CASE 1: 1 x-axis vs. 1 y-axis

if axX_nb==1 && axY_nb==1
    
    %get X & Y data from appropriate structure file
    if axX_idx==1, X=X1.data; X_legend=X1.legend; X_label=X1.label; X_abbrev=X1.abbrev; axX_loc='bottom';
    else X=X2.data; X_legend=X2.legend; X_label=X2.label; X_abbrev=X2.abbrev; axX_loc='top';
    end
    if axY_idx==1, Y=Y1.data; Y_legend=Y1.legend; Y_label=Y1.label; Y_abbrev=Y1.abbrev; axY_loc='left';
    else Y=Y2.data; Y_legend=Y2.legend; Y_label=Y2.label; Y_abbrev=Y2.abbrev; axY_loc='right';
    end
    
    %define which axis has multiple plots
    % (=> needed to define the index searching within X & Y cell arrays; during loop through nbPlots, only ax with multiplePlots should vary)
    %.if nber of plots on Yaxis>Xaxis or if Xaxis type = time
    if numel(Y)>numel(X)
        ax_multiplePlots = 'axY';
        nbPlots = numel(Y);
        ax_labels = Y_label;
        ax_legend = Y_legend;
        
        %.if nber of plots on Xaxis>Yaxis and if Xaxis type ~= time
    elseif numel(X)>=numel(Y)
        ax_multiplePlots = 'axX';
        nbPlots = numel(X);
        ax_labels = X_label;
        ax_legend = X_legend;
    end
    
    %get nber of curves to plot per axis
    if nbPlots==1, colors = [0,0,1]; %blue
    else colors = jet(nbPlots); %colors used if several plots
    end
    
    %plot
    for i=1:nbPlots
        if ~plot_uniqueFig || nbPlots==1, %new fig only if plot_uniqueFig=0;
            if i>1, figure; h=[]; end
        else
        end
        
        if strcmp(ax_multiplePlots,'axY'), idxX=1; idxY=i;
        elseif strcmp(ax_multiplePlots,'axX'), idxX=i; idxY=1;
        end
        
        h(numel(h)+1)=plot(X{idxX},Y{idxY},'color',colors(i,:),'marker','.','displayName',ax_legend{i}); hold on
                
        %set axis position & labels
        set(gca,'XAxisLocation',axX_loc,'YAxisLocation',axY_loc)
        ylabel(Y_label{idxY}); xlabel(X_label{idxX});
        
        h_leg=legend(h); legend('boxoff')
        if addGrid, grid on; end
        if figSave && ~plot_uniqueFig
            fileName=[figName Y_abbrev{idxY} '-vs-' X_abbrev{idxX}];
            pathNfile = [path2folder_outputs fileName];
            save_sv(pathNfile,figFormat);
        end
        
    end
    %delete legend if only 1 curve
    if numel(h)==1, delete(h_leg); end; %legend('hide')
        
    if figSave && plot_uniqueFig
        fileName=[figName Y_abbrev{idxY} '-vs-' X_abbrev{idxX}];
        pathNfile = [path2folder_outputs fileName];
        save_sv(pathNfile,figFormat);
    end
end


%--- CASE 2: 1|2 x-axis vs. 1|2 y-axis
if axX_nb>1 || axY_nb>1
    
    if ~plot_uniqueFig
        disp('INFO: multiple X or Y axis requested => option "display on seperate figures" not available, data will be plotted on "unique figure".')
    end
    
    x1=X1.data; x2=X2.data;
    y1=Y1.data; y2=Y2.data;
    x1_leg=X1.legend; x2_leg=X2.legend;
    y1_leg=Y1.legend; y2_leg=Y2.legend;
    
    %define nber of curves for each ax
    x1_nbCurves = numel(x1); x2_nbCurves = numel(x2);
    y1_nbCurves = numel(y1); y2_nbCurves = numel(y2);
    axMat = [x1_nbCurves, x2_nbCurves, y1_nbCurves, y2_nbCurves];
    
    %.define which axis have multiple plots
    %   => index of axis: 1=X1, 2=X2, 3=Y1, 4=Y2; 0=no axis have multiple plots
    axMultipleCurves_idx = find(axMat>1); 
    
    %.initialise variables
    axX1_loc='bottom'; axX2_loc='top';
    axY1_loc='left'; axY2_loc='right';
    newMarkers={'.','*','x','o','+'}; %markers used for additional plots (only 2 colors, one for each axis type)
    idxMarker=1;
    
    %.if one of axis empty => fill with data of twin axis
    axEmpty_idx = find(axMat==0);
    if axEmpty_idx==1, x1=x2; x1_leg=x2_leg; axX1_loc = 'top';          %case X1 empty
    elseif axEmpty_idx==2, x2=x1; x2_leg=x1_leg; axX2_loc = 'bottom';   %case X2 empty
    end
    if axEmpty_idx==3, y1=y2; y1_leg=y2_leg; axY1_loc = 'right';        %case Y1 empty
    elseif axEmpty_idx==4, y2=y1; y2_leg=y1_leg; axY2_loc = 'left';     %case Y2 empty
    end
    
    X={x1,x2}; Y={y1,y2};
    X_legend = {x1_leg, x2_leg}; Y_legend = {y1_leg, y2_leg};
    
    %.define which axis "leads" (=> which legend to use)
    if isempty(axMultipleCurves_idx), axMultipleCurves_idx=0; end   %set to 0 for convenience in the conditions below, set bet to [] afterwards
    if isempty(axEmpty_idx), axEmpty_idx=0; end
    if axMultipleCurves_idx>2 %|| axEmpty_idx<=2            %case when Y1 | Y2 have multiple curves, OR X1 | X2 are empty => hold X index fixed
        leg2use = Y_legend; axType_multiplePlots = 'axY';
    elseif axMultipleCurves_idx<=2                           %case when X1 | X2 have multiple curves
        leg2use = X_legend; axType_multiplePlots = 'axX';
    elseif axMultipleCurves_idx<=2 && axMultipleCurves_idx~=0 %|| axEmpty_idx>2        %case when X1 or X2 have multiple curves, OR Y1 | Y2 are empty => hold Y index fixed
        leg2use = X_legend; axType_multiplePlots = 'axX';
    elseif axMultipleCurves_idx==0                          %if no multiple plots => use Y as default for curve legend
        leg2use = Y_legend; axType_multiplePlots = 'axY';
    end
    if axMultipleCurves_idx==0, axMultipleCurves_idx=[];  end
    if axEmpty_idx==0; axEmpty_idx=[]; end
    
    %special time case: when 2 time axis VS 1 other axis only
    special_timeAxisCase = 0;
    if numel(axEmpty_idx)==1
        if axEmpty_idx>2 %one Y axis undefined
            if unique(strcmp(X1.abbrev,'t')) && unique(strcmp(X2.abbrev,'t'))   %two X time axis
                axType_multiplePlots = 'axX';                       %switch so time axis have different colors
                special_timeAxisCase = 1;                             %flag to set axis limits
            end
        elseif axEmpty_idx<=2 %one X axis undefined
            if unique(strcmp(Y1.abbrev,'t')) && unique(strcmp(Y2.abbrev,'t'))   %two y time axis
                axType_multiplePlots = 'axY';                       %switch so time axis have different colors
                special_timeAxisCase = 1;                             %flag to set axis limits
            end
        end
    end
    
    

    %% -- PLOT --
    [AX,h1,h2] = plotyy(x1{1},y1{1},x2{1},y2{1});
    
    
    
    %% GRAPHIC DISPLAY
    
    %.define legend
    set(h1,'displayName',leg2use{1}{1},'marker',newMarkers{idxMarker});
    set(h2,'displayName',leg2use{2}{1},'marker',newMarkers{idxMarker});
    
    %.define axis location
    set(AX(1),'XAxisLocation',axX1_loc,'YAxisLocation',axY1_loc);
    set(AX(2),'XAxisLocation',axX2_loc,'YAxisLocation',axY2_loc);
    
    %.define axis color
    if strmatch(axType_multiplePlots,'axY')
        set(AX,'XColor','k');
        set(AX(1),'YColor',[0,0,1]); %blue
        set(AX(2),'YColor',[0,0.5,0]); %green
    elseif strmatch(axType_multiplePlots,'axX')
        set(AX,'YColor','k');
        set(AX(1),'XColor',[0,0,1]); %blue
        set(AX(2),'XColor',[0,0.5,0]); %green
    end
    
    %ADD additional curves
    for i=1:numel(axMultipleCurves_idx) %loop through axis which have multiple curves
        
        %define which current axis to use & nber of curves it holds
        if axMultipleCurves_idx(i)==1       %case when X1 has multiple curves
            ax2use=1; nbPlots=x1_nbCurves;
        elseif axMultipleCurves_idx(i)==2   %case when X2 has multiple curves
            ax2use=2; nbPlots=x2_nbCurves;
        elseif axMultipleCurves_idx(i)==3   %case when Y1 has multiple curves
            ax2use=1; nbPlots=y1_nbCurves;
        elseif axMultipleCurves_idx(i)==4   %case when Y2 has multiple curves
            ax2use=2; nbPlots=y2_nbCurves;
        end
        
        %set current axis (nb: error "Parent destroyed during line creation "when using plot(AX(ax2use),...) & 2 axes have multiple plots)
        set(gcf,'currentaxes',AX(ax2use)), hold on
        
        idxMarker = 1;
        for j=2:nbPlots %loop through the additional curves to plot
            idxMarker = idxMarker+1;
            
            if axMultipleCurves_idx>2       %case when Y1 or Y2 have multiple curves => hold X index fixed
                h{i}(j-1) = plot(X{ax2use}{1},Y{ax2use}{j},'displayName',Y_legend{ax2use}{j},'marker',newMarkers{idxMarker});
            elseif axMultipleCurves_idx<=2  %case when X1 or X2 have multiple curves => hold Y index fixed
                h{i}(j-1) = plot(X{ax2use}{j},Y{ax2use}{1},'displayName',X_legend{ax2use}{j},'marker',newMarkers{idxMarker});
            end
        end
        
    end
    
    %add axis labels
    set(get(AX(1),'Ylabel'),'String',unique(Y1.label)); set(get(AX(1),'Xlabel'),'String',unique(X1.label))
    set(get(AX(2),'Ylabel'),'String',unique(Y2.label)); set(get(AX(2),'Xlabel'),'String',unique(X2.label))
    
    %add grid
    if addGrid, grid on; end
    
    %adapt axis limits (%if ~isempty(axMultipleCurves_idx) ...)
    set(AX,'XLimMode','auto','XTickMode','auto') %set(gcf,'currentaxes',AX(1)), axis auto x
    set(AX,'YLimMode','auto','YTickMode','auto')

    %timeAxis lim: case when multiple time axis formats (ex: tframe & tsec)
    if multiple_timeFormats
       %=> set same axis tight for both time axis, so points of both lineplots overlap
       if strcmp(multiple_timeAx{1}(1),'X')
           set(AX(1),'xlim',[min(x1{1}), max(x1{1})])
           set(AX(2),'xlim',[min(x2{1}), max(x2{1})])
       elseif strcmp(multiple_timeAx{1}(1),'Y')
           set(AX(1),'ylim',[min(y1{1}), max(y1{1})])
           set(AX(2),'ylim',[min(y2{1}), max(y2{1})])
       end
    end
    
    %timeAxis lim: case when 2 time axis VS 1 other axis only
    if special_timeAxisCase 
        %=> set with identical limits the axis which is led by 2 time axis
        if axEmpty_idx==1, set(AX(1),'xlim',get(AX(2),'xlim')); timeAxSpec1=Y1.legend; timeAxSpec2=Y2.legend;
        elseif axEmpty_idx==2, set(AX(2),'xlim',get(AX(1),'xlim')); timeAxSpec1=Y1.legend; timeAxSpec2=Y2.legend;
        elseif axEmpty_idx==3, set(AX(1),'ylim',get(AX(2),'ylim')); timeAxSpec1=X1.legend; timeAxSpec2=X2.legend;
        elseif axEmpty_idx==4, set(AX(2),'ylim',get(AX(1),'ylim')); timeAxSpec1=X1.legend; timeAxSpec2=X2.legend;
        end
        set(h1,'displayName',[leg2use{1}{1} ', [' cell2mat(timeAxSpec1) ']'])
        set(h2,'displayName',[leg2use{2}{1} ', [' cell2mat(timeAxSpec2) ']'])
    end
    
    %add legend
    h_leg = legend([h1,h2,cell2mat(h)],'location','best'); %'northwest'
    set(h_leg,'fontsize',8,'box','off'); %legend('boxoff');
    
    if figSave
        Y1abbrev = cellfun(@(x) [x '-'],Y1.abbrev,'uniformOutput',0); Y2abbrev = cellfun(@(x) [x '-'],Y2.abbrev,'uniformOutput',0);
        X1abbrev = cellfun(@(x) [x '-'],X1.abbrev,'uniformOutput',0); X2abbrev = cellfun(@(x) [x '-'],X2.abbrev,'uniformOutput',0);
        Y_abbrev = [cell2mat(Y1abbrev) cell2mat(Y2abbrev)];
        X_abbrev = [cell2mat(X1abbrev) cell2mat(X2abbrev)];
        
        fileName=[figName Y_abbrev(1:end-1) '_VS_' X_abbrev(1:end-1)];
        pathNfile = [path2folder_outputs fileName];
        save_sv(pathNfile,figFormat);
    end
end
