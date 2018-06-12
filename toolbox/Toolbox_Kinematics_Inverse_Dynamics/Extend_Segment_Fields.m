% FUNCTION
% Extend_Segment_Fields.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of all possible segment parameters from generalized 
% coordinates
%
% SYNOPSIS
% Segment = Extend_Segment_Fields(Segment)
%
% INPUT
% Segment (cf. data structure in user guide)
%
% OUTPUT
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of homogenous matrix (T), position of proximal endpoints
% (rP), quaternion (q), rotation matrix (R) and Euler angles (phi, theta,
% psi) from generalized coordinates (Q) (cf. data structure in user guide)
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Mprod_array3.m
% Vskew_array3.m
% Q2Tuv_array3.m
% R2q_array3.m
% R2fixedZYX_array3.m
% q2R_array3.m
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
function Segment = Extend_Segment_Fields(Segment)

for i = 1:5 % From i = 1 forceplate (or wheel) to i = 5 pelvis (or thorax)

    % 1rst priority for Q parameter setting
    if isfield(Segment(i),'Q') & ~isempty(Segment(i).Q)

        % Homogenous matrix (T)
        if i == 1 % Forceplate (or wheel)
            % Q2Tuv_array3 not applicable
            Segment(1).T(1:3,1,:) = Segment(1).Q(1:3,1,:); % u1
            Segment(1).T(1:3,2,:) = Mprod_array3(Vskew_array3 ...
                (Segment(1).Q(10:12,1,:)),Segment(1).Q(1:3,1,:)); % w1xu1
            Segment(1).T(1:3,3,:) = Segment(1).Q(10:12,1,:); % w1, ...
            Segment(1).T(1:3,4,:) = Segment(1).Q(4:6,1,:); % rP
            Segment(1).T(4,4,:) = 1;
        else
            Segment(i).T = Q2Tuv_array3(Segment(i).Q);
        end
        % Rotation matrix (R)
        Segment(i).R = Segment(i).T(1:3,1:3,:);
        % Position of proximal endpoint (rP)
        Segment(i).rP = Segment(i).T(1:3,4,:);
        % Quaternion (q)
        Segment(i).q = R2q_array3(Segment(i).R);
        % Euler angles (phi,theta,psi)
        Segment(i).Euler = R2fixedZYX_array3(Segment(i).R);

    else
        % 2d priority for T parameter setting
        if isfield(Segment(i),'T')

            % Parameter Q not available
            % Homogenous matrix (T) done
            % Rotation matrix (R)
            Segment(i).R = Segment(i).T(1:3,1:3,:);
            % Position of proximal endpoint (rP)
            Segment(i).rP = Segment(i).T(1:3,4,:);
            % Quaternion (q)
            Segment(i).q = R2q_array3(Segment(i).R);
            % Euler angles (phi,theta,psi)
            Segment(i).Euler = R2fixedZYX_array3(Segment(i).R);

        else
            % 3rd priority for q and rP parameter setting
            if isfield(Segment(i),'q') & isfield(Segment(i),'rP')

                % Parameter Q not available
                % Quaternion (q) done
                % Position of proximal endpoint (rP) done
                % Rotation matrix (R)
                Segment(i).R = q2R_array3(Segment(i).q);
                % Homogenous matrix (T)
                Segment(i).T = [Segment(i).R, Segment(i).rP];
                Segment(i).T(4,4,:) = 1;
                % Euler angles (phi,theta,psi)
                Segment(i).Euler = R2fixedZYX_array3(Segment(i).R);

            else
                % 4th priority for R and rP parameter setting
                if isfield(Segment(i),'R') & isfield(Segment(i),'rP')

                    % Parameter Q not available
                    % Rotation matrix (R) done
                    % Position of proximal endpoint (rP) done
                    % Homogenous matrix (T)
                    Segment(i).T = [Segment(i).R, Segment(i).rP];
                    Segment(i).T(4,4,:) = 1;
                    % Quaternion (q)
                    Segment(i).q = R2q_array3(Segment(i).R);
                    % Euler angles (phi,theta,psi)
                    Segment(i).Euler = R2fixedZYX_array3(Segment(i).R);
                    
                else
                    % Parameters shall not be deduced from Euler angles
                    display ('No appropriate fields in Segment')
                    return
                    
                end
            end
        end
    end
end
