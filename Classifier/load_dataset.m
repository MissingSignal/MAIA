function [Table]= load_dataset(checkdata)
    %Load Data
%     load('POS.mat');
%     POS = AllData;
%     load('NEG.mat');
%     NEG = AllData;
    
    load('PT.mat');
    POS = AllData;
    load('AT.mat');
    NEG = AllData;
    
    if (checkdata)
        [NEG] = find_outliers(NEG);
        [POS] = find_outliers(POS);
    end
    Dataset = [NEG ; POS];
    
    % Merge some features
    Dataset = [Dataset(:,1:7) Dataset(:,8)+Dataset(:,9) Dataset(:,10)+Dataset(:,11) Dataset(:,12) Dataset(:,13)+Dataset(:,14) Dataset(:,15)+Dataset(:,16) Dataset(:,17) Dataset(:,18)+Dataset(:,19) Dataset(:,20)+Dataset(:,21) ...
        Dataset(:,22) Dataset(:,23)+Dataset(:,24) Dataset(:,25)+Dataset(:,26)];

    %% Table creation  
    
    Table = array2table(Dataset);
    
    % Labels
    Labels(1:size(NEG,1),1) = {'NEG'};
    Labels(size(NEG,1)+1:size(NEG,1)+size(POS,1),1) = {'POS'};
    Table(:,size(Dataset,2)+1) = Labels;
    
    % Naming the variables 
    varNames = {'VelHandsCorrelation','AccHandsCorrelation','JerkHandsCorrelation','VelFeetCorrelation','AccFeetCorrelation','JerkFeetCorrelation'...
    'skew1','skew_hands','skew_feet','Area_Nose','Area_Hands','Area_Feet','Area0_Nose','Area0_Hands','Area0_Feet', ...
    'Periodicity_Nose','Periodicity_Hands','Periodicity_Feet','Labels'};
    Table.Properties.VariableNames = varNames ;
  
end