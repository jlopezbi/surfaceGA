function [costs,currMinFit,avgCost ] = assignCosts(pop,nIndivid,costWeights)
%[costs,currMinFIt ] = assignCosts(pop,nIndivid,costWeights)
%1)run deflection tests
%2)calculate weightitunes
%
%
%input:
%   pop = cell array of truss structs (genes)
%   numIndivid = number of individuals
%   costWeights = [nCosts x 1] matrix with wieghts. r1 = deflection,u
%                 r2 = mass, m. later this will somehow turn into a parameter for
%                 pareto-frontier mate selection
%output:
%   costs = [numIndivid x 4] array, ordere by descending rank
%               col1 = cost
%               col2 = idx of individual
%               col3 = max displacement U (right now in Z-dir)
%               col4 = mass
%   currMinFit = lowest cost in the population (!) 
%   avgCost = average cost for the population


%FIND MAX DEFLECTION MATRIX
uMult = 1;
uScores = findMaxDeflection(pop,nIndivid,uMult);

%CALCULATE MASS MATRIX
mScores = calcMass(pop,nIndivid);

%COMBINE SCORES
costs = NaN(nIndivid,2);
costs(:,1) = uScores(:,1)*costWeights(1)+mScores(:,1)*costWeights(2);
costs(:,2) = 1:nIndivid;
costs(:,3) = uScores;
costs(:,4) = mScores;
costs = sortrows(costs);
currMinFit = costs(1,1);
avgCost = mean(costs(:,1));


end

function [uScores] = findMaxDeflection(pop,nIndivid, uMult)
% [uScores] = calcDeflection(pop)
%output max Z deflection^2
%%% later try max deflection of specific point(s?)
%input:
%   pop = cell array of truss structs
%   nIndivid = number of trusses
%   uMult = multiplier for displacements (exaggerates displacements)
%output:
%   uScores = [numIdivid x 2], first column is the maximum displacement,
%               second column is the index of that individual
%               NaN if no U scores matrix is available (is NaN)
if(~exist('uMult','var'))
    uMult = 1;
end

uScores = NaN(nIndivid,1);
for i = 1:nIndivid
    %maximum abosulte val z deflection for a given truss
    U = pop{i}.U;
    if(size(U,1)==3)
        maxU = max(abs(U(3,:)));
        uScores(i,1) = maxU*uMult;
    else
        fprintf('error in .U matrix!; nRows should = 3\n');
    end
end

end

function [massScores] = calcMass(pop,nIndivid,DENSITY)
% [uScores] = calcDeflection(pop)
%creates deflection scores matrix for a generation.  uses max Z deflection
%%% later try max deflection of specific point(s?)
%input:
%   pop = cell array of truss structs
%   numIndivid = number of trusses
%output:
%   massScores = [numIdivid x 1], mass of each individ, NaN if no areas,
%                connectors or coordanites matrix is available

if(~exist('DENSITY','var'))
    DENSITY = .0966435; %for aluminum, lb/in^3
end

massScores = NaN(nIndivid,1);
for i = 1:nIndivid
    hasA = isfield(pop{i}, 'A');
    hasCon = isfield(pop{i}, 'Con');
    hasCoord = isfield(pop{i}, 'Coord');
    
    if(hasA && hasCon && hasCoord)
        areas = pop{i}.A';
        edges = pop{i}.Con; % 2 x nEdges
        verts = pop{i}.Coord;
        
        p1 = verts(:,edges(1,:));
        p2 = verts(:,edges(2,:));
        
        
        dists = distanc(p1,p2);
        
        %     fprintf('distances\n');
        %     disp(dists);
        %     fprintf('areas\n');
        %     disp(areas);
        
        volume = sum(areas.*dists);
        mass = DENSITY*volume;
        %     fprintf('mass for %d\n',i);
        %     disp(mass);
        massScores(i) = mass;
    else
        massScores(i) = NaN;
    end
    
end

end

function dist = distanc(p1,p2)
% Eucliden distance between points
% rows: different points
% columns: value of each dimension
%
%
% MatSprings: Matlab 3D spring truss simulator
%
% Copyright (C) 2008 Daniel Lobo (dlobo@geb.uma.es)
%
%    This file is part of MatSprings.
%
%    MatSprings is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    MatSprings is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%	 along with MatSprings.  If not, see <http://www.gnu.org/licenses/>

dist = sqrt(sum((p1 - p2).^2, 1));
end


