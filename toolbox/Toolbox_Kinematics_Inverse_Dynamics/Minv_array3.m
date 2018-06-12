% FUNCTION
% Minv_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of matrix inverse 
%
% SYNOPSIS
% B = Minv_array3(A)
%
% INPUT
% A (i.e., matrix) 
%
% OUTPUT
% B (i.e., matrix)
%
% DESCRIPTION
% Computation of the inverse of a square matrix made for all frames (i.e.,
% in 3rd dimension, cf. data structure in user guide) in the case of 
% rotation matrix (R)
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

function B = Minv_array3(A)

if size(A,2) == 3 & ... % Rotation matrix R
        mean(dot(cross(A(:,1,:),A(:,2,:)),A(:,3,:)),3) == 1
    % Determinant 3x3 is mixt product

    % Transposition of rotation matrix
    % with transpose = permute( ,[2,1,3])
    B = permute(A,[2,1,3]);

else % Clasical inversion frame by frame
    for n = 1:size(A,3)
        B(:,:,n) = inv(A(:,:,n));
    end
end
