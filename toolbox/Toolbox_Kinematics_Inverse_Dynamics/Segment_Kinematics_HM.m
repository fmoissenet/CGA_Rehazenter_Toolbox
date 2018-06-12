% FUNCTION
% Segment_Kinematics_HM.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of segment kinematics by homogenous matrix method
%
% SYNOPSIS
% Segment = Segment_Kinematics_HM(Segment,f,fc,n)
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
% Computation of homogenous matrices of velocity and acceleration (W, H)
% as a function of homogenous matrix of transformation from ICS to SCS (T)
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
% Mprod_array3.m
% Derive_array3.m
% Tinv_array3.m
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
% May 2014
% Extraction of angular acceleration as 0.5*(G-Gt)
% G is the 3*3 submatrix of H
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

function [Segment] = Segment_Kinematics_HM(Segment,f,fc,n)

% Time sampling
dt = 1/f;

for i = 2:5  % From i = 2 foot (or hand) to i = 5 pelvis (or thorax)
    
    % Homogenous matrix of velocity (W)
   Segment(i).W = Mprod_array3(Derive_array3(Segment(i).T,dt), ...
        Tinv_array3(Segment(i).T));
    % Filtering
    Segment(i).W = Mfilt_array3(Segment(i).W,f,fc); % Overwrite
    
    % Extraction of angular velocity (Omega)
    Segment(i).Omega(1,1,:) = (-Segment(i).W(2,3,:) + ...
        Segment(i).W(3,2,:))/2;
    Segment(i).Omega(2,1,:) = (Segment(i).W(1,3,:) - ...
        Segment(i).W(3,1,:))/2;
    Segment(i).Omega(3,1,:) = (-Segment(i).W(1,2,:) + ...
        Segment(i).W(2,1,:))/2;
    
    % Position of COM in ICS in dimension (3*1*n)
    rC = Mprod_array3(Segment(i).T, ...
        repmat([Segment(i).rCs;1],[1 1 n]));
    
    % Extraction of linear velocity of COM (V)
    Segment(i).V = Mprod_array3(Segment(i).W,rC);
    Segment(i).V = Segment(i).V(1:3,1,:); % Discard last line
        
    % Homogenous matrix of acceleration (H)
    Segment(i).H = Mprod_array3(Derive_array3(Derive_array3 ...
        (Segment(i).T,dt),dt),Tinv_array3(Segment(i).T));
    % Filtering
    Segment(i).H = Mfilt_array3(Segment(i).H,f,fc); % Overwrite
    
    % Extraction of angular acceleration (Alpha)
    Alphaskew = 0.5*(Segment(i).H(1:3,1:3,:) - permute(Segment(i).H(1:3,1:3,:),[2,1,3]));
    % with transpose = permute ( , [2,1,3])
    Segment(i).Alpha = [(-Alphaskew(2,3,:) + Alphaskew(3,2,:))/2; ...
        (Alphaskew(1,3,:) - Alphaskew(3,1,:))/2; ...
        (-Alphaskew(1,2,:) + Alphaskew(2,1,:))/2];
    
    % Extraction of linear acceleration of COM (A)
     Segment(i).A = Mprod_array3(Segment(i).H,rC);
     Segment(i).A = Segment(i).A(1:3,1,:); % Discard last line
    
end
