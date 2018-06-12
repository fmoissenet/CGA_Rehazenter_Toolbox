% FUNCTION
% R2mobileZYX_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of Euler angles from rotation matrix (with ZYX mobile sequence
% for joint kinematics) 
%
% SYNOPSIS
% Joint_Euler_Angles = R2mobileZYX_array3(R)
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
% rotation matrix (R) using a sequence of mobile axes ZYX
%
% REFERENCE
% L Cheze, R Dumas, JJ Comtet, C Rumelhart, M Fayet. A joint coordinate 
% system proposal for the study of the trapeziometacarpal joint kinematics
% Computer Methods in Biomechanics and Biomedical Engineering 2009;12(3): 
% 277-82
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
% March 2010
%__________________________________________________________________________

function Joint_Euler_Angles = R2mobileZYX_array3(R)

% Tetha1: Flexion-Extension (about Z proximal SCS axis)
Joint_Euler_Angles(1,1,:) = atan2(R(2,1,:),R(1,1,:));
 % Tetha2: Internal-External Rotation (about Y floating axis)
Joint_Euler_Angles(1,2,:) = asin(-R(3,1,:));
% Tetha3: Abduction-Adduction (about X distal SCS axis) 
Joint_Euler_Angles(1,3,:) = atan2(R(3,2,:),R(3,3,:)); 
