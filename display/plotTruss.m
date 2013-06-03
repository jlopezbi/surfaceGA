function plotTruss(truss,trussStats,rank,uScale, numKeep,boundBox,plotDeformed)
%trussH = plotTruss(truss,trussStats,rank,uScale, numKeep,boundBox,plotDeformed)
%   plot a truss in 3d
%   Current Features:
%       -plot loaded nodes as RED
%       -plot fixed nodes as BLUE
%       -plot mutated nodes as CYAN
%       -plot grey deformed truss
%       -plot original truss with color code for strain
%       -Display rank, cost, uMax, mass

if(~exist('uScale', 'var'))
    uScale = 1;end
if(~exist('rank','var'))
    rank = 1;end
if(~exist('fitness','var'))
    fitness = -1;end
if(~exist('numKeep','var'))
    numKeep = 0;end
if(~exist('boundBox','var'))
    boundBox = [-30.2,30,17.8];end

hold on;
if(isfield(truss, 'U') && isfield(truss,'F'))
    forces = truss.F';
    displ = truss.U;
else
    forces = 0.0;
    displ = 0.0;
end

%% PLOT TRUSS

edges = truss.Con;
verts = truss.Coord;
modulii = truss.E;
areas = truss.A;
strains = forces./(modulii.*areas);
stressMax = max(strains);
stressMin = min(strains);

lnMin = .2;
lnMax = 3;
lnRange = lnMax-lnMin;

for i = 1:size(truss.Con,2);
    %plot original truss with colors for strain (tension/compression)
    strain = strains(i);
    if(strain >0)
        color = [180/255 0 151/255];
    else
        color = [192/255 244/255 0];
    end
    %color = mapStrainToColor(strain,stressMax,stressMin);
    lineWidth = mapStrainToLnWidth(strain,stressMax,stressMin,lnMin,lnRange);
    X = [truss.Coord(1,truss.Con(1,i)), truss.Coord(1,truss.Con(2,i))];
    Y = [truss.Coord(2,truss.Con(1,i)), truss.Coord(2,truss.Con(2,i))];
    Z = [truss.Coord(3,truss.Con(1,i)), truss.Coord(3,truss.Con(2,i))];
    line(X,Y,Z,'Color',color, 'LineWidth', lineWidth);
    if(plotDeformed)
        %plot deformed truss as grey lines
        x = [X(1)+displ(1,truss.Con(1,i))*uScale, X(2)+displ(1,truss.Con(2,i))*uScale];
        y = [Y(1)+displ(2,truss.Con(1,i))*uScale, Y(2)+displ(2,truss.Con(2,i))*uScale];
        z = [Z(1)+displ(3,truss.Con(1,i))*uScale, Z(2)+displ(3,truss.Con(2,i))*uScale];
        line(x,y,z,'Color',[.7,.7,.7]);
    end
end
%% PLOT FIXED NODES AS BLUE

A = truss.Coord(:,truss.fixed);
B = A';
plot3(B(:,1),B(:,2),B(:,3),'Marker','.','MarkerEdgeColor','b','LineStyle','none');

%% PLOT LOADED NODES AS BLUE x
C = truss.Coord(:,truss.loaded);
E = C';
plot3(E(:,1),E(:,2),E(:,3),'Marker','.','MarkerEdgeColor','r','LineStyle','none');

%% PLOT MUTATED NODES AS RED
if(isfield(truss,'mutatedVerts'))
    F = truss.Coord(:,truss.mutatedVerts);
    G = F';
    %greenish = [.78,.956,.427];
    plot3(G(:,1),G(:,2),G(:,3),'Marker','.','Color','c','LineStyle','none');
end

%% PLOT BOUND BOX

x = boundBox(1);
y = boundBox(2);
z = boundBox(3);
Da = [[0 0 0];
     [0 0 z];
     [0 y z];
     [0 y 0];
     [0 0 0];
     [x 0 0];
     [x 0 z];
     [x y z];
     [x y 0];
     [x 0 0];
    ];
Db = [[0 y 0];
      [x y 0];];
Dc = [[0 y z];
       [x y z]];
Dd = [[0 0 z];
       [x 0 z]];
line(Da(:,1),Da(:,2),Da(:,3),'LineStyle','--');
line(Db(:,1),Db(:,2),Db(:,3),'LineStyle','--');
line(Dc(:,1),Dc(:,2),Dc(:,3),'LineStyle','--');
line(Dd(:,1),Dd(:,2),Dd(:,3),'LineStyle','--');

%% LIMITS
%axis fill;
axis equal;
%axis vis3d;

xlim([x,0]);
ylim([0 y]);
zlim([0 z]);
%zoom on;
%rot = rotate3d on;
set(gca, 'XTick', [],'YTick', [],'ZTick', []); %turns off tick marks

%% TITLE
cost = trussStats(1);
uMax = trussStats(3);
mass = trussStats(4);
titleStrMain = ['RANK: ', num2str(rank),', COST: ',num2str(cost)];  
titleStrSub = ['uMax: ',num2str(uMax),' mass: ',num2str(mass)];
titleH = title({titleStrMain;titleStrSub});
set(titleH,'Color','w');
% if(numKeep-rank>=0)
%     set(titleH, 'Color', 'b');
% end

view(3);
end





















