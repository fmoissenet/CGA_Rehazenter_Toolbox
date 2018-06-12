% FUNCTION
% qlog_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of quaternion logarithm
%
% SYNOPSIS
% halfktheta = qlog_array3(q)
%
% INPUT
% q (i.e., quaternions)
%
% OUTPUT
% halfktheta (i.e., spatial attitude vector divided by 2)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the haft of spatial attitude vector from a quaternion
%
% REFERENCE
% J Lee, SY Shin. General construction of time-domain filters for 
% orientation data. IEEE Transactions on Visualization and Computer
% Graphics 2002;8(2):119-128
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Vnorm_array3.m
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
% February 2011
% Problem with NaN fixed (case theta = 0)
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function halfktheta = qlog_array3(q)

% q = [cos(theta/2); k*sin(theta/2)]
theta = 2*atan2(sqrt(sum(q(2:4,:,:).^2)),q(1,:,:));
k = Vnorm_array3(q(2:4,:,:)); % May return NaN if theta = 0
% k*(theta/2)
halfktheta = k.*repmat(theta/2,[3,1,1]);
if ~isempty(find(theta == 0))
     % Replace possible NaN by vector 0
    halfktheta(:,:,find(theta == 0)) = zeros(3,1,size(find(theta == 0),1));
end
