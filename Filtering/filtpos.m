function [interp]=filtpos(pos,like,vel_th,lenght_th,method)
[h,l] = size(pos);
%% Compute the Velocity
% Derivo le Posizioni
for i=1:2:l
    Vel(:,i:i+1) = [diff(pos(:,i)) diff(pos(:,i+1))];
end

%% Compute the Acceleration
% Derivo le velocità
Acc = diff(Vel);

%% FILTERING
% Elimino le posizioni con Velocità maggiore di 20 (False detection)
    
for k=1:l
    % Jump detection
    for i=3:h-1
        if (abs(Vel(i,k)) > vel_th)
            pos(i+1,k) = NaN; %array velocita' shiftato di un sample
        end
    end
end

%% Ulteriore Filtraggio

for k=1:l
    count = 0;
    start = 1;
    for i=1:h
        if ~isnan(pos(i,k)) 
            if count == 0
                start = i;
            end
            count = count + 1;
        else
            if count < lenght_th && count ~= 0  
                pos(start:i-1,k) = NaN; %DA RIVEDERE
            end
            count = 0;
        end
    end
    
end

%% INTERPOLATION

 for k=1:l    
    x = 1:h;
    y = pos(:,k);
    query = 1:h;
    
    for i=h:-1:1
        if isnan(pos(i,k))
            y(i) = [];
            x(i) = [];
        end
    end
    interp(:,k) = interp1(x,y,query,method)';    
end

end

