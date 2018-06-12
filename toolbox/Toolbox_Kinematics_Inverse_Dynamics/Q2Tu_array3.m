% FUNCTION
% Q2Tu_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of homogenous matrix from generalized coordinates
%
% SYNOPSIS
% T = Q2Tu_array3(Q)
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
% (Q) with axis correspondence u = X and origin at endpoint P
%
% REFERENCE
% R Dumas, L Cheze. 3D inverse dynamics in non-orthonormal segment 
% coordinate system. Medical & Biological Engineering & Computing 2007;
% 45(3):315-22
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Mprod_array3.m
% Minv_array3.m
%
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%__________________________________________________________________________

function T = Q2Tu_array3(Q)

L = sqrt(sum((Q(4:6,1,:) - Q(7:9,1,:)).^2));
% Alpha angle between (rP - rD) and w
a = acos(dot(Q(4:6,1,:) - Q(7:9,1,:),Q(10:12,1,:))./...
    sqrt(sum((Q(4:6,1,:) - Q(7:9,1,:)).^2)))*180/pi;
% Beta angle between u and w
b = acos(dot(Q(1:3,1,:),Q(10:12,1,:)))*180/pi;
% Gamma angle between u and (rP - rD)
c = acos(dot(Q(1:3,1,:),Q(4:6,1,:) - Q(7:9,1,:))./...
    sqrt(sum((Q(4:6,1,:) - Q(7:9,1,:)).^2)))*180/pi;

% B matrix from (u,rP-rD,w) to (X,Y,Z)
B(1,2,:) = L.*cosd(c);
B(1,3,:) = cosd(b);
B(2,2,:) = L.*sind(c);
B(2,3,:) = (cosd(a) - cosd(b).*cosd(c))./sind(c);
B(3,3,:) = sqrt(1 - cosd(b).^2 - ((cosd(a) - cosd(b).*cosd(c))./sind(c)).^2);
B(1,1,:) = 1;

% [X Y Z rP] = [[u rP-rD w]*B-1 rP]
T = [Mprod_array3([Q(1:3,1,:),Q(4:6,1,:) - Q(7:9,1,:),Q(10:12,1,:)],...
    Minv_array3(B)),Q(4:6,1,:)];
T(4,4,:) = 1;

% % Alternatively
% % Orthonormal axis
% X = Q(1:3,1,:); % X = u
% Z = Vnorm_array3(cross(X,Q(4:6,1,:) - Q(7:9,1,:))); % X x (rP - rD)
% Y = Vnorm_array3(cross(Z,X));
% 
% % Homogenous matrix
% T = [X, Y, Z, Q(4:6,1,:)]; 
% T(4,4,:) = 1;
