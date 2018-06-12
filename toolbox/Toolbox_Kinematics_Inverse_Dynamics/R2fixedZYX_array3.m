% FUNCTION
% R2fixedZYX_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of Euler angles from rotation matrix (with ZYX fixed sequence
% for segment kinematics) 
%
% SYNOPSIS
% Segment_Euler_Angles = R2fixedZYX_array3(R)
%
% INPUT
% R (i.e., rotation matrix) 
%
% OUTPUT
% Segment_Euler_Angles (i.e., phi, theta, psi, in line)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the Euler angles (phi, theta , psi) from the rotation
% matrix (R) using a sequence of fixed axes ZYX
%
% REFERENCE
% L Cheze, R Dumas, JJ Comtet, C Rumelhart, M Fayet. A joint coordinate 
% system proposal for the study of the trapeziometacarpal joint kinematics
% Computer Methods in Biomechanics and Biomedical Engineering 2009;12(3): 
% 277-82
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

function Segment_Euler_Angles = R2fixedZYX_array3(R)

% Phi (about Z ICS axis)
Segment_Euler_Angles(1,1,:) = atan2(-R(1,2,:),R(1,1,:));
% Theta (about Y ICS axis)
Segment_Euler_Angles(1,2,:) = asin(R(1,3,:));
% Psi (about X ICS axis)
Segment_Euler_Angles(1,3,:) = atan2(-R(2,3,:),R(3,3,:)); 
