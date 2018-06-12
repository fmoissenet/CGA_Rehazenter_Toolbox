% FUNCTION
% R2mobileXZY_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of Euler angles from rotation matrix (with XZY mobile sequence
% for joint kinematics) 
%
% SYNOPSIS
% Joint_Euler_Angles = R2mobileXZY_array3(R)
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
% rotation matrix (R) using a sequence of mobile axes XZY
%
% REFERENCES
% M Senk, L Cheze. Rotation sequence as an important factor in shoulder
% kinematics. Clinical Biomechanics 2006;21(S1):S3-8
% A Bonnefoy-Mazure, J Slawinski, A Riquet, JM Lévèque, C Miller,  L Cheze.
% Rotation sequence is an important factor in shoulder kinematics. 
% Application to the elite players' flat serves. Journal of Biomechanics
% 2010;43(10):2022-5
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
% March 2011
%__________________________________________________________________________

function Joint_Euler_Angles = R2mobileXZY_array3(R)

% Tetha1: Abduction-Adduction (about X proximal SCS axis)
Joint_Euler_Angles(1,1,:) = atan2(R(3,2,:),R(2,2,:));
% Tetha2: Flexion-Extension (about Z floating axis)
Joint_Euler_Angles(1,2,:) = asin(-R(1,2,:));
% Tetha3: Internal-External Rotation (about Y distal SCS axis)
Joint_Euler_Angles(1,3,:) = atan2(R(1,3,:),R(1,1,:));
