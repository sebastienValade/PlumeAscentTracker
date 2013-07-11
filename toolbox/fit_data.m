function [xFit,yFit,fitCoefs,delta] = fit_data(dat2fit_pxX,dat2fit_pxY,polyfitDegree)
% fit => values of Y found for values X=min(X):max(X)
% 
% INPUTS:
% - polyfitDegree = degree of polynomial
%       degree=1 => linear fit (coef polynomial order=1 : coef1*x + coef2)


[fitCoefs,delta] = polyfit(dat2fit_pxX, dat2fit_pxY, polyfitDegree); 
xFit = linspace(min(dat2fit_pxX), max(dat2fit_pxX));
yFit = polyval(fitCoefs, xFit);