function load_workspaceVar
% load_workspaceVar (=> no inputs nor outputs)
% => used to load all workspace variables into a caller funtion

ws_base= evalin('base','who');
varNames= ws_base;
for i= 1 : length(varNames)
      varVal = evalin('base',varNames{i});    %evaluate variable named 'variables{i}' from workspace ('base')
      assignin('caller',varNames{i},varVal);  %store in the calling function's workspace ('caller')
end