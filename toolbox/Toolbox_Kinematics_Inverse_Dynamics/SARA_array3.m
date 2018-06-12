% FUNCTION
% SARA_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Functional method for axis of rotation (AoR)
%
% SYNOPSIS
% [a,asi,asj,rA,rAsi,rAsj] = SARA_array3(Ti,Tj)
%
% INPUT
% Ti        (4*4*n) = Homogenous matrix of transformation
%                     from ICS to SCS of segment i (e.g. proximal)
% Tj        (4*4*n) = Homogenous matrix of transformation
%                     from ICS to SCS of segment j (e.g. distal)
%
% OUTPUT
% a        (3*1*n) = Orientation of AoR expressed in ICS
% asi      (3*1) = Orientation of AoR expressed
%                  in SCS of segment i (e.g. proximal)
% asj      (3*1) = Orientation of AoR expressed
%                  in SCS of segment j (e.g. distal)
% rA        (3*1*n) = Position of a point A of AoR
%                     expressed in ICS
% rAsi      (3*1) = Position of a point A of AoR
%                   expressed in SCS of segment i (e.g. proximal)
% rAsj      (3*1) = Position of a point A of AoR
%                   expressed in SCS of segment j (e.g. distal)
%
% DESCRIPTION
% Computation of the averaged axis of rotation (AoR) between two segments
% (e.g. proximal and distal) by symmetrical axis of rotation approach
% (SARA)
%
% REFERENCES
% RM Ehrig, WR Taylor, GN Duda, MO Heller. A survey of formal methods for
% determining functional joint axes. Journal of Biomechanics
% 2007; 40: 2150–2157.
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% 
% MATLAB VERSION
% Matlab R2016a
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% February 2009
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function [a,asi,asj,rA,rAsi,rAsj] = SARA_array3(Ti,Tj)

% Number of frames
n = size(Ti,3);

% Matrices of least square system [Ri - Rj]*[rCsi;rCsj] = [rPj-rPi]
Ri(1:3:3*n-2,1:3) = permute(Ti(1,1:3,:), [3,2,1]);
Ri(2:3:3*n-1,1:3) = permute(Ti(2,1:3,:), [3,1,2]);
Ri(3:3:3*n,1:3) = permute(Ti(3,1:3,:), [3,1,2]);
Rj(1:3:3*n-2,1:3) = permute(Tj(1,1:3,:), [3,2,1]);
Rj(2:3:3*n-1,1:3) = permute(Tj(2,1:3,:), [3,1,2]);
Rj(3:3:3*n,1:3) = permute(Tj(3,1:3,:), [3,1,2]);
R = [Ri -Rj];

p(1:3:3*n-2,1) = permute(Tj(1,4,:) - Ti(1,4,:), [3,2,1]);
p(2:3:3*n-1,1) = permute(Tj(2,4,:) - Ti(2,4,:), [3,1,2]);
p(3:3:3*n,1) = permute(Tj(3,4,:) - Ti(3,4,:), [3,1,2]);

% Singular Value Decomposition
[U,S,V] = svd(R);

% Orientation of AoR expressed in ICS
a = mean([Mprod_array3(Ti(1:3,1:3,:),...
    repmat(V(1:3,6)/norm(V(1:3,6)),[1,1,n])), ...
    Mprod_array3(Tj(1:3,1:3,:),...
    repmat(V(4:6,6)/norm(V(4:6,6)),[1,1,n]))],2);

if nargout == 3
    
    % Orientation of AoR expressed in SCS of segments i and j
    asi = V(1:3,6)/norm(V(1:3,6)); % Normalized
    asj = V(4:6,6)/norm(V(4:6,6)); % Normalized
    
elseif nargout == 6
    
    % Orientation of AoR expressed in SCS of segments i and j
    asi = V(1:3,6)/norm(V(1:3,6)); % Normalized
    asj = V(4:6,6)/norm(V(4:6,6)); % Normalized
    
    % Solution of the least square system with minimal norm
    for i = 1:5
        xi(:,i) = U(:,i)'*p*V(:,i)/S(i,i);
    end
    x = sum(xi,2);
    
    % Position of a point A of AoR in SCS of segments i and j
    % First three components of x orthogonalised relative to ai
    rAsi = x(1:3,1) - (x(1:3,1)'*asi)*asi;
    % Last three components of x orthogonalised relative to aj
    rAsj = x(4:6,1) - (x(4:6,1)'*asj)*asj;
    
    % Position of a point A of AoR expressed in ICS
    rA = mean([Mprod_array3(Ti,repmat([rAsi;1], [1,1,n])), ...
        Mprod_array3(Tj,repmat([rAsj;1], [1,1,n]))],2);
    rA(4,:,:) = [];
    
end
