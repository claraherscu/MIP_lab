function [ hipsSeg ] = getHips( bonesSeg )
%GETHIPS Get the area of the binary pixels of the hips
%   We search for the change in the convhull to find the spine.
%   To find the start of the hips we search for the end of the spine

topSlice = size(bonesSeg,3);
convhullWidth = [];
for j = 10:10:topSlice;    
    convhullWidth(end+1) = getWidth(bonesSeg(:,:,j));
    % Last value much smaller than max, we started the spine
    if convhullWidth(end) < max(convhullWidth)*0.3
        hipsEnd = j - 10
        spineStart = j
        break;
    end
end

if ~exist('hipsEnd','var')
    display('FATAL - Start of spine could not be found');
    return;
end

% Search for end of spine
square = getConvhullSquare(bonesSeg(:,:,spineStart));
lowerSpine = zeros(size(bonesSeg));
% As we care about the sacro-ilium join we can look until the end of the
% spine the y axis as well
lowerSpine(square(1):square(2), :, 1:spineStart) = 1;
yMinSpine = square(3);

for j = hipsEnd:-1:1;
    spineImg = lowerSpine(:,:,j) & bonesSeg(:,:,j);
    spinePixels = numel(find(spineImg));
    if spinePixels < 60
        hipsStart = j;
        break;
    end
end

if ~exist('hipsStart','var')
    display('FATAL - End of spine could not be found');
    return;
end

hipsArea = zeros(size(bonesSeg));
hipsArea(:,yMinSpine:end ,hipsStart:hipsEnd) = 1;
hipsSeg = bonesSeg & hipsArea;
end


function [ width ] = getWidth(X)
% Finds the width of the convhull
[x, y] = ind2sub(size(X), find(X));
idxs = convhull(x,y, 'simplify', true);
xh = x(idxs);
% yh = y(idxs);
width = max(xh) - min(xh);
end

function [ square ] = getConvhullSquare(X)
% Finds the width of the convhull
[x, y] = ind2sub(size(X), find(X));
idxs = convhull(x,y, 'simplify', true);
xh = x(idxs);
yh = y(idxs);
square = [min(xh) max(xh) min(yh) max(xh)];
end