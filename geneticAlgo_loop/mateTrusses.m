function pop =  mateTrusses(pop,matePairs,nIndivid,numKeep)
%mateTrusses(pop matePairs,numIndivid,numKeep)
%various mating schemes, start with random single point cross-over for only 
%vertices
%
%input:
%   pop = [nIndivid x1] array of structs which are trusses (genomes)
%   matePairs = [nPairs x 2] array of individuals to be mated from pop
%   numIndivid = number of individuals in pop
%   numKeep = number of parents, parents are also carried over into next ge
%ouput:
%   pop = new population

numPairs = size(matePairs,1);
numKids = nIndivid - numKeep;
idxCull = setdiff(1:nIndivid, matePairs(:));
assert(size(idxCull,2)==numKids);
%disp(idxCull);

kidsPerPair = floor(numKids/numPairs);
nOddKids = mod(numKids,numPairs);

assert(kidsPerPair*numPairs + nOddKids == numKids);

idxKid = 1;
oddKid = 1;
for i =1:numPairs
    mom = pop{matePairs(i,1)};
    dad = pop{matePairs(i,2)};
    for j = 1:kidsPerPair
        idxReplace = idxCull(1,idxKid);
        pop{idxReplace} = snglPntCrossOver(mom,dad);
        idxKid = idxKid+1;
    end
    
    if(oddKid<=nOddKids)
        %add an extra kid: the first nOddKids pairs get an extra kid. yay!
        idxReplace = idxCull(1,idxKid);
        pop{idxReplace} = snglPntCrossOver(mom,dad);
        idxKid = idxKid+1;
        oddKid = oddKid + 1;
        %looks like this ^ could be a little function called newKid or
        %something
    end
    
end



end

