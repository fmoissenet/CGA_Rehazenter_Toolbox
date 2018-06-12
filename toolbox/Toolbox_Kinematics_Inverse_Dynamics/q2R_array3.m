% FUNCTION
% q2R_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of rotation matrix from quaternion 
%
% SYNOPSIS
% R = q2R_array3(q)
%
% INPUT
% q (i.e., quaternion)
%
% OUTPUT
% R (i.e., rotation matrix)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the rotation matrix (R) from the quaternion (q)
%
% REFERENCE
% R Dumas, R Aissaoui, J A de Guise. A 3D generic inverse dynanmic method 
% using wrench notation and quaternion algebra. Computer Methods in 
% Biomechanics and Biomedical Engineering 2004;7(3):159-166
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% None
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
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function R = q2R_array3(q)

% Quaternion in dimension (4*n)
quaternion = permute(q,[1,3,2]);
% Square of terms
quaternion2 = quaternion.^2; 

% Terms of rotation matrix in dimension (1*n)
r11(1,:) = quaternion2(1,:) + quaternion2(2,:) - quaternion2(3,:) - quaternion2(4,:);
r22(1,:) = quaternion2(1,:) - quaternion2(2,:) + quaternion2(3,:) - quaternion2(4,:);
r33(1,:) = quaternion2(1,:) - quaternion2(2,:) - quaternion2(3,:) + quaternion2(4,:);
r12(1,:) = (2*quaternion(2,:) .* quaternion(3,:)) - (2*quaternion(1,:) .* quaternion(4,:));
r13(1,:) = (2*quaternion(1,:) .* quaternion(3,:)) + (2*quaternion(2,:) .* quaternion(4,:));
r21(1,:) = (2*quaternion(2,:) .* quaternion(3,:)) + (2*quaternion(1,:) .* quaternion(4,:));
r23(1,:) = -(2*quaternion(1,:) .* quaternion(2,:)) + (2*quaternion(3,:) .* quaternion(4,:));
r31(1,:) = -(2*quaternion(1,:) .* quaternion(3,:)) + (2*quaternion(2,:) .* quaternion(4,:));
r32(1,:) = (2*quaternion(1,:) .* quaternion(2,:)) + (2*quaternion(3,:) .* quaternion(4,:));

% Rotation matrix of dimension (3*3*n)
R(:,:,:) = [permute(r11,[1,3,2]),permute(r12,[1,3,2]),permute(r13,[1,3,2]);...
        permute(r21,[1,3,2]),permute(r22,[1,3,2]),permute(r23,[1,3,2]);...
        permute(r31,[1,3,2]),permute(r32,[1,3,2]),permute(r33,[1,3,2])];
    