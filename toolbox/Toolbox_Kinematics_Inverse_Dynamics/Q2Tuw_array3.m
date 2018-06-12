% FUNCTION
% Q2Tuw_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of homogenous matrix from generalized coordinates
%
% SYNOPSIS
% T = Q2Tuw_array3(Q)
%
% INPUT
% Q (i.e., generalized coordinates)
%
% OUTPUT
% T (i.e., homogenous matrix)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the homogenous matrix (T) from generalized coordinates
% (Q) with origin at endpoint P and axis correspondence X = u,
% Y = w x u / ||w x u|| 
%
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% Minv_array3.m
%
% MATLAB VERSION
% Matlab R2016a
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% July 2012
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function T = Q2Tuw_array3(Q)

L = sqrt(sum((Q(4:6,1,:) - Q(7:9,1,:)).^2));
% Alpha angle between (rP - rD) and w
alpha = acos(dot(Q(4:6,1,:) - Q(7:9,1,:),Q(10:12,1,:))./...
    sqrt(sum((Q(4:6,1,:) - Q(7:9,1,:)).^2)))*180/pi;
% Beta angle between u and w
beta = acos(dot(Q(1:3,1,:),Q(10:12,1,:)))*180/pi;
% Gamma angle between u and (rP - rD)
gamma = acos(dot(Q(1:3,1,:),Q(4:6,1,:) - Q(7:9,1,:))./...
    sqrt(sum((Q(4:6,1,:) - Q(7:9,1,:)).^2)))*180/pi;

% B matrix from (u,rP-rD,w) to (X,Y,Z)
B(1,2,:) = L.*cosd(gamma);
B(1,3,:) = cosd(beta);
B(2,2,:) = L.*sqrt(1 - cosd(gamma).^2 - ((cosd(alpha) - cosd(gamma).*cosd(beta))./sind(beta)).^2);
B(3,2,:) = L.*(cosd(alpha) - cosd(gamma).*cosd(beta))./sind(beta);
B(3,3,:) = sind(beta);
B(1,1,:) = 1;

% [X Y Z rP] = [[u rP-rD w]*B-1 rP]
T = [Mprod_array3([Q(1:3,1,:),Q(4:6,1,:) - Q(7:9,1,:),Q(10:12,1,:)],...
    Minv_array3(B)),Q(4:6,1,:)];
T(4,4,:) = 1;

% % Alternatively
% % Orthonormal axis
% X = Q(1:3,1,:); % X = u
% Y = Vnorm_array3(cross(Q(10:12,1,:),X)); % w x u
% Z = Vnorm_array3(cross(X,Y));
% 
% % Homogenous matrix
% T = [X, Y, Z, Q(4:6,1,:)]; 
% T(4,4,:) = 1;
