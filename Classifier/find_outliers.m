function [Output]= find_outliers(Data)

    %% FIND OUTLIERS AND REPLACE IT
    %Dataset = Dataset(:,1:end-1); %exclude the labels
    
    %% AT 
    outliersmap = isoutlier(Data(:,:),'mean');
    
    outliers = sum(outliersmap,2);
    for i=1:size(Data,1)
        if outliers(i) > 2
             fprintf('ho trovato %d outliers nel soggetto %d della classe %s \n', outliers(i),i,inputname(1))
        end
    end   
   
    Data(outliersmap) = nan;
    MeanValues = nanmean(Data);
    
    for i=1:size(Data,2)
        Data(outliersmap(:,i),i) = MeanValues(1,i);
    end
    
    Output = Data;
        
end