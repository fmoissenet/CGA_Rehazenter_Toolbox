% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    plotSegment_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Plot segment parameters
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

% =========================================================================
% Initialise figure
% =========================================================================
figure;
hold on;
axis equal;

% =========================================================================
% ICS
% =========================================================================
quiver3(0,0,0,1,0,0,0.5,'k');
quiver3(0,0,0,0,1,0,0.5,'k');
quiver3(0,0,0,0,0,1,0.5,'k');

% =========================================================================
% Frames of interest
% =========================================================================
n = length(Segment(2).rM(1,1,:));
ni = [1:5:n];

% =========================================================================
% Right forceplate
% =========================================================================
% Proximal enpoint P: centre of pressure
if ~isempty(Segment(1).Q)
    P0x=(permute(Segment(1).Q(4,1,ni),[3,2,1]));
    P0y=(permute(Segment(1).Q(5,1,ni),[3,2,1]));
    P0z=(permute(Segment(1).Q(6,1,ni),[3,2,1]));
    plot3(P0x,P0y,P0z,'ok');
end

% =========================================================================
% Right foot
% =========================================================================
% Proximal enpoint Pt
P1x=(permute(Segment(2).Q(4,1,ni),[3,2,1]));
P1y=(permute(Segment(2).Q(5,1,ni),[3,2,1]));
P1z=(permute(Segment(2).Q(6,1,ni),[3,2,1]));
plot3(P1x,P1y,P1z,'ob');
% Distal endpoints D
D1x=(permute(Segment(2).Q(7,1,ni),[3,2,1]));
D1y=(permute(Segment(2).Q(8,1,ni),[3,2,1]));
D1z=(permute(Segment(2).Q(9,1,ni),[3,2,1]));
plot3(D1x,D1y,D1z,'.b');
plot3([P1x,D1x]',[P1y,D1y]',[P1z,D1z]','b');
% U axis
U1x=(permute(Segment(2).Q(1,1,ni), [3,2,1]));
U1y=(permute(Segment(2).Q(2,1,ni), [3,2,1]));
U1z=(permute(Segment(2).Q(3,1,ni), [3,2,1]));
quiver3(P1x,P1y,P1z,U1x,U1y,U1z,0.5,'b');
% W axis
W1x=(permute(Segment(2).Q(10,1,ni),[3,2,1]));
W1y=(permute(Segment(2).Q(11,1,ni),[3,2,1]));
W1z=(permute(Segment(2).Q(12,1,ni),[3,2,1]));
quiver3(D1x,D1y,D1z,W1x,W1y,W1z,0.5,'b');
% Markers
for j = 1:size(Segment(2).rM,2)
    plot3(permute(Segment(2).rM(1,j,ni),[3,2,1]),...
        permute(Segment(2).rM(2,j,ni),[3,2,1]),...
        permute(Segment(2).rM(3,j,ni),[3,2,1]),'+b');
end
% % Centre of mass
% G1 = Mprod_array3(Q2Tuw_array3(Segment(2).Q),...
%     repmat([Segment(2).rCs;1],[1 1 n]));
% G1x=(permute(G1(1,1,ni),[3,2,1]));
% G1y=(permute(G1(2,1,ni),[3,2,1]));
% G1z=(permute(G1(3,1,ni),[3,2,1]));
% plot3(G1x,G1y,G1z,'*k');

% =========================================================================
% Right shank
% =========================================================================
% Proximal enpoint P
P2x=(permute(Segment(3).Q(4,1,ni),[3,2,1]));
P2y=(permute(Segment(3).Q(5,1,ni),[3,2,1]));
P2z=(permute(Segment(3).Q(6,1,ni),[3,2,1]));
plot3(P2x,P2y,P2z, 'or' );
% Distal endpoints D
D2x=(permute(Segment(3).Q(7,1,ni),[3,2,1]));
D2y=(permute(Segment(3).Q(8,1,ni),[3,2,1]));
D2z=(permute(Segment(3).Q(9,1,ni),[3,2,1]));
plot3(D2x,D2y,D2z, '.r' );
plot3([P2x,D2x]',[P2y,D2y]',[P2z,D2z]','r');
% U axis
U2x=(permute(Segment(3).Q(1,1,ni), [3,2,1]));
U2y=(permute(Segment(3).Q(2,1,ni), [3,2,1]));
U2z=(permute(Segment(3).Q(3,1,ni), [3,2,1]));
quiver3(P2x,P2y,P2z,U2x,U2y,U2z,0.5,'r');
% W axis
W2x=(permute(Segment(3).Q(10,1,ni),[3,2,1]));
W2y=(permute(Segment(3).Q(11,1,ni),[3,2,1]));
W2z=(permute(Segment(3).Q(12,1,ni),[3,2,1]));
quiver3(D2x,D2y,D2z,W2x,W2y,W2z,0.5,'r');
% Markers
for j = 1:size(Segment(3).rM,2)
    plot3(permute(Segment(3).rM(1,j,ni),[3,2,1]),...
        permute(Segment(3).rM(2,j,ni),[3,2,1]),...
        permute(Segment(3).rM(3,j,ni),[3,2,1]),'+r');
end
% % Centre of mass
% G2 = Mprod_array3(Q2Tuw_array3(Segment(3).Q),...
%     repmat([Segment(3).rCs;1],[1 1 n]));
% G2x=(permute(G2(1,1,ni),[3,2,1]));
% G2y=(permute(G2(2,1,ni),[3,2,1]));
% G2z=(permute(G2(3,1,ni),[3,2,1]));
% plot3(G2x,G2y,G2z,'*k');

% =========================================================================
% Right thigh
% =========================================================================
% Proximal enpoint P
P3x=(permute(Segment(4).Q(4,1,ni),[3,2,1]));
P3y=(permute(Segment(4).Q(5,1,ni),[3,2,1]));
P3z=(permute(Segment(4).Q(6,1,ni),[3,2,1]));
plot3(P3x,P3y,P3z,'oc');
% Distal endpoints D
D3x=(permute(Segment(4).Q(7,1,ni), [3,2,1]));
D3y=(permute(Segment(4).Q(8,1,ni), [3,2,1]));
D3z=(permute(Segment(4).Q(9,1,ni), [3,2,1]));
plot3(D3x,D3y,D3z,'.c');
plot3([P3x,D3x]',[P3y,D3y]',[P3z,D3z]','c');
% U axis
U3x=(permute(Segment(4).Q(1,1,ni), [3,2,1]));
U3y=(permute(Segment(4).Q(2,1,ni), [3,2,1]));
U3z=(permute(Segment(4).Q(3,1,ni), [3,2,1]));
quiver3(P3x,P3y,P3z,U3x,U1y,U3z,0.5,'c');
% W axis
W3x=(permute(Segment(4).Q(10,1,ni), [3,2,1]));
W3y=(permute(Segment(4).Q(11,1,ni), [3,2,1]));
W3z=(permute(Segment(4).Q(12,1,ni), [3,2,1]));
quiver3(D3x,D3y,D3z,W3x,W3y,W3z,0.5,'c');
% Markers
for j = 1:size(Segment(4).rM,2)
    plot3(permute(Segment(4).rM(1,j,ni),[3,2,1]),...
        permute(Segment(4).rM(2,j,ni),[3,2,1]),...
        permute(Segment(4).rM(3,j,ni),[3,2,1]),'+c');
end
% % Centre of mass
% G3 = Mprod_array3(Q2Tuw_array3(Segment(4).Q),...
%     repmat([Segment(4).rCs;1],[1 1 n]));
% G3x=(permute(G3(1,1,ni),[3,2,1]));
% G3y=(permute(G3(2,1,ni),[3,2,1]));
% G3z=(permute(G3(3,1,ni),[3,2,1]));
% plot3(G3x,G3y,G3z,'*k');

% =========================================================================
% Right forceplate
% =========================================================================
% Proximal enpoint P: centre of pressure
if ~isempty(Segment(101).Q)
    P0x=(permute(Segment(101).Q(4,1,ni),[3,2,1]));
    P0y=(permute(Segment(101).Q(5,1,ni),[3,2,1]));
    P0z=(permute(Segment(101).Q(6,1,ni),[3,2,1]));
    plot3(P0x,P0y,P0z,'ok');
end

% =========================================================================
% Left foot
% =========================================================================
% Proximal enpoint Pt
P1x=(permute(Segment(102).Q(4,1,ni),[3,2,1]));
P1y=(permute(Segment(102).Q(5,1,ni),[3,2,1]));
P1z=(permute(Segment(102).Q(6,1,ni),[3,2,1]));
plot3(P1x,P1y,P1z,'ob');
% Distal endpoints D
D1x=(permute(Segment(102).Q(7,1,ni),[3,2,1]));
D1y=(permute(Segment(102).Q(8,1,ni),[3,2,1]));
D1z=(permute(Segment(102).Q(9,1,ni),[3,2,1]));
plot3(D1x,D1y,D1z,'.b');
plot3([P1x,D1x]',[P1y,D1y]',[P1z,D1z]','b');
% U axis
U1x=(permute(Segment(102).Q(1,1,ni), [3,2,1]));
U1y=(permute(Segment(102).Q(2,1,ni), [3,2,1]));
U1z=(permute(Segment(102).Q(3,1,ni), [3,2,1]));
quiver3(P1x,P1y,P1z,U1x,U1y,U1z,0.5,'b');
% W axis
W1x=(permute(Segment(102).Q(10,1,ni),[3,2,1]));
W1y=(permute(Segment(102).Q(11,1,ni),[3,2,1]));
W1z=(permute(Segment(102).Q(12,1,ni),[3,2,1]));
quiver3(D1x,D1y,D1z,W1x,W1y,W1z,0.5,'b');
% Markers
for j = 1:size(Segment(102).rM,2)
    plot3(permute(Segment(102).rM(1,j,ni),[3,2,1]),...
        permute(Segment(102).rM(2,j,ni),[3,2,1]),...
        permute(Segment(102).rM(3,j,ni),[3,2,1]),'+b');
end
% % Centre of mass
% G1 = Mprod_array3(Q2Tuw_array3(Segment(102).Q),...
%     repmat([Segment(102).rCs;1],[1 1 n]));
% G1x=(permute(G1(1,1,ni),[3,2,1]));
% G1y=(permute(G1(2,1,ni),[3,2,1]));
% G1z=(permute(G1(3,1,ni),[3,2,1]));
% plot3(G1x,G1y,G1z,'*k');

% =========================================================================
% Left shank
% =========================================================================
% Proximal enpoint P
P2x=(permute(Segment(103).Q(4,1,ni),[3,2,1]));
P2y=(permute(Segment(103).Q(5,1,ni),[3,2,1]));
P2z=(permute(Segment(103).Q(6,1,ni),[3,2,1]));
plot3(P2x,P2y,P2z, 'or' );
% Distal endpoints D
D2x=(permute(Segment(103).Q(7,1,ni),[3,2,1]));
D2y=(permute(Segment(103).Q(8,1,ni),[3,2,1]));
D2z=(permute(Segment(103).Q(9,1,ni),[3,2,1]));
plot3(D2x,D2y,D2z, '.r' );
plot3([P2x,D2x]',[P2y,D2y]',[P2z,D2z]','r');
% U axis
U2x=(permute(Segment(103).Q(1,1,ni), [3,2,1]));
U2y=(permute(Segment(103).Q(2,1,ni), [3,2,1]));
U2z=(permute(Segment(103).Q(3,1,ni), [3,2,1]));
quiver3(P2x,P2y,P2z,U2x,U2y,U2z,0.5,'r');
% W axis
W2x=(permute(Segment(103).Q(10,1,ni),[3,2,1]));
W2y=(permute(Segment(103).Q(11,1,ni),[3,2,1]));
W2z=(permute(Segment(103).Q(12,1,ni),[3,2,1]));
quiver3(D2x,D2y,D2z,W2x,W2y,W2z,0.5,'r');
% Markers
for j = 1:size(Segment(103).rM,2)
    plot3(permute(Segment(103).rM(1,j,ni),[3,2,1]),...
        permute(Segment(103).rM(2,j,ni),[3,2,1]),...
        permute(Segment(103).rM(3,j,ni),[3,2,1]),'+r');
end
% % Centre of mass
% G2 = Mprod_array3(Q2Tuw_array3(Segment(103).Q),...
%     repmat([Segment(103).rCs;1],[1 1 n]));
% G2x=(permute(G2(1,1,ni),[3,2,1]));
% G2y=(permute(G2(2,1,ni),[3,2,1]));
% G2z=(permute(G2(3,1,ni),[3,2,1]));
% plot3(G2x,G2y,G2z,'*k');

% =========================================================================
% Left thigh
% =========================================================================
% Proximal enpoint P
P3x=(permute(Segment(104).Q(4,1,ni),[3,2,1]));
P3y=(permute(Segment(104).Q(5,1,ni),[3,2,1]));
P3z=(permute(Segment(104).Q(6,1,ni),[3,2,1]));
plot3(P3x,P3y,P3z,'oc');
% Distal endpoints D
D3x=(permute(Segment(104).Q(7,1,ni), [3,2,1]));
D3y=(permute(Segment(104).Q(8,1,ni), [3,2,1]));
D3z=(permute(Segment(104).Q(9,1,ni), [3,2,1]));
plot3(D3x,D3y,D3z,'.c');
plot3([P3x,D3x]',[P3y,D3y]',[P3z,D3z]','c');
% U axis
U3x=(permute(Segment(104).Q(1,1,ni), [3,2,1]));
U3y=(permute(Segment(104).Q(2,1,ni), [3,2,1]));
U3z=(permute(Segment(104).Q(3,1,ni), [3,2,1]));
quiver3(P3x,P3y,P3z,U3x,U1y,U3z,0.5,'c');
% W axis
W3x=(permute(Segment(104).Q(10,1,ni), [3,2,1]));
W3y=(permute(Segment(104).Q(11,1,ni), [3,2,1]));
W3z=(permute(Segment(104).Q(12,1,ni), [3,2,1]));
quiver3(D3x,D3y,D3z,W3x,W3y,W3z,0.5,'c');
% Markers
for j = 1:size(Segment(104).rM,2)
    plot3(permute(Segment(104).rM(1,j,ni),[3,2,1]),...
        permute(Segment(104).rM(2,j,ni),[3,2,1]),...
        permute(Segment(104).rM(3,j,ni),[3,2,1]),'+c');
end
% % Centre of mass
% G3 = Mprod_array3(Q2Tuw_array3(Segment(104).Q),...
%     repmat([Segment(104).rCs;1],[1 1 n]));
% G3x=(permute(G3(1,1,ni),[3,2,1]));
% G3y=(permute(G3(2,1,ni),[3,2,1]));
% G3z=(permute(G3(3,1,ni),[3,2,1]));
% plot3(G3x,G3y,G3z,'*k');

% =========================================================================
% Pelvis
% =========================================================================
% Proximal enpoint P
P4x=(permute(Segment(5).Q(4,1,ni), [3,2,1]));
P4y=(permute(Segment(5).Q(5,1,ni), [3,2,1]));
P4z=(permute(Segment(5).Q(6,1,ni), [3,2,1]));
plot3(P4x,P4y,P4z,'om');
% Distal endpoints D
D4x=(permute(Segment(5).Q(7,1,ni), [3,2,1]));
D4y=(permute(Segment(5).Q(8,1,ni), [3,2,1]));
D4z=(permute(Segment(5).Q(9,1,ni), [3,2,1]));
plot3(D4x,D4y,D4z,'.m');
plot3([P4x,D4x]',[P4y,D4y]',[P4z,D4z]','m');
% U axis
U4x=(permute(Segment(5).Q(1,1,ni), [3,2,1]));
U4y=(permute(Segment(5).Q(2,1,ni), [3,2,1]));
U4z=(permute(Segment(5).Q(3,1,ni), [3,2,1]));
quiver3(P4x,P4y,P4z,U4x,U4y,U4z,0.5,'m');
% W axis
W4x=(permute(Segment(5).Q(10,1,ni), [3,2,1]));
W4y=(permute(Segment(5).Q(11,1,ni), [3,2,1]));
W4z=(permute(Segment(5).Q(12,1,ni), [3,2,1]));
quiver3(D4x,D4y,D4z,W4x,W4y,W4z,0.5,'m');
% Markers
for j = 1:size(Segment(5).rM,2)
    plot3(permute(Segment(5).rM(1,j,ni),[3,2,1]),...
        permute(Segment(5).rM(2,j,ni),[3,2,1]),...
        permute(Segment(5).rM(3,j,ni),[3,2,1]),'+m');
end
% % Centre of mass
% G4 = Mprod_array3(Q2Tuw_array3(Segment(5).Q),...
%     repmat([Segment(5).rCs;1],[1 1 n]));
% G4x=(permute(G4(1,1,ni),[3,2,1]));
% G4y=(permute(G4(2,1,ni),[3,2,1]));
% G4z=(permute(G4(3,1,ni),[3,2,1]));
% plot3(G4x,G4y,G4z,'*k');