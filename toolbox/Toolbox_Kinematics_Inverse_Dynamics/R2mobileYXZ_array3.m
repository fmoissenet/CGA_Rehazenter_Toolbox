% FUNCTION
% R2mobileYXZ_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of Euler angles from rotation matrix (with YXZ mobile sequence
% for joint kinematics) 
%
% SYNOPSIS
% Joint_Euler_Angles = R2mobileYXZ_array3(R)
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
% rotation matrix (R) using a sequence of mobile axes YXZ
%
% REFERENCES
% G Wu, FC van der Helm, HE Veeger, M Makhsous, P Van Roy, C Anglin, 
% J Nagels, AR Karduna, K McQuade, X Wang, FW Werner, B Buchholz. ISB
% recommendation on definitions of joint coordinate systems of various
% joints for the reporting of human joint motion - Part II: shoulder, 
% elbow, wrist and hand. Journal of Biomechanics 2005;38(5):981-92.
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

function Joint_Euler_Angles = R2mobileYXZ_array3(R)

% Tetha1: Internal-External Rotation or Protraction-Retraction for scapula (about Y proximal SCS axis)
Joint_Euler_Angles(1,1,:) = atan2(R(1,3,:),R(3,3,:));
% Tetha2: Medial-Lateral or Downward-Upward Rotation for scapula (about X floating axis)
Joint_Euler_Angles(1,2,:) = asin(-R(2,3,:));
% Tetha3: Flexion-Extension or Posterior-Anterior Tilt for scapula(about Z distal SCS axis)
Joint_Euler_Angles(1,3,:) = atan2(R(2,1,:),R(2,2,:));

