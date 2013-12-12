function get_ashMass

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



%% load INPUT PARAMETERS needed to compute mass  (defined in GUI define_massInputs)

get_struct2var(inputs_massParam)
% Needed variables uploaded:
% .densityAsh
% .dens_atm2use (& densAtm_val)
% .temp_atm2use (& tempAtm_val)
% .temp_heatedAir2use (& tempAir_val)
% .specHeat_ash & specHeat_ash if radiometricData
% .temp_ash2use (& tempAsh_val) if radiometricData


%get density of ATMOSPHERE to use
switch dens_atm2use
    case 'densAtm_stdAtm'
        %=> use Standard Atmosphere model (1975) evaluated at plumeCentroid altitude asl
        %NB: atmosisa.m = function in aerospace toolbox => use instead function stdatmo.m which is shared by matlab user & which uses the same atmosphere model as atmosisa
        altitude_plumeCentroid = ventAlt_m + plumeInfo_centroidM;
        [rho,~,~,~,~]=stdatmo(altitude_plumeCentroid);
        densityAtm_values = rho;
        densityAtm_legend = 'densityAtm from International Standard Atmosphere model';
        densityAtm_abbrev = 'densityAtm_stdAtm';
        
    case 'densAtm_cst'
        %=> use constant value
        %NB: densityAtm = 0.7 kg/m3 (Fuego summit value = 0.7)
        densityAtm = densAtm_val;
        densityAtm_values = densityAtm * ones(numel(plumeInfo_frame),1);
        densityAtm_legend = 'densityAtm cst';
        densityAtm_abbrev = 'densityAtm_cst';
end
%export to base workspace
assignin('base',['plumeInfo_' densityAtm_abbrev], densityAtm_values)


%get temperature of ATMOSPHERE to use
switch temp_atm2use
    case 'tempAtm_stdAtm'
        %=> use Standard Atmosphere model (1975) evaluated at plumeCentroid altitude asl
        %NB: atmosisa.m = function in aerospace toolbox => use instead function stdatmo.m which is shared by matlab user & which uses the same atmosphere model as atmosisa
        altitude_plumeCentroid = ventAlt_m + plumeInfo_centroidM;
        [~,~,tempAtm_K,~,~]=stdatmo(altitude_plumeCentroid);
        tempAtm_K = tempAtm_K + tempAtm_incK;
    case 'tempAtm_cst'
        tempAtm_K = tempAtm_val +273.15;
end


%get temperature of heated air to use
switch temp_heatedAir2use
    case 'tempAir_meanT'
        tempHeatedAir_K = plumeInfo_tempMean_C +273.15;
    case 'tempAir_cst'
        tempHeatedAir_K = tempAir_val +273.15;
end


%get density of HEATED AIR (equation in Wilson & Self, 1980 p.2568):
densityAir_heated = densityAtm_values .* (tempAtm_K ./ tempHeatedAir_K);
    

%% ASH FRACTION method
if find(strcmp('meth_ashFraction',ashMass_method2use))
    
    %--- INPUTS
    %. get density ratios (computed in get_densityRatio.m)
    densityRatios = {plumeInfo_densityRatio_sphere, plumeInfo_densityRatio_cylinder};
    
    %. get densityAsh
    %  NB: densityAsh = 650kg/m3 for dacitic volcanic ash, Bonadonna & Phillips 2003, used by Yamamoto et al 2008 (=1000kg/m3 for vesicular ash, Sparks and Wilson 1982)
    densityAsh_values = densityAsh * ones(numel(densityRatios{1}),1);

   
    %loop through densityRatios (sphere model & cylinder model)
    for i=1:2
        densityRatio = densityRatios{i};
        
        %- get density of bulk plume (from density ratio, Wilson & Self 1980)
        beta = densityRatio .* densityAtm_values;
        plumeDensity{i} = beta;
        
        %- get ash fraction
        ashFraction = (beta - densityAir_heated) ./ (densityAsh_values - densityAir_heated);
        airFraction = 1-ashFraction;
        
        %- get ash mass
        ashMass{i} = ashFraction .* plumeInfo_volume .* densityAsh_values;
    end
    
    plumeInfo_massAsh_methAshFrac_sph = ashMass{1};
    plumeInfo_massAsh_methAshFrac_cyl = ashMass{2};
    
    plumeInfo_density_sph = plumeDensity{1};
    plumeInfo_density_cyl = plumeDensity{2};
    
end


%% THERMAL BALANCE method
if find(strcmp('meth_thermalBalance',ashMass_method2use))
    
    %--- INPUTS
    %. get specific heat values
    %  NB: specific heat of ash = 1100 [J/kg/K]
    c_air = specHeat_air;
    c_ash = specHeat_ash;
 
    %. get ash temperature
    switch temp_ash2use
    case 'tempAsh_maxT'
        plumeInfo_tempMax_K = plumeInfo_tempMax_C +273.15;
        T_ash = max(plumeInfo_tempMax_K);
    case 'tempAsh_cst'
        T_ash = tempAsh_val +273.15;
    end
    
    T_ash_vector = T_ash * ones(numel(T_ash),1);
    c_air_vector = c_air * ones(numel(T_ash),1);
    c_ash_vector = c_ash * ones(numel(T_ash),1);

    %-get air mass
    m_air = densityAir_heated .* plumeInfo_volume;
    
    %-ash mass
    %!! use deltaT_K=(plume T - atm T) NOT (plume T) !!
    deltaT_K = tempHeatedAir_K - tempAtm_K;
    ashMass = (m_air .* c_air_vector .* deltaT_K) ./ (c_ash_vector .* (T_ash_vector - tempHeatedAir_K));
    plumeInfo_massAsh_methThermBalance = ashMass;
end



%% EXPORT variables
var_plumeMass = who('plumeInfo_mass*');
var_plumeDens = who('plumeInfo_density*');
var2export = [var_plumeMass; var_plumeDens];
for i=1:numel(var2export)
    assignin('caller',var2export{i},eval(var2export{i}));
end
