% FUNCTION
% R2mobileYXY_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of Euler angles from rotation matrix (with YXY mobile sequence
% for joint kinematics) 
%
% SYNOPSIS
% Joint_Euler_Angles = R2mobileYXY_array3(R)
%
% INPUT
% R (i.e., rotation matrix) 
%
% OUTPUT
% Joint_Euler_Angles (i.e., tetha1, tetha2, tetha3, in line)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the Euler angles (tetha1, tetha2, tetha3) from the
% rotation matrix (R) using a sequence of mobile axes YXY
%
% REFERENCES
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% None
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% November 2012
%__________________________________________________________________________

function Joint_Euler_Angles = R2mobileYXY_array3(R)

% Tetha1: Orientation of plane of elevation (about Y proximal SCS axis)
Joint_Euler_Angles(1,1,:) = atan2(R(1,2,:),R(3,2,:));
% Tetha2: Elevation (about X floating axis)
Joint_Euler_Angles(1,2,:) = acos(R(2,2,:));
% Tetha3: Internal-External Rotation (about Y distal SCS axis)
Joint_Euler_Angles(1,3,:) = atan2(R(2,1,:),-R(3,2,:));

