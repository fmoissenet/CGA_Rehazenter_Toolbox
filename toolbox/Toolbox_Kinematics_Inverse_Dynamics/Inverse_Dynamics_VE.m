% FUNCTION
% Inverse_Dynamics_VE.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint moments and forces by vector and Euler angles method
%
% SYNOPSIS
% [Joint,Segment] = Inverse_Dynamics_VE(Joint,Segment,f,fc,n)
%
% INPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
% f (i.e., sampling frequency)
% fc (i.e., cut off frequency)
% n (i.e., number of frames)
%
% OUTPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Data formatting and call of functions Kinematics_VE.m and Dynamics_VE.m
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Extend_Segment_Fields.m
% Segment_Kinematics_VE.m
% Dynamics_VE.m
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
% August 2014
% Cut off frequency as input of functions
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function [Joint,Segment] = Inverse_Dynamics_VE(Joint,Segment,f,fc,n)

% Extend segment fields
Segment = Extend_Segment_Fields(Segment);

% Kinematics
Segment = Segment_Kinematics_VE(Segment,f,fc,n);

% Dynamics
[Joint,Segment] = Dynamics_VE(Joint,Segment,n);
