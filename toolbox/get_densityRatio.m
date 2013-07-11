function [densityRatio_sphere, densityRatio_cylinder] = get_densityRatio

% load_workspaceVar
% NB: because 'plumeTracker' is a function, it has its own workspace which is different than the 'base' workspace.
% => the function 'load_workspaceVar' does not load the variables from 'plumeTracker'.
% => way around it:

%--- LOAD workspace variables:
ws_base= evalin('caller','who');
varNames= ws_base;
for i= 1 : length(varNames)
    varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
    S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---

%% load INPUT PARAMETERS needed to compute density ratios

%.get required parameters defined in GUI define_massInputs
get_struct2var(inputs_massParam)

%.get matrices holding the names of the variable (1) in the GUI, and (2) in the program 
define_massInputs_var

%... radius2use
% => radius [m] (=> largest disk diameter/2)
idxVar = strcmp(var_nameGUI,inputs_massParam.radius2use);
nameVar = var_nameVar{idxVar};
r = eval(nameVar);

%... height2use
% => length of cylinder (=> height of plume top)
idxVar = strcmp(var_nameGUI,inputs_massParam.height2use);
nameVar = var_nameVar{idxVar};
L = eval(nameVar);

%... velocity2use
% => velocity of plume top
idxVar = strcmp(var_nameGUI,inputs_massParam.velocity2use);
nameVar = var_nameVar{idxVar};
w = eval(nameVar);

%... acceleration2use
% => acceleration of plume centroid
idxVar = strcmp(var_nameGUI,inputs_massParam.acceleration2use);
nameVar = var_nameVar{idxVar};
dudt = eval(nameVar);

%... other
g = 9.81;


%% get density ratios (Wilson & Self, 1980)

% plumeModel type = sphere
Cs = 0.47; %drag coef for spherical plume model
numerateur = g - (3*Cs * w.^2) ./ (8*r);
denominateur = g + dudt;
densityRatio_sphere = numerateur ./ denominateur;


% plumeModel type = cylinder
Cc = 1; %drag coef for cylinder plume model
numerateur = g - (Cc * w.^2) ./ (2*L);
denominateur = g + dudt;
densityRatio_cylinder = numerateur ./ denominateur;

