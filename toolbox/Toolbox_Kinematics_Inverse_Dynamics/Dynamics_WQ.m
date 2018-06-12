% FUNCTION
% Dynamics_WQ.m
%__________________________________________________________________________
%
% PURPOSE
% Recursive computation of joint moments and forces by wrench method
%
% SYNOPSIS
% [Joint,Segment] = Dynamics_WQ(Joint,Segment,n)
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
% *	segment mass (m)
% *	position of centre of mass (rCs) expressed in SCS
% *	inertia tensor at centre of mass (Is) expressed in SCS
% *	segment angular velocity and acceleration (alpha, omega) and linear
%   acceleration of centre of mass (a) expressed in ICS
% *	position of proximal endpoint (rP) expressed in ICS
% *	position of centre of pressure (rP1) expressed in ICS
% *	ground reaction force and moment (F1, M1) expressed in ICS

% REFERENCES
% R Dumas, R Aissaoui, J A de Guise. A 3D generic inverse dynanmic method 
% using wrench notation and quaternion algebra. Computer Methods in 
% Biomechanics and Biomedical Engineering 2004;7(3):159-166
% R Dumas, E Nicol, L Cheze. Influence of the 3D inverse dynamic method on
% the joint forces and moments during gait. Journal of Biomechanical 
% Engineering 2007;129(5):786-90
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% q2R_array3.m
% Minv_array3.m
% Vskew_array3.m
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

function [Joint,Segment] = Dynamics_WQ(Joint,Segment,n)

% Acceleration of gravity expressed in ICS in dimension (3*1*n)
g = repmat([0;-9.81;0],[1,1,n]);

% Identity matrix in dimension (3*3*n)
E33 = repmat(eye(3),[1,1,n]);
% Zero matrix in dimension (3*1*n)
O31 = zeros(3,1,n);
%  Zero matrix in dimension (3*3*n)
O33 = zeros(3,3,n);

for i = 2:4 % From i = 2 foot (or hand) to i = 4 thigh (or arm)
    
    % Is in dimension (3*3*n)
    Is = repmat(Segment(i).Is,[1 1 n]);
    % Inertia tensor at COM expressed in ICS
    RIRt = Mprod_array3(q2R_array3(Segment(i).q), Mprod_array3(Is, ...
        Minv_array3(q2R_array3(Segment(i).q))));
    
    % Omega x (I . Omega)
    OmegaIOmega = cross(Segment(i).Omega,...
        Mprod_array3(RIRt,Segment(i).Omega));

    % Skew matrices of lever arms 
    % Lever arm from proximal to distal endpoint
    L = Vskew_array3(Segment(i-1).rP - Segment(i).rP);
    % Position of COP in ICS in dimension (3*1*n)
    rCs = repmat(Segment(i).rCs,[1 1 n]);
    % Lever arm from proximal to COM
    C = Vskew_array3(Mprod_array3(q2R_array3(Segment(i).q),rCs));
        
    % Force and moment in dimension (6*1*n)
    % [mass, 0; mass*C(skew), Inertia] * [Alpha-g; A]
    % + [0; 0; 0; Omega x (I . Omega)]
    % + [Identity, 0; L(skew), Identity] * [Fi-1; Mi-1]
    FM = Mprod_array3([Segment(i).m*E33,zeros(3,3,n);Segment(i).m*C,RIRt], ...
        [Segment(i).A - g;Segment(i).Alpha])... 
        + [O31;OmegaIOmega] ... 
        + Mprod_array3([E33,O33;L,E33],[Joint(i-1).F;Joint(i-1).M] );
    % Extraction of joint force and moment
    Joint(i).F = FM(1:3,1,:);
    Joint(i).M = FM(4:6,1,:);
    
end 
