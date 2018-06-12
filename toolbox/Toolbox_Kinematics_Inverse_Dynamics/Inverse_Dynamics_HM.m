% FUNCTION
% Inverse_Dynamics_HM.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint moments and forces by homogenous matrix method
%
% SYNOPSIS
% [Joint,Segment] = Inverse_Dynamics_HM(Joint,Segment,f,fc,n)
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
% Data formatting and call of functions Kinematics_HM.m and Dynamics_HM.m
%
% REFERENCES
% N Doriot, L Cheze. A 3D Kinematic and dynamic study of the lower limb
% during the stance phase of gait using an homogeneous matrix approach. 
% IEEE Transactions on Biomedical Engineering 2004;51(1):21-7
% G Legnani, F Casolo, P Righettini, B Zappa, A homogeneous matrix approach
% to 3D kinematics and dynamics - I. Theory. Mechanisms and Machine Theory
% 1996;31(5):573–87
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Extend_Segment_Fields.m
% Mprod_array3.m
% Vskew_array3.m
% Segment_Kinematics_HM.m
% Dynamics_HM.m
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

function [Joint,Segment] = Inverse_Dynamics_HM(Joint,Segment,f,fc,n)

% Extend segment fields
Segment = Extend_Segment_Fields(Segment);

for i = 2:4  % From i = 2 foot (or hand) to i = 4 thigh (or arm)

    % Homogenous matrix of pseudo-inertia expressed in SCS (Js)
    Segment(i).Js = ...
        [(Segment(i).Is(1,1) + ...
        Segment(i).Is(2,2) + ...
        Segment(i).Is(3,3))/2 * ...
        eye(3) - Segment(i).Is,Segment(i).m * Segment(i).rCs;
        Segment(i).m * (Segment(i).rCs)',Segment(i).m];

end

% Transformation form origin of ICS to COP in ICS
T(1:3,4,:) = Segment(1).T(1:3,4,:);
T(1,1,:) = 1; % in ICS
T(2,2,:) = 1; % in ICS
T(3,3,:) = 1; % in ICS
T(4,4,:) = 1;
% Homogenous matrix of GR force and moment at origin of ICS (phi)
% with transpose = permute( ,[2,1,3])
Joint(1).phi = Mprod_array3(T,Mprod_array3(...
    [Vskew_array3(Joint(1).M),Joint(1).F;...
    - permute(Joint(1).F,[2,1,3]),zeros(1,1,n)],...
    permute(T,[2,1,3])));

% Kinematics
Segment = Segment_Kinematics_HM(Segment,f,fc,n);

% Dynamics
[Joint,Segment] = Dynamics_HM(Joint,Segment,n);
