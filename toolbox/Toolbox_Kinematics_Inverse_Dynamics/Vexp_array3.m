% FUNCTION
% Vexp_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of vector exponential
%
% SYNOPSIS
% q = Vexp_array3(halfktheta)
%
% INPUT
% halfktheta (i.e., spatial attitude vector divided by 2)
%
% OUTPUT
% q (i.e., quaternions)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the quaternion form the haft of spatial attitude 
% vector
%
% REFERENCE
% J Lee, SY Shin. General construction of time-domain filters for 
% orientation data. IEEE Transactions on Visualization and Computer
% Graphics 2002;8(2):119-128.
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Vnorm_array3.m
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

function q = Vexp_array3(halfktheta)

% q = [cos(||V||); (V/||V||)*sin(||V||)]
% with V = k*(theta/2)
q = [cos(sqrt(sum(halfktheta.^2))); ...
    Vnorm_array3(halfktheta).*...
    repmat(sin(sqrt(sum(halfktheta.^2))),[3,1,1])];
