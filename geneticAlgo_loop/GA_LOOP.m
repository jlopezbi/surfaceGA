function [ pop ] = GA_LOOP(handles,gaParams,nGenIdle,numDisplay,figureH)
%GA_LOOP(handles,gaParams,nGenIdle,numDisplay,figureH)
%--run truss GA
% later: inputing ratio parents and numKeep is silly: change to just
% numKeep
%input:
%   handles
%   gaParams
%   nGenIdle = number of Generation to Idle even if stop crit is met. keep
%           searching! paciencia
%   numDisplay
%   figureH
%output:

pop = gaParams.pop;
nIndivid = gaParams.nIndivid;
numKeep = gaParams.numKeep;
% mutationRate = gaParams.mutationRate; defined in Loop -> realtime update?
maxIter = gaParams.maxIter;
stopCrit = gaParams.stopCrit;
% nGenIdle = gaParams.nGenIdle; %defined in Loop ->realtime update?
boundBox = gaParams.boundBox;
% numDisplay = gaParams.numDisplay;
% figureH = gaParams.figureH;
costWeights = gaParams.costWeights;
minVec = gaParams.minVec;
genVec = gaParams.genVec;
avgVec = [];

prevMinFit = Inf;
%maxIter = 10;
%minIter = 20;
currIter = 1;
idleCount = 0;


while(1)
    gaParams = getappdata(handles.figure1,'gaData');
    
    
    %ASSIGN COSTS
    pop = updateTrusses(pop,nIndivid);
    [costs,currMinFit,avgCost] = assignCosts(pop,nIndivid,costWeights);
    genVec = [genVec,currIter];
    minVec = [minVec, currMinFit];
    avgVec = [avgVec, avgCost];
    
        
    %DISPLAY GENERATION INFO
    fprintf('GENERATION %d\n',currIter);
    fprintf('   minCost: %2.4f, avgCost %2.5f\n',currMinFit,avgCost);
    %figure(figureH);
    set(0,'CurrentFigure',figureH)
    nameFigStr = ['GENERATION ', num2str(currIter)];
    set(figureH, 'Name',nameFigStr,'NumberTitle','off');
    plotGeneration(pop,figureH,costs,numKeep,boundBox,numDisplay);
    plot(handles.gaPlot_gen, genVec,minVec,'Marker','.','MarkerSize',10);
    xlabel(handles.gaPlot_gen,'generation');
    ylabel(handles.gaPlot_gen,'min cost');
    title(handles.gaPlot_gen,'Minimum Cost per Generation');
    drawnow;    
    
    %CHECK STOPPING CRITERIA OR GUI PAUSED    
    isPaused = gaParams.pause;
    currError = prevMinFit-currMinFit;
    if(currError < stopCrit)
        if(idleCount<=nGenIdle)
            idleCount = idleCount+1;
        else
            %plotGeneration(pop,[],costs,numKeep,numDisplay);
            fprintf('stop crit met, idled for %d generations\n', nGenIdle);
            break
        end
    else
        idleCount = 0;
    end
        
    if(currIter>maxIter)
        %plotGeneration(pop,[],costs,numKeep,numDisplay);
        fprintf('maxIter met\n');
        break
    end
        
    if(isPaused)
        fprintf('GA paused at iteration: %d\n',currIter);   
        uiwait;
    end
    prevMinFit = currMinFit;

    %SELECT MATE PAIRS
    [matePairs] = selMatePairs(costs,numKeep);

    %MATE (overwrite unfit individualsin pop[])
    pop = mateTrusses(pop,matePairs,nIndivid,numKeep);

    %MUTATE (overwrites individuals in pop[] with mutated versions)
    mutationRate = gaParams.mutationRate;
    pop = mutateTrusses(pop,nIndivid,costs,numKeep,mutationRate,boundBox);
    
    currIter = currIter + 1;

end

lastFig = figure(); %yum. figs
set(lastFig, 'Color',[0 0 0],'Name','FINAL TRUSS',...
    'NumberTitle','off','OuterPosition',[1050,170,490,455],'MenuBar','none');
lastPlot = axes('Color','none');
idxBest = costs(1,2); %col2 of costs is the idx. see assignCosts()
trussStats = costs(1,:);
lastTruss = pop{idxBest};
uScale = 2;
plotTruss(lastTruss,trussStats,1,uScale, numKeep,boundBox,false);

rot = rotate3d(lastFig);
axis vis3d;
set(rot,'RotateStyle','orbit','Enable','on');
%set(lastPlot, 'Color','black');

ouputTrussData(lastTruss)


end

