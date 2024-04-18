function settlingTime = calculateSettlingTime(time, displacement, tolerance)
    % Inputs:
    %   time: Time array
    %   displacement: Displacement array corresponding to each time
    %   tolerance: Percentage tolerance for settling time (e.g., 5%)

    % Find the final or steady-state value (assume it's the last value)
    finalValue = displacement(end);

    % Define the tolerance band
    toleranceBand = (max(displacement) - finalValue) * (tolerance / 100);
    
    settlingTime = time(end);
    found = -1;
    % Find the indices where the displacement is within the tolerance band
    for i = length(time):-1:1
        if abs(displacement(i) - finalValue)>toleranceBand && found<0
            settlingTime = time(i);
            found = 1;
        end

    end

    found = -1;
     for i = 1:length(time)
        if (displacement(i))>0 && found<0
            starttime = time(i)
            found = 1;
        end
     end
    settlingTime = settlingTime - starttime;

end
