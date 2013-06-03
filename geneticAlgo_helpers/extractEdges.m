function [ edges ] = extractEdges( faces )
%extractEdgesOneFace makes a nEdges x 2 array representing the 3 edges in 
%a face
%   input:
%       a nFacesx3 matrix which represents all the faces. NOTE: assumes
%       each row is sorted!!
%   output:
%       a nEdges x 2 matrix which represents the 3 edges in that face

nE = 3; %num edges per face
nF = size(faces,1);
F = faces';
colsCopy = 1:nF;
colsIndices = repmat(colsCopy,nE,1); 
%if repmat is slow for many faces
%try stackoverflow.com/questions/10316128/matlab-duplicating-vector-n-times
fF = F(:,colsIndices)';

%this part is making the arrays that index fF (copies faces)
%refer to 
%stackoverflow.com/questions/10316128/matlab-duplicating-vector-n-times
% and http://www.ee.columbia.edu/~marios/matlab/mtt.pdf
C = [1 2 2 3 1 3];
Cn = C';
CC = Cn(:,ones(nF,1));
colSub = CC(:)';
R = 1:nF*nE;
Rn = R(ones(1,2),:);
rowSub = Rn(:)';



finalIdx = sub2ind(size(fF),rowSub,colSub);
edgesRow = fF(finalIdx);
edgesGen = vec2mat(edgesRow,2);
edgesSort = sort(edgesGen,2);
edges = unique(edgesSort,'rows'); %note: unique sorts according to rows

end


