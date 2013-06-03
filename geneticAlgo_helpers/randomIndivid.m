function [individual] = randomIndivid(templateTruss,boundBox,mean,sD)
%[individual] = randomIndivid(templateTruss,boundBox,mean,sD)
%create a random individual from a template individual by replacing mutable
%verts with random verts
%later add in random areas!!, choice for changes in topology!
%
%input:
%   templateTruss = graph of truss already converted from mesh using
%                   generateGraphFromMesh()
%   boundBox = [X,Y,Z] dimensions of maximum contraint box, corner at origin
%   mean = center of normal distribution for random offset
%   sD = standard deviation for normal dist. for random variable
%output:
%   individual = mutated individual.

%global boundBox;

numVerts = size(templateTruss.Coord,2);
noChangeVerts = cat(2, templateTruss.loaded, templateTruss.fixed);
individual = templateTruss;
xDim = boundBox(1);
yDim = boundBox(2);
zDim = boundBox(3);

for i = 1:numVerts
    if(~any(i==noChangeVerts))
        offset = random('Normal',mean,sD,3,1);
        %disp(offset);
        individual.Coord(:,i) = individual.Coord(:,i)+offset;
    end
end

end

