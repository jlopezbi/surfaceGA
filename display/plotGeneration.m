function figureH = plotGeneration(pop, figureH, costs,numKeep,boundBox,numDisplay)
%figureH = plotGeneration(pop, figureH, costs,numKeep,boundBox,numDisplay)
%visualize generation
%input:
%   pop = population [nIndivid x 1] cell array
%   figureH = figure handel to be updated (if exists)
%   costs = [nIndivid x 2] array of costs (:,1) = costs (:,2) = idxs
%   numKeep = number individuals to keep, pass to plotTruss
%   boundBox = bounding box, pass to plotTruss
%   numDisplay = number if individuals to display

if(isempty(figureH))
    figureH = figure('Color',[0 0 0],'OuterPosition',[540,640,1000,500],...
    'DockControls','off');
end

uScale = 2;

nIndivid = size(pop,1);
if(numDisplay>nIndivid)
    numDisplay = nIndivid;
end

for i = 1:numDisplay
    idxTruss = costs(i,2);
    trussStats = costs(i,:);
    rank = i;
    m=2;
    n = floor(numDisplay/2);
    if(n<1)
        n=1;
    end
    h = subplot(m,n,i,'replace','Color','White');
    set(h, 'Color','none');
    currTruss = pop{idxTruss};
    plotTruss(currTruss,trussStats,rank,uScale,numKeep,boundBox,false); 
end

end



