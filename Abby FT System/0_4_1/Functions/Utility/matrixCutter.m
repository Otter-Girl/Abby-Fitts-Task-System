function lessBigMatrix = matrixCutter(bigMatrix)
% MATRIXCUTTER This function removes NaN rows from the base of a matrix.
%   What else do you need to know bud?
% 
%   Preconditions: A big fuck-off matrix with NaN rows
% 
%   Postconditions: A less-so-fuck-off matrix with no NaN rows.

%bigMatrix = full(bigMatrix);

for i = 1:size(bigMatrix, 1)
    if isnan(bigMatrix(i, 1))
        lessBigMatrix = bigMatrix(1: (i-1), :);
        break
    end
end
end

