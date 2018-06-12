% FUNCTION
% qinv_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of quaternion inverse
%
% SYNOPSIS
% p = qinv_array3(q)
%
% INPUT
% q (i.e., quaternions)
%
% OUTPUT
% p (i.e., quaternions)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide ), of the inverse of a quaternion
%
% REFERENCE
% R Dumas, R Aissaoui, J A de Guise. A 3D generic inverse dynanmic method 
% using wrench notation and quaternion algebra. Computer Methods in 
% Biomechanics and Biomedical Engineering 2004;7(3):159-166
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

function p = qinv_array3(q)

% Sum of square of terms in dimension (1*n)
N = sum(q.^2); % Norm of quaternion should be 1

% Matrix for the inversion in dimension (4*4*n)
In(1,1,:) = 1/N;
In(2,2,:) = -1/N;
In(3,3,:) = -1/N;
In(4,4,:) = -1/N;
p = Mprod_array3(In,q);
