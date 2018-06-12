% FUNCTION
% Vnorm_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of a unitary vector
%
% SYNOPSIS
% Vn = Vnorm_array3(V)
%
% INPUT
% V (i.e., vector)
%
% OUTPUT
% Vn (i.e., vector)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the unitary vector from a vector
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
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

function Vn = Vnorm_array3(V)

% Norm in dimension 1*n
N = sqrt(sum(V.^2));

% Number of line
L = size(V,1);
% Matrix for normalization in dimension (L*L*n)
for i = 1:L
    In(i,i,:) = 1/N;
end
Vn = Mprod_array3(In,V);
