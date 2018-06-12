% FUNCTION
% qprod_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of quaternion product
%
% SYNOPSIS
% r = qprod_array3(p,q)
%
% INPUT
% p,q (i.e., quaternions)
%
% OUTPUT
% r (i.e., quaternions)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the product of two quaternions
%
% REFERENCE
% R Dumas, R Aissaoui, J A de Guise. A 3D generic inverse dynanmic method 
% using wrench notation and quaternion algebra. Computer Methods in 
% Biomechanics and Biomedical Engineering 2004;7(3):159-166
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Vskew_array3.m
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

function r = qprod_array3(p,q)

% Matrix 4*4*n for quaternion product of q by p 
M(2:4,2:4,:) = Vskew_array3(p(2:4,1,:));
M(:,1,:) = p(:,1,:);
% with transpose = permute( ,[2,1,3])
M(1,2:4,:) = - permute (p(2:4,1,:),[2,1,3]); 
M(2,2,:) = p(1,1,:);
M(3,3,:) = p(1,1,:);
M(4,4,:) = p(1,1,:);

r = Mprod_array3(M,q);
