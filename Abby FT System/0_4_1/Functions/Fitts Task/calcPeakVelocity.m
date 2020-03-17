function [peekVelocity, intention2move] = calcPeakVelocity(positionPlot, check3, check4)
%CALCPEAKVELOCITY Calculates the peak velocity in a given task.
%     For a discrete task the whole movement profile is used. For a
%     reciprocal task [].
% 
%     Preconditions: Data file for position plot, the start and end times of the aiming task.
% 
%     Postconditions: The peak velocity in pix/s and the calculated time of the paitents first intention to move, given 5% of peak velocity.

check3 = check3 - 60;
v = NaN(check4 - check3, 2);
for i = check3: check4
    v(i - check3 + 1, 2) = (positionPlot(i+1,2)- positionPlot(i,2))*60;
end
v(:, 1) = positionPlot(check3: check4, 1);
peekVelocity = max(v(:,2));
for i = 1: check4 - check3 
    if (v(i,2) - (peekVelocity * 0.05)) > 0
        intention2move = positionPlot(i + check3, 1);
        break
    end
end

