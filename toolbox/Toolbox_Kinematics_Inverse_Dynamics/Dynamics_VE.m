% FUNCTION
% Dynamics_VE.m
%__________________________________________________________________________
%
% PURPOSE
% Recursive computations of joint moments and forces by vector method
%
% SYNOPSIS
% [Joint,Segment] = Dynamics_VE(Joint,Segment,f,n)
%
% INPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
% f (i.e., sampling frequency)
% n (i.e., number of frames)
%
% OUTPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of joint force and moment (F, M) at proximal endpoint of
% segment (rP) expressed in ICS, as a function of:
% *	segment mass (m)
% *	position of centre of mass (rCs) expressed in SCS
% *	inertia tensor at centre of mass (Is) expressed in SCS
% *	segment angular velocity and acceleration (alpha, omega) and
%   linear acceleration of centre of mass (a) expressed in ICS
% *	position of proximal endpoint (rP) expressed in ICS
% *	position of centre of pressure (rP1) expressed in ICS
% *	ground reaction force and moment (F1, M1) expressed in ICS
%
% REFERENCES
% MP Kadaba, HK Ramakrishnan, ME Wootten, J Gainey, G Gorton, GV Cochran.
% Repeatability of kinematic, kinetic, and electromyographic data in normal  
% adult gait. Journal of Orthopaedic Research 1989;7(6):849-60
% RB Davis, S Ounpuu, D Tyburski, JR Gage. A gait analysis data collection
% and reduction technique. Human Movement Science 1991;10:575-87
% CL Vaughan, BL Davis, JC O'Connor. Dynamics of human gait (2d edition).
% Human Kinetics, Champaign, Illinois, 1999
% R Dumas, E Nicol, L Cheze. Influence of the 3D inverse dynamic method on
% the joint forces and moments during gait. Journal of Biomechanical 
% Engineering 2007;129(5):786-90
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% Minv_array3.m
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

function [Joint,Segment] = Dynamics_VE(Joint,Segment,n)

% Acceleration of gravity expressed in ICS in dimension (3*1*n)
g = repmat([0;-9.81;0],[1,1,n]);

% Identity matrix in dimension (3*3*n)
E33 = repmat(eye(3),[1,1,n]);

for i = 2:4 % From i = 2 foot (or hand) to i = 4 thigh (or arm)

    % Newton equation
    Joint(i).F = Mprod_array3(Segment(i).m*E33,...
        (Segment(i).A - g)) + Joint(i-1).F; % = - [F(i-1/i)] = - [-F(i/i-1)]

    % Proximal force expressed in SCS
    FPs = Mprod_array3(Minv_array3(Segment(i).R),Joint(i).F);
    % Distal force expressed in SCS
    FDs = Mprod_array3(Minv_array3(Segment(i).R),Joint(i-1).F);
    % Distal moment expressed in SCS
    MDs = Mprod_array3(Minv_array3(Segment(i).R),Joint(i-1).M);  
    % Lever arm from COM to distal endpoint expressed in SCS
    rDs = Mprod_array3(Minv_array3(Segment(i).R),Segment(i-1).rP);
    % Lever arm from COM to proximal endpoint expressed in SCS
    rPs = Mprod_array3(Minv_array3(Segment(i).R),Segment(i).rP);
    % Angular velocity expressed in SCS
    Omegas = Mprod_array3(Minv_array3(Segment(i).R),Segment(i).Omega);
    % Angular acceleration expressed in SCS
    Alphas = Mprod_array3(Minv_array3(Segment(i).R),Segment(i).Alpha);
    % Is in dimension (3*3*n)
    Is = repmat(Segment(i).Is,[1 1 n]);
    % Position of COM in SCS in dimension (3*1*n)
    rCs = repmat(Segment(i).rCs,[1 1 n]);
    
    % Euler equation
    MPs = Mprod_array3(Is,Alphas) + ...
        cross(Omegas,Mprod_array3(Is,Omegas)) + ...
        MDs + cross(rCs,FPs) + cross((rDs - rPs - rCs),FDs);

    % Transformation from SCS to ICS
    Joint(i).M = Mprod_array3(Segment(i).R,MPs);

end
