
function pop = updateTrusses(pop,nIndivid)
%analyizeTrusses(trusses,E)
%analyize a bunch of trusses using direct stiffness method
%input:
%   trusses = cell array column vector of truss structs
%output:
%   trusses = modified trusses with .F, .U and .R fields (overwrites)

%global pop, N_INDIVID;
for i = 1:nIndivid
    %truss = trusses{i};
    [F, U, R] = analyizeTruss(pop{i});
    pop{i}.F = F; %forces along members
    pop{i}.U = U; %displacements
    pop{i}.R = R; %reaction force vectors
end

end



