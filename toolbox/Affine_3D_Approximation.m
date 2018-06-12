% FUNCTION
% Affine_3D_Approximation
%__________________________________________________________________________
%
% PURPOSE
% Non-rigid registration and scaling of an initial mesh based on a set of
% control points
%
% SYNOPSIS
%[Meshj,Rotation,Translation,Homothety,Stretch,SSE] = ...
%    Affine_3D_Approximation(Meshi,Xi,Xj)
%
% INPUT
% Meshi (i.e., matrix l*3 of the l initial 3D mesh nodes)
% Xi (i.e., matrix n*3 of the n initial 3D control points)
% Xj (i.e., matrix n*3 of the n final 3D control points)
%
% OUTPUT
% Meshj (i.e., matrix l*3 of the l final 3D mesh nodes)
% Rotation (i.e., matrix 3*3 of the rigid part of the linear polynomial)
% Translation (i.e., vector 3*1 of the rigid part of the linear polynomial)
% Homothety (i.e., matrix 3*3 of the deformative part of the linear polynomial)
% Stretch (i.e., matrix 3*3 of the deformative part of the linear polynomial)
% SSE (i.e., sum of squared errors)
%
% DESCRIPTION
% Determination of the linear transformation (least squares) from an 
% initial position i to a final position j, extraction of
% geometrical information and application to the initial mesh nodes
%
% REFERENCES
% R Dumas, L Cheze. Soft tissue artifact compensation by linear 3D 
% interpolation and approximation methods. Journal of Biomechanics
% 2009;42(13):2214–2217.
% HJ Sommer 3rd, NR Miller, GJ Pijanowski. Three-dimensional osteometric
% scaling and normative modelling of skeletal segments. Journal of 
% Biomechanics 1982;15(3):171-80.
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D SCALING TOOLBOX) 
% None
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% May 2011
%__________________________________________________________________________

function [Meshj,Rotation,Translation,Homothety,Stretch,SSE] = ...
    Affine_3D_Approximation(Meshi,Xi,Xj)

% Number of control points
n = size(Xi,1);

%__________________________________________________________________________
%
% Least square polynomials
%__________________________________________________________________________

% Xj = [1,Xi]*[A]
% Least square:
A = inv([ones(n,1),Xi]' * [ones(n,1),Xi])*[ones(n,1),Xi]' * Xj;

% Final control points minus transformed initial control points
Xja =  Xj - [ones(n,1),Xi]*A;

% % Sum of squared errors (residual)
% SSEa = diag(Xja'*Xja)'; % 3 values on x,y,z

%__________________________________________________________________________
%
% 3D approximation
%__________________________________________________________________________

% Mesh nodes and control points 
% (may eventually consider control points twice
% if control point are part of the mesh nodes)
Datai = [Xi;Meshi]; % Data point

% Number of data points
ln = size(Datai,1);

% Dataf
Dataj = [ones(ln,1),Datai]*A;

% Extract final mesh nodes from data points
Meshj = Dataj(n+1:end,:);

%__________________________________________________________________________
%
% Sum of squared errors (on control points)
%__________________________________________________________________________

SSE = sum((Xj - Dataj(1:n,:)).^2,1);

%__________________________________________________________________________
%
% Interpetration of the affine
%__________________________________________________________________________
Rotation = [];
Translation = [];
Homothety = [];
Stretch = [];
% % Translation of the global origin considered as fixed
% % with regards to the initial control points
% Translation = A(1,1:3)'; % Parameters a0
% 
% % Singular Value Decomposition of matrix of parameters a1 a2 a3
% [U,S,V] = svd(A(2:4,1:3)');
% 
% % Polar decomposition
% % Rotation
% Rotation = U*V';
% % Homothety
% Homothety = diag(diag(V*S*V'));
% % Stretch
% Stretch = inv(Homothety)*(V*S*V');

