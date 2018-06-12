% FUNCTION
% Q2Tuv_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of homogenous matrix from generalized coordinates
%
% SYNOPSIS
% T = Q2Tuv_array3(Q)
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
% Z = u x v / ||u x v|| 
%
% REFERENCE
% R Dumas, L Cheze. 3D inverse dynamics in non-orthonormal segment 
% coordinate system. Medical & Biological Engineering & Computing 2007;
% 45(3):315-22
% R Dumas, T Robert, V Pomero, L Cheze. Joint and segment coordinate 
% systems revisited. Computer Methods in Biomechanics and Biomedical  
% Engineering. 2012;(15 Suppl 1):183-5
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
% March 2010
%
% Modified by Raphaël Dumas
% July 2012
% Renamed from Q2Tu_array3.m to Q2Tuv_array3.m
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function T = Q2Tuv_array3(Q)

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
B(2,2,:) = L.*sind(gamma);
B(2,3,:) = (cosd(alpha) - cosd(beta).*cosd(gamma))./sind(gamma);
B(3,3,:) = sqrt(1 - cosd(beta).^2 - ((cosd(alpha) - cosd(beta).*cosd(gamma))./sind(gamma)).^2);
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
