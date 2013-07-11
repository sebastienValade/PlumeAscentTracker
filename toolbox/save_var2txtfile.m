function save_var2txtfile(ws_2upload,path2folder_outputs)

%--- LOAD workspace variables:
ws = evalin(ws_2upload,'who');
varNames = ws;
for i= 1 : length(varNames)
    varVal = evalin(ws_2upload,varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
    S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---

%.define file name
if isempty(fileName_txt)
    if exist('list_fileNamesSpecif','var'), fileName_txt = ['outputVariables_seq' list_fileNamesSpecif(1,1:3) '.txt'];
    else fileName_txt = 'outputVariables.txt';
    end
else fileName_txt = [fileName_txt '.txt'];
end
pathNfile = [path2folder_outputs fileName_txt];

%create matrix of data
M = makeMatrix(txtfileStruct);

%create file
fileID = fopen(pathNfile,'w');
% fileID = fopen(fileName_txt,'w');

%fill column headers
for i=1:numel(txtfileStruct)
    % precision = repmat('%s\t',1,numel(txtfileStruct));
    fprintf(fileID,'%s\t',txtfileStruct{i});
end
fprintf(fileID,'\r\n')

%fill data
dataPrecision = [repmat('%6.2f\t',1,numel(txtfileStruct)) '\r\n'];
fprintf(fileID,dataPrecision,M);
fclose(fileID);

% dlmwrite(fileName_txt, M, 'delimiter', '\t')
% csvwrite(fileName_txt,M)
% save(fileName_txt,'plumeInfo_tsec','plumeInfo_frame','-ascii', '-tabs')



function M = makeMatrix(txtfileStruct)

%--- LOAD workspace variables:
ws_base= evalin('caller','who');
varNames= ws_base;
for i= 1 : length(varNames)
    varVal = evalin('caller',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
    S.(varNames{i}) = varVal;
end
get_struct2var(S)
%---

M=[];
for i=1:numel(txtfileStruct)
    
    %- time
    if strcmp('t_sec',txtfileStruct{i})
        M(i,:)=plumeInfo_tsec;
    end
    if strcmp('t_min',txtfileStruct{i})
        M(i,:)=plumeInfo_tmin;
    end
    if strcmp('t_frame',txtfileStruct{i})
        M(i,:)=plumeInfo_frame;
    end
    
    %- volume
    if strcmp('volume',txtfileStruct{i})
        M(i,:)=plumeInfo_volume;
    end
    
    %- surface
    if strcmp('surface_2D',txtfileStruct{i})
        M(i,:)=plumeInfo_surface2D;
    end
    if strcmp('surface_3D',txtfileStruct{i})
        M(i,:)=plumeInfo_surface3D;
    end
    
    %- heightTop (home-made & mtlb methods)
    if strcmp('heightTop',txtfileStruct{i})
        M(i,:)=plumeInfo_top_m;
    end
    
    %- heightCentroid
    if strcmp('heightCentroid',txtfileStruct{i})
        M(i,:)=plumeInfo_centroidM;
    end
    
    %- maxRadius
    if strcmp('maxRadius',txtfileStruct{i})
        M(i,:)=plumeInfo_radMax_m;
    end
    
    %-velocity (centroid & top)
    %NB: discard first point (if plume pixels found on 1st frame (=> if frames(1)==frameStrt),
    %then 1st velocity pt should not be considered since we do not have the start time
    if strcmp('velocityCentroid',txtfileStruct{i})
        M(i,:)=plumeInfo_velocCentroid;
    end
    if strcmp('velocityTop',txtfileStruct{i})
        M(i,:)=plumeInfo_velocTop;
    end
    
    %-acceleration (centroid & top)
    %NB: discard first two points
    if strcmp('accelerationCentroid',txtfileStruct{i})
        M(i,:)=plumeInfo_accelCentroid;
    end
    if strcmp('accelerationTop',txtfileStruct{i})
        M(i,:)=plumeInfo_accelTop;
    end
    
    %- densityRatio
    if strcmp('densityRatio_sphere',txtfileStruct{i})
        M(i,:)=plumeInfo_densityRatio_sphere;
    end
    if strcmp('densityRatio_cylinder',txtfileStruct{i})
        M(i,:)=plumeInfo_densityRatio_cylinder;
    end
    
    %- temperatures
    if strcmp('tempMean_C',txtfileStruct{i})
        M(i,:)=plumeInfo_tempMean_C;
    end
    if strcmp('tempMax_C',txtfileStruct{i})
        M(i,:)=plumeInfo_tempMax_C;
    end
    if strcmp('tempAtm_C',txtfileStruct{i})
        M(i,:)=atmInfo_refPx_tempC;
    end
    
    %- ash mass
    if strcmp('massAsh_methAshFraction_sphere',txtfileStruct{i})
        M(i,:)=plumeInfo_massAsh_methAshFrac_sph;
    end
    if strcmp('massAsh_methAshFraction_cylinder',txtfileStruct{i})
        M(i,:)=plumeInfo_massAsh_methAshFrac_cyl;
    end
    if strcmp('massAsh_methThermBalance',txtfileStruct{i})
        M(i,:)=plumeInfo_massAsh_methThermBalance;
    end
    
    %- atm density (at the moment must compute ash mass with methAshFraction)
    if strcmp('densityAtm_isam',txtfileStruct{i})
        M(i,:)=plumeInfo_densityAtm_isam;
    end
end