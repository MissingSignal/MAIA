function [OrderedDataset] = find_outliers2(Dataset,method,visualize);


    %% FIND OUTLIERS AND REPLACE IT
    %Dataset(:,end); %exclude the labels
    names = Dataset.Properties.VariableNames;
    OrderedDataset = sortrows(Dataset,'Labels');
    
    POS = [];
    NEG = [];
    
    
    for i=1:size(Dataset,1)
        if Dataset{i,end} == "POS"
            POS = [ POS ; Dataset(i,:)];
        elseif Dataset{i,end} == "NEG"
            NEG = [NEG ; Dataset(i,:)];
        end
    end
    
    
    %% NEGATIVE CLASS
    NEG(:,end) = [];
    NEG = table2array(NEG);
    samples = 1:1:size(NEG,1);
    
    outliersmap = isoutlier(NEG(:,:),method);
    
    outliers = sum(outliersmap,2);
    outval = NEG(outliersmap);
    
    %per ogni riga
    for i=1:size(NEG,1)
        if outliers(i) > 0
             fprintf('ho trovato %d outliers nel soggetto %d della classe NEGATIVE \n', outliers(i),i)
             if visualize
                 for h=find(outliersmap(i,:)) %numero feature outlier
                     figure
                     scatter(samples,NEG(:,h),200,'filled') %printo tutte le feature della colonna h
                     title(names(h))
                     hold on
                     scatter(i,NEG(i,h),200,'filled')
                     hold off
                 end 
             end
        end
    end   
   
    %% POSITIVE CLASS
    POS(:,end) = [];
    POS = table2array(POS);
    samples = 1:1:size(POS,1);
    
    outliersmap = isoutlier(POS(:,:),method);
    
    outliers = sum(outliersmap,2);
    outval = POS(outliersmap);
    
    %per ogni riga
    for i=1:size(POS,1)
        if outliers(i) > 2
             fprintf('ho trovato %d outliers nel soggetto %d della classe POSITIVE \n', outliers(i),i)
             if visualize
                 % printo tutte le variabili outliers
                 for h=find(outliersmap(i,:))
                     figure
                     scatter(samples,POS(:,h),200,'filled')
                     title(names(h))
                     hold on
                     scatter(i,POS(i,h),200,'filled')
                     hold off
                 end 
             end
        end
    end 
  
end