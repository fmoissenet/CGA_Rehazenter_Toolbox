% FUNCTION
% Segment_Kinematics_VE.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of segment kinematics by Euler angles method
%
% SYNOPSIS
% Segment = Segment_Kinematics_VE(Segment,f,fc,n)
%
% INPUT
% Segment (cf. data structure in user guide)
% f (i.e., sampling frequency)
% fc (i.e., cut off frequency)
% n (i.e., number of frames)
%
% OUTPUT
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of segment angular velocity and acceleration (alpha, omega),
% linear velocity and acceleration of centre of mass (v, a) expressed
% in ICS, as a function of:
% * position of proximal endpoint (rP) expressed in ICS
% *	Euler angles (phi, theta, psi) or rotation matrix (R)
%   of transformation from ICS to SCS 
% *	position of centre of mass (rCs) expressed in SCS
%
% REFERENCES
% MP Kadaba, HK Ramakrishnan, ME Wootten, J Gainey, G Gorton, GV Cochran.
% Repeatability of kinematic, kinetic, and electromyographic data in normal  
% adult gait. Journal of Orthopaedic Research 1989;7(6):849-60
% RB Davis, S Ounpuu, D Tyburski, JR Gage. A gait analysis data collection
% and reduction technique. Human Movement Science 1991;10:575-87
% CL Vaughan, BL Davis, JC O'Connor. Dynamics of human gait (2d edition).
% Human Kinetics, Champaign, Illinois, 1999
% G Wu, PR Cavanagh. ISB recommendations for standardization in the 
% reporting of kinematic data. Journal of Biomechanics 1995;28(10):1257-61
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% R2fixedZYX_array3.m
% Derive_array3.m
% Mprod_array3.m
% Vfilt_array3.m
% 
% MATLAB VERSION
% Matlab R2007b
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

function [Segment]= Segment_Kinematics_VE(Segment,f,fc,n)

% Time sampling
dt = 1/f;

for i = 2:5 % From i = 2 foot (or hand) to i = 5 pelvis (or thorax)
    
    % First derivates of Euler angles
    Segment(i).Euler(2,:,:) = Derive_array3(Segment(i).Euler(1,:,:),dt);
    % Angular velocity expressed in ICS
    % [dspi/dt;dtheta/dt;dphi/dt]
    Segment(i).Omega = [Segment(i).Euler(2,3,:); Segment(i).Euler(2,2,:); ...
        Segment(i).Euler(2,1,:)];
    % Filtering
    Segment(i).Omega = Vfilt_array3(Segment(i).Omega,f,fc); % Overwrite
    
    % Second derivates of Euler angles
    Segment(i).Euler(3,:,:) = Derive_array3(Segment(i).Euler(2,:,:),dt);
    % Angular acceleration expressed in ICS
    Segment(i).Alpha = [Segment(i).Euler(3,3,:); Segment(i).Euler(3,2,:); ...
        Segment(i).Euler(3,1,:)];
    % Filtering
    Segment(i).Alpha = Vfilt_array3(Segment(i).Alpha,f,fc); % Overwrite
    
    % Position of COM in SCS in dimension (3*1*n)
    rCs = repmat(Segment(i).rCs,[1 1 n]);
    
    % Linear velocity of COM expressed in ICS
    Segment(i).V = Derive_array3(Segment(i).rP,dt) + ...
        cross(Segment(i).Omega,Mprod_array3(Segment(i).R,rCs));
    % Filtering
    Segment(i).V = Vfilt_array3(Segment(i).V,f,fc); % Overwrite
    
    % Linear acceleration of COM expressed in ICS
    Segment(i).A = Derive_array3(Derive_array3(Segment(i).rP,dt),dt) + ...
        cross(Segment(i).Alpha,Mprod_array3(Segment(i).R,rCs)) + ...
        cross(Segment(i).Omega,cross(Segment(i).Omega, ...
        Mprod_array3(Segment(i).R,rCs)));
    % Filtering
    Segment(i).A = Vfilt_array3(Segment(i).A,f,fc); % Overwrite
    
end
