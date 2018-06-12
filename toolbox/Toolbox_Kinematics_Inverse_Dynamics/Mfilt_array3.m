% FUNCTION
% Mfilt_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Filtering of matrix 
%
% SYNOPSIS
% Mf = Mfilt_array3(M,f,fc)
%
% INPUT
% M (i.e., matrix) 
% f (i.e., sampling frequency)
% fc (i.e., cut off frequency)
%
% OUTPUT
% Mf (i.e., matrix)
%
% DESCRIPTION
% Filtering, along with the 3rd dimension (i.e., all frames, cf. data 
% structure in user guide), of the matrix elements by a 4th order
% Butterworth
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Vfilt_array3.m
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
% September 2012
% Replicate last line
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function Mf = Mfilt_array3(M,f,fc)

% Case of rotation matrix
V1 = Vfilt_array3(M(:,1,:),f,fc);
V2 = Vfilt_array3(M(:,2,:),f,fc);
V3 = Vfilt_array3(M(:,3,:),f,fc);
Mf = [V1,V2,V3];

% Case of homogenous matrix
if size(M,1) == 4
    Mf(1:3,4,:) = Vfilt_array3(M(1:3,4,:),f,fc);
    Mf(4,1:4,:) = M(4,1:4,:); % Replicate last line
end
