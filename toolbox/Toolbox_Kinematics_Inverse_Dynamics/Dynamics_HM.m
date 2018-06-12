% FUNCTION
% Dynamics_HM.m
%__________________________________________________________________________
%
% PURPOSE
% Recursive computations of joint moments and forces by homogenous matrix
% method
%
% SYNOPSIS
% [Joint,Segment] = Dynamics_HM(Joint,Segment,n)
%
% INPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
% n (i.e., number of frames)
%
% OUTPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of joint force and moment (F, M) at proximal endpoint of 
% segment (rP) expressed in ICS, as a function of:
% *	homogenous matrix of pseudo-inertia (J)
% *	homogenous matrix of acceleration (H)
% *	homogenous matrix of ground reaction force and moment (phi1)
%
% REFERENCES
% N Doriot, L Cheze. A 3D Kinematic and dynamic study of the lower limb
% during the stance phase of gait using an homogeneous matrix approach. 
% IEEE Transactions on Biomedical Engineering 2004;51(1):21-7
% G Legnani, F Casolo, P Righettini, B Zappa, A homogeneous matrix approach
% to 3D kinematics and dynamics - I. Theory. Mechanisms and Machine Theory
% 1996;31(5):573–87
% R Dumas, E Nicol, L Cheze. Influence of the 3D inverse dynamic method on
% the joint forces and moments during gait. Journal of Biomechanical 
% Engineering 2007;129(5):786-90
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% Tinv_array3.m
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

function [Joint,Segment] = Dynamics_HM(Joint,Segment,n)

% Acceleration of gravity expressed in ICS in dimension (3*1*n)
g = repmat([0;-9.81;0],[1,1,n]); 

% Homogenous matrix of acceleration of gravity (Hg)
Hg = zeros(4,4,n); % Initialisation
Hg(1:3,4,:) = g;

for i = 2:4 % From i = 2 foot (or hand) to i = 4 thigh (or arm)
    
    % Transformation from SCS to ICS (J = [T] [Js] [T]t)
    % with transpose = permute( ,[2,1,3])
    J = Mprod_array3(Segment(i).T, ...
        Mprod_array3(repmat(Segment(i).Js,[1 1 n]), ...
        permute(Segment(i).T,[2,1,3])));

    % Homogenous matrix of force and moment at origin of ICS (phi)
    % with transpose = permute ( , [2,1,3])
    Joint(i).phi = Joint(i-1).phi + Mprod_array3((Segment(i).H - Hg),J) ...
        - Mprod_array3(J,permute((Segment(i).H - Hg),[2,1,3]));

    % Transformation form origin of ICS to proximal endpoint P
    T(1:3,4,:) = Segment(i).T(1:3,4,:); 
    T(1,1,:) = 1; % in ICS
    T(2,2,:) = 1; % in ICS
    T(3,3,:) = 1; % in ICS
    T(4,4,:) = 1;
    % Homogenous matrix of joint force and moment at proximal endpoint P
    % with transpose = permute( ,[2,1,3])
    phi = Mprod_array3(Tinv_array3(T),Mprod_array3(...
        Joint(i).phi,permute(Tinv_array3(T),[2,1,3])));

    % Extraction of F and M
    Joint(i).F = (phi(1:3,4,:) - permute(phi(4,1:3,:),[2,1,3]))/2;
    Joint(i).M(1,1,:) = (-phi(2,3,:) + phi(3,2,:))/2;
    Joint(i).M(2,1,:) = (phi(1,3,:) - phi(3,1,:))/2;
    Joint(i).M(3,1,:) = (-phi(1,2,:) + phi(2,1,:))/2;
    
end
