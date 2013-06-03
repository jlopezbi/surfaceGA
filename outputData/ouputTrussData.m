function  ouputTrussData(truss)
%ouputTrussData(filePath,truss): outputs csv file to build truss in Rhino
%   creates mulitple csv files: nodes, edges, (will add edge thicknesses)
%   file path is hardcoded to be in 'trussProject' folder in the
%   rhinoPython scripts
%INPUT:
%   truss = (Matlab struct) truss data
%OUPUT:
%   none: writes csv files called 'trusNodes.csv' 'trussEdges.csv' etc.

csvwrite('trussNodes.csv',truss.Coord');
csvwrite('trussEdges.csv',truss.Con');

movefile('trussNodes.csv','/Users/josh/Library/Application Support/McNeel/Rhinoceros/Scripts/trussProject');
movefile('trussEdges.csv','/Users/josh/Library/Application Support/McNeel/Rhinoceros/Scripts/trussProject');


end

