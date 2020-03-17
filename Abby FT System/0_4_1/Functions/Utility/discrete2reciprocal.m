function blockData = discrete2reciprocal(blockData, s)
%DISCRETE2RECIPROCAL Turns a discrete block into a reciprocal block.
%     Will take any discrete block task and attempt to make it a reciprocal
%     block task. This is an imperfect method and will tend to generate
%     unusual tasks. A well defined and behaived blockData file should be
%     constructed instead of relying on this function.
% 
%     However, it is sitll suefull for spitting out reciprocal tasks on the
%     fly, and is what the program uses to create reciprocal tasks when
%     asked to do so in a basic set-up as it will, technically, produce a
%     doable reciprocal task.
% 
%     User discretion is advised!
% 
%     Preconditions: Screen data (s) and full blockData.
% 
%     Postconditions: Returns edited blockData which will produce a reciprocal task
%     when run.





flag = false;
p = [1 3 2 4];
if blockData(1, 6) == 1
    axisConstant = s.creenXpix/2;
else
    p = [2 4 1 3];
    axisConstant = s.creenYpix/2;
end
while flag == false
    for i = 2 : size(blockData, 1)
        width = (blockData(i, p(2)) - blockData(i, p(1)));
        if blockData(i, 6) ~= log2((4 * abs(axisConstant - (blockData(i, p(2)) + width/2)))/width)
            flag = true;
            break
        end
    end
end
if flag == true
    for i = 2 : size(blockData, 1)
        ID = log2((2*blockData(i, 5)/blockData(i, 6)));
        distancefromcentre = abs(axisConstant - (blockData(i, p(1)) + (blockData(i, p(2)) - blockData(i, p(1)))/2));
        newwidth = (4 * distancefromcentre)/pow2(ID);
        blockData(i, p(1)) = axisConstant + distancefromcentre - newwidth/2;
        blockData(i, p(2)) = axisConstant + distancefromcentre + newwidth/2;
        blockData(i, [p(1) p(2) p(3) p(4)] + 7) = [(-blockData(i, p(2))+ 2* axisConstant) (-blockData(i, p(1))+ 2* axisConstant) blockData(i, p(3)) blockData(i, p(4))];
    end
end
