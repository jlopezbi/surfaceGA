function [pop,figureH,figureT,plotData]=initPop(handles,dataName)
%[pop,figureH,figureT,plotData] = initPop(handles,dataName)
%Initialize a population with individuals that are mutations (every vert)
%of the template truss (mesh1)
%
%input:
%   handles = gui handles which contain gaData struct
%   dataName = string for the name of the appData
%ouput:
%   pop = cell array {nIndivid x 1}
%   figureH = handle to figure that displays trusses
%   figureT = handle to figure that displays template truss
%   plotData = [2x1] ,matrix, first row is genVec, second row is minVec,
%              add avgVec later

gaParams = getappdata(handles.figure1,dataName);
mesh1 = gaParams.mesh;
fixed = gaParams.fixed;
loaded = gaParams.loaded;
forces = gaParams.forces;
nIndivid = gaParams.nIndivid;
boundBox = gaParams.boundBox;
costWeights = gaParams.costWeights;
numDisplay = gaParams.numDisplay;

pop = cell(nIndivid,1);   % population cell Array
pop{1} = generateGraphFromMesh(mesh1,fixed,loaded,forces);

for i = 2:nIndivid
    pop{i} = randomIndivid(pop{1},boundBox,0,.2);
end

pop = updateTrusses(pop,nIndivid);
[costs,currMinFit,avgCost] = assignCosts(pop,nIndivid,costWeights);
%[matePairs] = selMatePairs(costs,numKeep);
%pop = mateTrusses(pop,matePairs,nIndivid,ratioParents);
%pop = mutateTrusses(pop,nIndivid,costs,numKeep,mutationRate);

fprintf('INITIALIZED POPULATION\n');
fprintf('number of Individuals: %d\n',nIndivid);
fprintf('init Min Cost: %2.4f, avgCost %2.4f\n',currMinFit,avgCost);

figureT = figure();
set(figureT, 'Color',[0 0 0],'Name','INITIAL TRUSS',...
    'NumberTitle','off','MenuBar','none','OuterPosition',[540,170,490,455]);
tPlot = axes('Color','none');
axis vis3d;
idxT = costs(:,2)==1; %col2 of costs is the idx. see assignCosts()
trussStats = (costs(idxT,:));
plotTruss(pop{1},trussStats,1,2,1,boundBox,false);

rot = rotate3d(figureT);
set(rot,'RotateStyle','orbit','Enable','on');


figureH = plotGeneration(pop,[],costs,[],boundBox,numDisplay);
plotData = [0; currMinFit];

%plot(handles.gaPlot_gen,0,currMinFit,'Marker','.','MarkerSize',10);
%set(handles.gaPlot_gen,'XLim',[0,2],'YLim',[0,currMinFit*1.3]);

end

