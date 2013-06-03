function [maits] = selMatePairs( costs,numKeep )
%[ maitPairs ] = selMatePairs( costs )
%selects the mate pairs using rank selection. (other options later)
%input:
%   costs = [numIndivid x2] array, col1 is cost, col2 is index in pop,
%           ordered by rank
%ouput:
%   maitPairs = [numPairs x 2] array, col1 = mom, col2 = dad, :)
%               if numKeep is odd then someone mates twice

numPairs = ceil(numKeep/2);
maits = zeros(numPairs,2);
for i =1:numPairs
    mI = 2*i-1; %mom is 1,3,5,7... dad is 2,4,6...
    mom = costs(mI,2);
    if (i==numPairs && mod(numKeep,2)==1)
        %last pair, if it was an odd numKeep, use random dad
        %(hermaphodites,clearly)
        dad = costs(randi(numKeep),2);
    else
        dad = costs(mI+1,2);
    end
    
    maits(i,:) = [mom,dad];
end


end
