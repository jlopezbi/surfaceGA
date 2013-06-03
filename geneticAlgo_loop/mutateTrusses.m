function pop = mutateTrusses(pop,numIndivid,costs,numKeep,mutationRate,boundBox)
%pop = mutateTrusses(pop,numIndivid,costs,numKeep,mutationRate,boundBox)
%   mutate Trusses!! start with only mutating the verts
%   two categories of mutations: 
%       1) geometry mutation (continous)
%       2) topology mutation (continous and discrete)
%input:
%   pop = cell array full of truss structs
%   numIndivid = number of trusses (individuals)
%   costs = [numIndivid x 2] array, first col is the cost, second is the
%           index of that individual. sorted according to rank
%   numKeep = number of trusses that are kept as parents
%   mutationRate = percentage of all the data that can be mutated
%   boundBox = [X,Y,Z] box with diagonal corner at origin. constraint
%output:
%   pop = cell array of truss structs

numVertsPerTruss = size(pop{1}.Coord, 2);
numMutations = ceil(mutationRate*numVertsPerTruss*numIndivid);
%fprintf('# vert mutations: %d\n',numMutations);
idxTrussCanMutate = sort(costs(numKeep+1:end,2));

%GEOM MUTATION (VERTS)
pop = mutateVerts(pop, idxTrussCanMutate, numMutations,boundBox);

end

function pop = mutateVerts(pop, idxTrussCanMutate,numMutations,boundBox)
%[mutatedVerts] = mutateVerts(boxLen,pop,idxCanMutate,mutationRate)
%mutate vertices using local constraints on mutation


numVerts = size(pop{1}.Coord,2);
idxVertNoMutate = cat(2,pop{1}.loaded,pop{1}.fixed);
idxVertCanMutate = setdiff(1:numVerts,idxVertNoMutate);
numVertCanMutate = size(idxVertCanMutate,2);


for i = 1:numMutations
    randTruss = randi(size(idxTrussCanMutate,1));
    idxTruss = idxTrussCanMutate(randTruss);
    randVert = randi(numVertCanMutate);
    idxVert = idxVertCanMutate(randVert);
    %fprintf('mutated truss %d\n',idxTruss);
    if(isfield(pop{idxTruss}, 'mutatedVerts'))
        %fprintf('       had mutatedVerts added idxVert:,%d\n',idxVert);
        pop{idxTruss}.mutatedVerts = cat(2,pop{idxTruss}.mutatedVerts,idxVert);
    else
        %fprintf('       new mutatedVerts added idxVert:,%d\n',idxVert);
        pop{idxTruss}.mutatedVerts = idxVert;
    end
    
    initVert = pop{idxTruss}.Coord(:,idxVert);
    pop{idxTruss}.Coord(:,idxVert) = randomVert(initVert,boundBox);
    
end

end

    function newVert = randomVert(initVert,boundBox)
        mean = 0;
        sD = .2;
        offsets = random('Normal',mean,sD,3,1);
        newVert = offsets+initVert;
        
        %Constrain X to boundBoxX [-30.2,0]
        if(newVert(1)<boundBox(1))
            newVert(1) = boundBox(1);
        elseif newVert(1)>0
            newVert(1) = 0;
        end
        
        %Constrain Y to boundBoxY [0,30]
        if(newVert(2)>boundBox(2))
            newVert(2) = boundBox(2);
        elseif newVert(2)<0
            newVert(2) = 0;
        end
        
        %Constrain Z to boundBoxZ [0,17.8]
        if(newVert(3)>boundBox(3))
            newVert(3) = boundBox(3);
        elseif newVert(3)<0
            newVert(3) = 0;
        end
        
        %disp(newVert);
        
    end