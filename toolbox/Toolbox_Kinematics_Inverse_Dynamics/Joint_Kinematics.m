% FUNCTION
% Main_Joint_Kinematics.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint angles and displacements
%
% SYNOPSIS
% Joint = Joint_Kinematics(Segment)
%
% INPUT
% Segment (cf. data structure in user guide)
%
% OUTPUT
% Joint (cf. data structure in user guide)
%
% DESCRIPTION
% Definition of JCS axes (e1, e2, e3) from generalized coordinates (Q), and 
% computation of the joint angles and displacement about these axes
%
% REFERENCE
% R Dumas, T Robert, V Pomero, L Cheze. Joint and segment coordinate 
% systems revisited. Computer Methods in Biomechanics and Biomedical  
% Engineering. 2012;15(Suppl 1):183-5
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% Tinv_array3.m
% Q2Tuv_array3.m
% Q2Tuw_array3.m
% Q2Twu_array3.m
% R2mobileZXY_array3.m
% R2mobileZYX_array3.m
% Vnop_array3.m
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
% October 2010
% Sequence ZYX for both ankle and wrist joints
%
% Modified by Raphaël Dumas
% July 2012
% New versions of Q2T
% Use of Q2Tuw_array3.m for foot axes
%
% Modified by Raphaël Dumas
% September 2012
% Normalisation of the 2d vector of the non-orthogonal projection on JCS axes
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function Joint = Joint_Kinematics(Segment)

% Number of frames
n = size(Segment(2).Q,3);

% Joint angles and displacements
for i = 2:4 % From i = 2 ankle (or wrist) to i = 4 hip (or shoulder)
    
    if i == 2
        % ZYX sequence of mobile axis (JCS system for ankle and wrist)
        % Ankle adduction-abduction (or wrist interal-external rotation) on floating axis
        % Transformation from the proximal to the distal SCS
        % Proximal SCS: origin at endpoint D and Z=w and  Y=(w×u)/||w×u||
        % Distal SCS: origin at endpoint P and X=u and Y =(w×u)/||w×u||  
        Joint(i).T = Mprod_array3(Tinv_array3(Q2Twu_array3(Segment(i+1).Q)),...
            Q2Tuw_array3(Segment(i).Q));
        
        % Euler angles
        Joint(i).Euler = R2mobileZYX_array3(Joint(i).T(1:3,1:3,:));
        % Joint displacement about the Euler angle axes
        Joint(i).dj = Vnop_array3(...
            Joint(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            Vnorm_array3(cross(repmat([0;0;1],[1 1 n]),Joint(i).T(1:3,1,:))),... Y = ZxX
            Joint(i).T(1:3,1,:)); % Xi in SCS of segment i
        
    else
        % ZXY sequence of mobile axis
        % Transformation from the proximal to the distal SCS
        % Proximal SCS: origin at endpoint D and Z=w and  Y=(w×u)/||w×u||
        % Distal SCS: origin at endpoint P and X=u and Z=(u×v)/||u×v||  
        Joint(i).T = Mprod_array3(Tinv_array3(Q2Twu_array3(Segment(i+1).Q)),...
            Q2Tuv_array3(Segment(i).Q));
        if i == 4
            % Special case for i = 4 thigh (or arm)
            % Origin of proximal segment at mean position of Pi
            % in proximal SCS (rather than endpoint Di+1)
            Joint(4).T(1:3,4,:) = Joint(4).T(1:3,4,:) - ...
                repmat(mean(Joint(4).T(1:3,4,:),3),[1 1 n]);
        end
        
        % Euler angles
        Joint(i).Euler = R2mobileZXY_array3(Joint(i).T(1:3,1:3,:));
        % Joint displacement about the Euler angle axes
        Joint(i).dj = Vnop_array3(...
            Joint(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            Vnorm_array3(cross(Joint(i).T(1:3,2,:),repmat([0;0;1],[1 1 n]))),... X = YxZ
            Joint(i).T(1:3,2,:)); % Yi in SCS of segment i
        
    end
    
end
