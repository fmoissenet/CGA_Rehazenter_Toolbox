% FUNCTION
% Inverse_Dynamics_WQ.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint moments and forces by wrench and quaternion method
%
% SYNOPSIS
% [Joint,Segment] = Inverse_Dynamics_WQ(Joint,Segment,f,fc,n)
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
% Data formatting and call of functions Kinematics_WQ.m and Dynamics_WQ.m
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Extend_Segment_Fields.m
% Segment_Kinematics_WQ.m
% Dynamics_WQ.m
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

function [Joint,Segment] = Inverse_Dynamics_WQ(Joint,Segment,f,fc,n)


% Extend segment fields
Segment = Extend_Segment_Fields(Segment);

% Kinematics
Segment = Segment_Kinematics_WQ(Segment,f,fc,n);

% Dynamics
[Joint,Segment] = Dynamics_WQ(Joint,Segment,n);
