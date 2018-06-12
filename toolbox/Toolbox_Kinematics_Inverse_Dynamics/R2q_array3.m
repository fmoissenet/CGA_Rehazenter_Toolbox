% FUNCTION
% R2q_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of quaternion from rotation matrix 
%
% SYNOPSIS
% q = R2q_array3(R)
%
% INPUT
% R (i.e., rotation matrix)
%
% OUTPUT
% q (i.e., quaternion)
%
% DESCRIPTION
% Computation, for all frames (i.e., in 3rd dimension, cf. data structure
% in user guide), of the quaternion (q) from the rotation matrix (R)
%
% REFERENCES
% SW Shepperd. Quaternion from Rotation Matrix. Journal of Guidance and
% Control 1978; 1(3): 223-224.
% J Lee, SY Shin. General construction of time-domain filters for 
% orientation data. IEEE Transactions on Visualization and Computer
% Graphics 2002; 8(2): 119-128.
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Vnorm_array3.m
% qlog_array3.m
% qprod_array3.m
% qinv_array3.m
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

function q = R2q_array3(R)

% Terms of rotation matrix in dimension (1*n)
R11 = permute(R(1,1,:),[2,3,1]);
R12 = permute(R(1,2,:),[2,3,1]);
R13 = permute(R(1,3,:),[2,3,1]);
R21 = permute(R(2,1,:),[2,3,1]);
R22 = permute(R(2,2,:),[2,3,1]);
R23 = permute(R(2,3,:),[2,3,1]);
R31 = permute(R(3,1,:),[2,3,1]);
R32 = permute(R(3,2,:),[2,3,1]);
R33 = permute(R(3,3,:),[2,3,1]);

% Matrix trace in dimension (1*n)
Tr = R11 + R22 + R33 ;
% Trace and diagonal terms  in dimension (1*n)
M = [Tr; R11; R22; R33];
% Maximal value out of 4
[~,imax] = max(M); % Imax = 1,2,3 or 4
% Terms associated with maximal value in dimension (1*n)
pmax = abs(sqrt(1 + 2*M(imax) - Tr)); % p is 2*q

% 4 Cases
% Frame where maximal value is Tr
ind1 = find(imax == 1);
p(1,ind1) = pmax(1,ind1);
p(2,ind1) = (R32(1,ind1) - R23(1,ind1))./pmax(1,ind1); 
p(3,ind1) = (R13(1,ind1) - R31(1,ind1))./pmax(1,ind1);
p(4,ind1) = (R21(1,ind1) - R12(1,ind1))./pmax(1,ind1);
% Frame where maximal value is R11
ind2 = find(imax == 2);
p(1,ind2) = (R32(1,ind2) - R23(1,ind2))./pmax(1,ind2);
p(2,ind2) = pmax(1,ind2);
p(3,ind2) = (R21(1,ind2) + R12(1,ind2))./pmax(1,ind2);
p(4,ind2) = (R13(1,ind2) + R31(1,ind2))./pmax(1,ind2);
% Frame where maximal value is R22
ind3 = find (imax == 3);
p(1,ind3) = (R13(1,ind3) - R31(1,ind3))./pmax(1,ind3);
p(2,ind3) = (R21(1,ind3) + R12(1,ind3))./pmax(1,ind3);
p(3,ind3) = pmax(1,ind3);
p(4,ind3) = (R32(1,ind3) + R23(1,ind3))./pmax(1,ind3);
% Frame where maximal value is R33
ind4 = find(imax == 4);
p(1,ind4) = (R21(1,ind4) - R12(1,ind4))./pmax(1,ind4);
p(2,ind4) = (R13(1,ind4) + R31(1,ind4))./pmax(1,ind4);
p(3,ind4) = (R32(1,ind4) + R23(1,ind4))./pmax(1,ind4);
p(4,ind4) = pmax(1,ind4);

% Quaternion in dimension (4*1*n)
q = Vnorm_array3(0.5*permute(p,[1,3,2]));

% Continuity test (Lee's method)
% Quaternions q and -q can represent the same rotation R
for i = 2:size(q,3)
    % ||log(qi-1)-1*qi)|| > pi/2
    if norm(qlog_array3(qprod_array3(...
        qinv_array3(q(:,:,i-1)), q(:,:,i)))) > pi/2
        % Quaternion of opposite sign
        q(:,:,i) = - q(:,:,i);
    end
end
