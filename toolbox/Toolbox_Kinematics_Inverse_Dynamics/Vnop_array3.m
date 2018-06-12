% FUNCTION
% Vnop_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Non-orthogonal projection on three basis vectors
%
% SYNOPSIS
% Vnop = Vnop_array3(V,e1,e2,e3)
%
% INPUT
% V (i.e., vector)
% e1, e2, e3 (i.e., basis vectors)
%
% OUTPUT
% Vnop (i.e., vector components)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the vector projections on three non-orthogonal basis
% vectors
%
% REFERENCES
% L Cheze. Comparison of different calculations of three-dimensional joint
% kinematics from video-based system data. Journal of Biomechanics 2000;
% 33(12):1695-9.
% G Desroches, L Cheze, R Dumas. Expression of joint moment in the joint 
% coordinate system. Journal of Biomechanical Engineering 2010;132(11):
% 114503
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

function Vnop = Vnop_array3(V,e1,e2,e3)

% Projection in a non-orthonormal basis (e1,e2,e3)
% using mixted products
% V = ((e2,e3,V)/(e1,e2,e3))*e1
%      + ((e3,e1,V)/(e1,e2,e3))*e2
%      + ((e1,e2,V)/(e1,e2,e3))*e3
Vnop(1,1,:) = dot(cross(e2,e3),V)./ ...
    dot(cross(e1,e2),e3);
Vnop(2,1,:) = dot(cross(e3,e1),V)./ ...
    dot(cross(e1,e2),e3);
Vnop(3,1,:) = dot(cross(e1,e2),V)./ ...
    dot(cross(e1,e2),e3);
