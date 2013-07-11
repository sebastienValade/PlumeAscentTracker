function J = cmap_jet_baseK(nbValues)
% J = cmap_jet_baseK(nbValues)
% ArgIn: input is optional, if nothing added then colormap will have by default 64 values
% ArgOut: colormap = jet with black at 1st line
%
% use: colormap(eval(cmap_jet_baseK))

if nargin < 1
    nbValues = 64;      % 64 | 256
end
    
%--colormap = jet with white for noise:
J = jet(nbValues);
J(1,:)=[0,0,0];