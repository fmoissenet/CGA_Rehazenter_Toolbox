% FUNCTION
% Vskew_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of skew matrix of vector
%
% SYNOPSIS
% M = Vskew_array3(V)
%
% INPUT
% V (i.e., vector)
%
% OUTPUT
% M (i.e., matrix)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the skew matrix from a vector
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

function M =  Vskew_array3(V)

% Number of frame
n = size(V,3); 

% Initialization
M = zeros(3,3,n); % 3*3*n zeros matrix

% Non-zero terms
M(1,2,:) = -V(3,1,:);
M(1,3,:) = V(2,1,:);
M(2,1,:) = V(3,1,:);
M(2,3,:) = -V(1,1,:);
M(3,1,:) = -V(2,1,:);
M(3,2,:) = V(1,1,:);
