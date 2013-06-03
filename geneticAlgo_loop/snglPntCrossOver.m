function [kid] = snglPntCrossOver(mom,dad)
%[ kidsArray ] = snglPntCrossOver(mom,dad,numKids)
%   ONLY VERTS (for now), chooses random point along mutable verts and
%   swaps verts to make a kid. ASSUMES SAME NUMBER OF VERTS!!!!
%
%input:
%   mom = truss struct parent1
%   dad = truss struct parent2
%   idxReplace = index in pop to overwrite
%ouput:??
%   kid = new truss struct with verts combined from mom and dad
kid = mom;
momVerts = mom.Coord;
dadVerts = dad.Coord;
numVertsMom = size(momVerts,2);
numVertsDad = size(dadVerts,2);
assert(all(mom.fixed == dad.fixed));
%this assumes no change in vert # (truss topology is const)
assert(numVertsMom==numVertsDad);

crossPoint = randi([2,numVertsMom-1]);

randN = randi(2);
if(randN == 1)
    %mom's genes first
    kid.Coord = cat(2,mom.Coord(:,1:crossPoint),...
        dad.Coord(:,crossPoint+1:end));
elseif(randN ==2)
    %dad's genes first
    kid.Coord = cat(2,dad.Coord(:,1:crossPoint),...
        mom.Coord(:,crossPoint+1:end));
end


end

