% FUNCTION
% Mprod_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of matrix product 
%
% SYNOPSIS
% C = Mprod_array3(A,B)
%
% INPUT
% A, B (i.e., matrices) 
%
% OUTPUT
% C (i.e., matrix)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the product of two matrices of compatible sizes
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

function C = Mprod_array3(A,B)

% Dimensions
l1 = size(A,1); % Number of lines
c1 = size(A,2); % Number of columns
l2 = size(B,1); % Number of lines
c2 = size(B,2); % Number of columns
n = size(A,3); % Number of frames

% Initilization
C = [];

if l1 == 1 == c1 == 1 % A is scalar
        
    % Element by element product (1*1*n)
        for i = 1:l2
            for j = 1:c2
                C(i,j,:) = A(1,1,:).*B(i,j,:);
            end
        end
        
elseif l2 ~= c1
    
    % Display
    disp('A and B must be of compatible size')
    
else % A and B are matrices

    % transpose = permute ( , [2,1,3])
    At = permute(A,[2,1,3]);
    
    % Element by element product (1*1*n)
    for j =1:c2
        for i = 1:l1
            if l2 == 1 == c1 == 1 % Scalar product
                C(i,j,:) = At(:,i,:).*B(:,j,:);
            else % Dot product (of vectors)
                C(i,j,:) = dot(At(:,i,:),B(:,j,:));
            end
        end
    end
    
end
