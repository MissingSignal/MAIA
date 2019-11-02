function [interp]=occlusion_filt(pos,like,lenght_th,method)
%% FILTERING
%When a marker is occluded the likelihood drops below 0.7
[h,l] = size(pos);
   
%% OCCLUSION DETECTION

for k=1:l;
        for i=1:h-1
            if (like(i,5) < 0.8) %0.75 alla consegna tesi
                pos(i,k:k+1) = NaN; %ATTENZIONE DA VERIFICARE
            end
        end
end

%% ulteriore filtraggio
% interpolo coordinate (tratti di dimensione maggiore di th) con likeliness
% bassa

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

%}
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
 %}
end