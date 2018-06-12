% FUNCTION
% Derive_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of time derivative of matrix or vector 
%
% SYNOPSIS
% dVdt = Derive_array3(V,dt)
% dMdt = Derive_array3(M,dt)
%
% INPUT
% V (i.e., vector) or M (i.e., matrix) 
% dt (i.e., sampling time that is to say dt = 1/f)
%
% OUTPUT
% dVdt or dMdt (i.e., vector or matrix)
%
% DESCRIPTION
% Gradient approximation in the 3rd dimension of matrix or vector 
% (i.e., all frames, cf. data structure in user guide)
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% None
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

function dVdt = Derive_array3(V,dt)

% 3rd direction gradient
% with time sampling (dt)
[gr1,gr2,dVdt] = gradient(V,dt);
