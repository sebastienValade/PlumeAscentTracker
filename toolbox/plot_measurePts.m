function plot_measurePts

load_workspaceVar

nber_ofFrames = numel(plumeInfo_frame);

for i=1 : size(measurePts_T,2) %loop through nber of measure tools

    x = measurePts_coordXY{i,1};
    
    if numel(x)==1 %measure = point
        figure
        temperature = cell2mat(measurePts_T(:,i));
        plot(plumeInfo_frame,temperature,'.b-');
        
        title(['measure tool ' num2str(i)])
        xlabel('time [frame nb]')
        ylabel('temperature [°C]')
        
    elseif numel(x)>1 %measure = line
        
        %plot temperature profiles through time
        figure
        cmap = jet(nber_ofFrames);
        colormap(cmap)
        
        for j=1:numel(plumeInfo_frame)
            temperature = measurePts_T{j,i};
            
            hold on
            h(j) = plot(x,temperature,'color',cmap(j,:));
        end
        
        title(['measure tool ' num2str(i)])
        xlabel('x-position [pixel]')
        ylabel('temperature [°C]')
        
        h=colorbar('ytick',(1:nber_ofFrames)+0.5,'yticklabel',plumeInfo_frame,'fontsize',6);
        ylabel(h,'frame number')
        
        
        %plot (mean) temperature evolution
        figure
        
        temp_mean = cellfun(@mean,measurePts_T(:,i));
        temp_max = cellfun(@max,measurePts_T(:,i));
        temp_min = cellfun(@min,measurePts_T(:,i));
        
        hh=[];
        hh(1)=plot(plumeInfo_frame,temp_mean,'.g-','displayName','mean temperature'); hold on
        hh(2)=plot(plumeInfo_frame,temp_max,'.r-','displayName','max temperature');
        hh(3)=plot(plumeInfo_frame,temp_min,'.b-','displayName','min temperature');
        hleg=legend(hh);
        set(hleg,'box','off','location','best');
                
        title(['measure tool ' num2str(i)])
        xlabel('time [frame nb]')
        ylabel('temperature [°C]')
        
    end
    
end