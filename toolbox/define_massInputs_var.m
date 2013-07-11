function define_massInputs_var

%% TRACKED VAR (to be plotted on XY figure)
%  "trackedVar" = n x m cell array, where:
%     n = nber of tracked variables
%     m = tracked varialbe characteristics:
%       1. feat_nameGUI      = feature name appearing in GUI
%       2. feat_nameVarX     = expression to collect X values

% NB: at the moment this function is used in "get_densityRatio.m", but in
% future versions, it should be used in "plot_xyFig.m"


trackedVar={};

%. height
trackedVar(size(trackedVar,1)+1,:) = {...
    'heightTop',...
    'plumeInfo_top_m'};
trackedVar(size(trackedVar,1)+1,:) = {...
    'heightTop_mean',...
    'plumeInfo_topMean_m'};
trackedVar(size(trackedVar,1)+1,:) = {...
    'heightCentroid',...
    'plumeInfo_centroidM'};

%. radius
trackedVar(size(trackedVar,1)+1,:) = {...
    'radiusMax',...
    'plumeInfo_radMax_m'};
trackedVar(size(trackedVar,1)+1,:) = {...
    'radiusMean',...
    'plumeInfo_radMean_m'};
trackedVar(size(trackedVar,1)+1,:) = {...
    'radiusCentroid',...
    'plumeInfo_radCent_m'};

%-velocity (centroid & top)
trackedVar(size(trackedVar,1)+1,:) = {...
    'velocityTop',...
    'plumeInfo_velocTop'};
trackedVar(size(trackedVar,1)+1,:) = {...
    'velocityTop_inst',...
    'plumeInfo_velocTop_inst'};

%-acceleration
trackedVar(size(trackedVar,1)+1,:) = {...
    'accelerationCentroid',...
    'plumeInfo_accelCentroid'};



var_nameGUI = trackedVar(:,1);
var_nameVar = trackedVar(:,2);



%% EXPORT VARIABLES
var2export = who;
for i=1:numel(var2export)
    assignin('caller',var2export{i},eval(var2export{i}));
end