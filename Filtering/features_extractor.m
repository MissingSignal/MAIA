function [features] = features_extractor(pos)
    %% FUNCTION SETTINGS
    % Do you want to plot the results?
    PLOT=false;

    %% MEMORY ALLOCATION (VARIABLES DECLARATION) 

     [ h,l ] = size(pos);

    % Mean Velocity,Acceleration and Jerk 
     Mean_Vel = zeros(1,l/2);
     Mean_Acc = zeros(1,l/2);
     Mean_Jerk = zeros(1,l/2);

    % Total Velocity,Acceleration and Jerk
    TotVel = zeros(h-1,l/2);
    TotAcc = zeros(h-2,l/2);
    TotJerk = zeros(h-3,l/2);

    % Periodicity
    P = zeros(1,l);
    Periodicity = zeros(1,l/2);

    % Moving average, STD and Area
    M = zeros(h,l);
    difference = zeros(h,l);
    percentage = zeros(h,l);
    S = zeros(1,l);
    Area = zeros(h,l);
    Area2 = zeros(h,l);

    %% Velocity, Acceleration and Jerk
    % Ottengo le velocità di ciascuna componente
    for i=1:2:l
        Vel(:,i:i+1) = diff(pos(:,i:i+1));
    end

    % Acceleration
    Acc = diff(Vel);

    % Jerk
    Jerk = diff(Acc);

    %% Composed Velocity,Acceleration and Jerk
    % Composed Velocity
    for i=1:h-1 %righe -1 perche velocità
        s = 1;
        for r = 1:2:l %colonne
        TotVel(i,s) = sqrt( Vel(i,r)^2 + Vel(i,r+1)^2 ); %Pitagora's theorem for the module
        s = s+1;
        end
    end

    % Composed Accelerations

    for i=1:h-2 %righe -1 perche velocità
        s = 1;
        for r = 1:2:l %colonne
        TotAcc(i,s) = sqrt( Acc(i,r)^2 + Acc(i,r+1)^2 ); %Pitagora's theorem for the module
        s = s+1;
        end
    end

    % Composed Jerks

    for i=1:h-3 %righe -1 perche velocità
        s = 1;
        for r = 1:2:l %colonne
        TotJerk(i,s) = sqrt( Jerk(i,r)^2 + Jerk(i,r+1)^2 ); %Pitagora's theorem for the module
        s = s+1;
        end
    end

    %% Cross Correlations
    % I evaluate the correlation coefficients for VEL,ACC,JERK then i take the
    % non diagonal values that represent the correlation between two different
    % velocities 

    % Cross Correlation between hands
    VelCorrelation = corrcoef(TotVel(:,2),TotVel(:,3));
    AccCorrelation = corrcoef(TotAcc(:,2),TotAcc(:,3));
    JerkCorrelation = corrcoef(TotJerk(:,2),TotJerk(:,3));

    HandsCorrelation = [ VelCorrelation(2,1) AccCorrelation(2,1) JerkCorrelation(2,1) ];

    % Cross Correlation between feet
    VelCorrelation = corrcoef(TotVel(:,4),TotVel(:,5));
    AccCorrelation = corrcoef(TotAcc(:,4),TotAcc(:,5));
    JerkCorrelation = corrcoef(TotJerk(:,4),TotJerk(:,5));

    FeetCorrelation = [ VelCorrelation(2,1) AccCorrelation(2,1) JerkCorrelation(2,1) ];

    %% Skewness

    skew = skewness(TotVel);

    %% Area differing from moving average [OK FUNZIONA]
    %misuro IN PERCENTUALE quanto la coordinata del marker discosta dalla media
    %mobile, faccio quindi la somma delle percentuali

    for k=1:l %per ciascuna coordinata
        M(:,k) = movmean(pos(:,k),99); %moving average
        S(k) = std(pos(:,k)); %standard deviation
        difference(:,k) = abs(M(:,k)-pos(:,k)); %differenza media mobile - posizione attuale
        %percentage(:,k) = abs((difference(:,k)*100)./M(:,k)); %calcolo percentuale
    end
    %Area = sum(percentage); 
    Area = sum(difference);
    Area = Area/h;
    Area = [ (Area(1) + Area(2)) (Area(3)+ Area(4)) (Area(5) + Area(6)) (Area(7) + Area(8)) (Area(9) + Area(10)) ];

    % Change the plot value on the top of the code to plot the results
    if PLOT
        for k=1:l
            figure(k)
            plot(M(:,k),'--')
            hold on
            plot(pos(:,k))
            hold on
            plot(M(:,k)+S(k),':')
            hold on
            plot(M(:,k)-S(k),':')
            hold on 
            plot(Area(:,k))
        end
    end

    %% Area out of standard deviation of moving average [PENSO OK]

    for k=1:l
        for i=1:h
            if(difference(i,k) > S(k))
                %Area2(i,k) = abs(((difference(i,k)-S(k))*100)./S(k));
                Area2(i,k) = abs(difference(i,k));
            end
        end
    end
    Area2 = sum(Area2);
    Area2 = Area2/h;
    Area2 = [ (Area2(1) + Area2(2)) (Area2(3)+ Area2(4)) (Area2(5) + Area2(6)) (Area2(7) + Area2(8)) (Area2(9) + Area2(10)) ];
    
    %Plot
    %{
    plot(Area2(:,3)) %2857
    hold on
    plot(pos(:,3))
    hold on 
    plot(M(:,3),':')
    hold on 
    plot(M(:,3)+S(3),':')
    hold on
    plot(M(:,3)-S(3),':')
    %}
    %% Periodicity
    for i=1:l
        zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0); % Returns Zero-Crossing Indices Of Argument Vector
        Crosses = zci(M(i,:)-pos(:,i));
        Distances = diff(Crosses);
        P(i) = 1/(std(Distances)+mean(Distances));
    end
    k=1; % Se riesci trova metodo piu elegante
    for i=1:2:9  %sommo le periodicita delle coordinate di ciascun marker
        Periodicity(k) = P(i) + P(i+1);
        k=k+1;
    end

    %% MEAN VELOCITY, ACCELERATION AND JERK
    % Array con Vel,Acc,Jerk medio di ciascun marker
    for i=1:l/2
            Mean_Vel(i) = mean(TotVel(:,i));
            Mean_Acc(i) = mean(TotAcc(:,i));
            Mean_Jerk(i) = mean(TotJerk(:,i));
    end        
    %% OUTPUT PARAMETERS (FEATURES)
    % The final vector of features is composed as follows:
    % [Xcorrelation(Hands)(x3) Xcorrelation(Feet)(x3) Skewness(X5) Area(X5) Area2(X5) Periodicity(X5) MeanVel(x5) MeanAcc(x5) MeanJerk(x5) ]
    features = [HandsCorrelation FeetCorrelation skew Area Area2 Periodicity ]; %Mean_Vel Mean_Acc Mean_Jerk];
    
    %% MERGE THE FEATURES
    features = [features(:,1:7) features(:,8)+features(:,9) features(:,10)+features(:,11) features(:,12) features(:,13)+features(:,14) features(:,15)+features(:,16) features(:,17) features(:,18)+features(:,19) features(:,20)+features(:,21) ...
    features(:,22) features(:,23)+features(:,24) features(:,25)+features(:,26)];

end