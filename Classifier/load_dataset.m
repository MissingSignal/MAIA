function [Table]= load_dataset(checkdata,NEGclass,POSclass)
    %% Load Data
    
    NEG = readmatrix(NEGclass);

    POS = readmatrix(POSclass);
    
    if (checkdata)
        [NEG] = find_outliers(NEG);
        [POS] = find_outliers(POS);
    end
    Dataset = [NEG ; POS];
    
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