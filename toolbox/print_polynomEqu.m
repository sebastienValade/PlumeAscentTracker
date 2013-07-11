function polyEquation = print_polynomEqu(polyCoefs)
% polyEquation = print_polynomEqu(polyCoefs)

polyEquation = 'y = ';

for i=1:numel(polyCoefs)
    
    if polyCoefs(i)>0 && i>1, operationSign=' +';
    elseif polyCoefs(i)<0 && i>1, operationSign=' ';
    else operationSign='';
    end
    
    if numel(polyCoefs)-i>1, xExpression = ['x^' num2str(numel(polyCoefs)-i)];
    elseif numel(polyCoefs)-i==1, xExpression = 'x';
    elseif numel(polyCoefs)-i==0, xExpression = '';
    end
    
    polyEquation = [polyEquation operationSign num2str(polyCoefs(i),'%.2f') xExpression];
    
end