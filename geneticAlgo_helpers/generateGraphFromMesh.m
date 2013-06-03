function [ graph ] = generateGraphFromMesh(mesh,fixed,loaded,forces)
%GENERATEGRAPHFROMMESH(mesh,fixed,loaded,forces)
%
%makes nodes and edges from imported obj file.  Uses
%a mesh imported using the read_wobj.m file, found at 
%www.mathworks.com/matlabcentral/fileexchange/27982-wavefront-obj-toolbox
%thanks to Dirk-Jan Koon
%traingulated mesh
%UNITS: lb, in
%
%INPUT:
%   mesh -- an obj file, if no input will pop-up file selector
%   fixed -- a row vector of indices for fixed vertices
%   loaded -- a row vector of indices for loaded vertices
%   forces -- an array of forces [numLoadPnts x 3] (X,Y,Z components of force)
%OUTPUT:
%   graph (struct):
%       .Coord  --- coordinates of nodes
%       .Con --- edges (connectors)
%       .Re -- restraints (fixed nodes = 1, free = 0)
%       .Load -- forces on nodes
%       .A -- areas of each connector
%       .E -- elastic modulus of each connector
%       .F -- force along members
%       .U -- displacements
%       .R -- reaction forces

if(exist('mesh','var')==0)
    mesh = read_wobj();
end


sizeNodes = size(mesh.vertices);

%NODE COORDINATES
Coord = mesh.vertices;


%CONNECTORS
indexFaceObject = 0;
for i = 1:size(mesh.objects,2)
    if(mesh.objects(i).type == 'f')
        indexFaceObject = i;
    end
end

faceData = mesh.objects(indexFaceObject);
assert(faceData.type == 'f');
faces = sort(faceData.data.vertices,2); %vertIndices faceindices, sorted rows
Con = extractEdges(faces);
numConnectors = size(Con, 1);

%FIXED NODES 1 = fixed, 0 = free
Re = zeros(sizeNodes); %start with all nodes free in all directions.
Re(fixed,:) = ones(size(fixed,2),3); %1 = fixed, 0 = free

%LOADS
assert(size(loaded,2)==size(forces,1));
Load = zeros(sizeNodes);
Load(loaded,:) = forces;

%AREAS
Area = .025*.75; %current area of al. strips. {in^2}
A = ones(1,numConnectors).*Area;

%ELASTIC MODULUS 
Eal = 10^6;  %9993000.0; %elastic modulus of aluminum. {psi} 9993000.0
%E = ones(1,numConnectors).*Eal;
E=ones(1,size(Con,1))*Eal;

graph=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');

%ADD loaded[] fixed[] and forces[] for display later
graph.fixed = fixed;
graph.loaded = loaded;
graph.forces = forces;

end














