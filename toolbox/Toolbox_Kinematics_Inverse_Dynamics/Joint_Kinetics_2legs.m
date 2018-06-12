% FUNCTION
% Joint_Kinetics_2legs.m
%__________________________________________________________________________
%
% PURPOSE
%
% SYNOPSIS
%
% INPUT
%
% OUTPUT
%
% DESCRIPTION
%
% REFERENCE
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
%
% MATLAB VERSION
% Matlab R2016a
%__________________________________________________________________________
%
% CHANGELOG
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function [Segment,Joint] = Joint_Kinetics_2legs(Segment,Joint,f)

n = size(Joint(1).F,3);

% =========================================================================
% RIGHT SIDE
% =========================================================================

% Extend Segment fields
% -------------------------------------------------------------------------
for i = 1:5 % From i = 1 forceplate to i = 5 pelvis
    % 1rst priority for Q parameter setting
    if isfield(Segment(i),'Q') && ~isempty(Segment(i).Q)
        % Homogenous matrix (T)
        if i == 1 % Forceplate (or wheel)
            % Q2Tuv_array3 not applicable
            Segment(i).T(1:3,1,:) = Segment(i).Q(1:3,1,:); % u1
            Segment(i).T(1:3,2,:) = Mprod_array3(Vskew_array3 ...
                (Segment(i).Q(10:12,1,:)),Segment(i).Q(1:3,1,:)); % w1xu1
            Segment(i).T(1:3,3,:) = Segment(i).Q(10:12,1,:); % w1, ...
            Segment(i).T(1:3,4,:) = Segment(i).Q(4:6,1,:); % rP
            Segment(i).T(4,4,:) = 1;
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
            if isfield(Segment(i),'q') && isfield(Segment(i),'rP')
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
                if isfield(Segment(i),'R') && isfield(Segment(i),'rP')
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

% Homogenous matrix of pseudo-inertia expressed in SCS (Js)
% -------------------------------------------------------------------------
for i = 2:4  % From i = 2 foot to i = 4 thigh
    Segment(i).Js = ...
        [(Segment(i).Is(1,1) + ...
        Segment(i).Is(2,2) + ...
        Segment(i).Is(3,3))/2 * ...
        eye(3) - Segment(i).Is,Segment(i).m * Segment(i).rCs;
        Segment(i).m * (Segment(i).rCs)',Segment(i).m];
end

% Transformation form origin of ICS to COP in ICS
% -------------------------------------------------------------------------
T(1:3,4,:) = Segment(1).T(1:3,4,:);
T(1,1,:) = 1; % in ICS
T(2,2,:) = 1; % in ICS
T(3,3,:) = 1; % in ICS
T(4,4,:) = 1;

% Homogenous matrix of GR force and moment at origin of ICS (phi)
% with transpose = permute( ,[2,1,3])
% -------------------------------------------------------------------------
Joint(1).phi = Mprod_array3(T,Mprod_array3(...
    [Vskew_array3(Joint(1).M),Joint(1).F;...
    - permute(Joint(1).F,[2,1,3]),zeros(1,1,n)],...
    permute(T,[2,1,3])));

% Kinematics
% -------------------------------------------------------------------------
% Time sampling
dt = 1/f;
% Cut frequency for filtering
fc = 5;
for i = 2:5  % From i = 2 foot to i = 5 pelvis    
    % Homogenous matrix of velocity (W)
    Segment(i).W = Mprod_array3(Derive_array3(Segment(i).T,dt), ...
        Tinv_array3(Segment(i).T));
    % Filtering
    Segment(i).W = Mfilt_array3(Segment(i).W,f,fc); % Overwrite    
    % Extraction of angular velocity (Omega)
    Segment(i).Omega(1,1,:) = (-Segment(i).W(2,3,:) + ...
        Segment(i).W(3,2,:))/2;
    Segment(i).Omega(2,1,:) = (Segment(i).W(1,3,:) - ...
        Segment(i).W(3,1,:))/2;
    Segment(i).Omega(3,1,:) = (-Segment(i).W(1,2,:) + ...
        Segment(i).W(2,1,:))/2;    
    % Position of COM in ICS in dimension (3*1*n)
    rC = Mprod_array3(Segment(i).T, ...
        repmat([Segment(i).rCs;1],[1 1 n]));    
    % Extraction of linear velocity of COM (V)
    Segment(i).V = Mprod_array3(Segment(i).W,rC);
    Segment(i).V = Segment(i).V(1:3,1,:); % Discard last line        
    % Homogenous matrix of acceleration (H)
    Segment(i).H = Mprod_array3(Derive_array3(Derive_array3 ...
        (Segment(i).T,dt),dt),Tinv_array3(Segment(i).T));
    % Filtering
    Segment(i).H = Mfilt_array3(Segment(i).H,f,fc); % Overwrite    
    % Extraction of angular acceleration (Alpha)
    Alpha = Segment(i).H(1:3,1:3,:) - Mprod_array3(Vskew_array3( ...
        Segment(i).Omega), Vskew_array3(Segment(i).Omega));
    Segment(i).Alpha = [(-Alpha(2,3,:) + Alpha(3,2,:))/2; ...
        (Alpha(1,3,:) - Alpha(3,1,:))/2; ...
        (-Alpha(1,2,:) + Alpha(2,1,:))/2];    
    % Extraction of linear acceleration of COM (A)
     Segment(i).A =  Mprod_array3(Segment(i).H,rC);
     Segment(i).A = Segment(i).A(1:3,1,:); % Discard last line    
end

% Dynamics
% -------------------------------------------------------------------------
% Acceleration of gravity expressed in ICS in dimension (3*1*n)
g = repmat([0;-9.81;0],[1,1,n]); 
% Homogenous matrix of acceleration of gravity (Hg)
Hg = zeros(4,4,n); % Initialisation
Hg(1:3,4,:) = g;
for i = 2:4 % From i = 2 foot to i = 4 thigh    
    % Transformation from SCS to ICS (J = [T] [Js] [T]t)
    % with transpose = permute( ,[2,1,3])
    J = Mprod_array3(Segment(i).T, ...
        Mprod_array3(repmat(Segment(i).Js,[1 1 n]), ...
        permute(Segment(i).T,[2,1,3])));
    % Homogenous matrix of force and moment at origin of ICS (phi)
    % with transpose = permute ( , [2,1,3])
    Joint(i).phi = Joint(i-1).phi + Mprod_array3((Segment(i).H - Hg),J) ...
        - Mprod_array3(J,permute((Segment(i).H - Hg),[2,1,3]));
    % Transformation form origin of ICS to proximal endpoint P
    T(1:3,4,:) = Segment(i).T(1:3,4,:); 
    T(1,1,:) = 1; % in ICS
    T(2,2,:) = 1; % in ICS
    T(3,3,:) = 1; % in ICS
    T(4,4,:) = 1;
    % Homogenous matrix of joint force and moment at proximal endpoint P
    % with transpose = permute( ,[2,1,3])
    phi = Mprod_array3(Tinv_array3(T),Mprod_array3(...
        Joint(i).phi,permute(Tinv_array3(T),[2,1,3])));
    % Extraction of F and M
    Joint(i).F = (phi(1:3,4,:) - permute(phi(4,1:3,:),[2,1,3]))/2;
    Joint(i).M(1,1,:) = (-phi(2,3,:) + phi(3,2,:))/2;
    Joint(i).M(2,1,:) = (phi(1,3,:) - phi(3,1,:))/2;
    Joint(i).M(3,1,:) = (-phi(1,2,:) + phi(2,1,:))/2;    
end
for i = 2:4 % i = 2 ankle to i = 4 hip
    % Proximal segment axis
    Tw = Q2Tw_array3(Segment(i+1).Q); % Segment axis
    if i == 2 % ZYX sequence of mobile axis
        % Joint coordinate system for ankle (or wrist):
        % Internal/extenal rotation on floating axis
        % Joint force about the Euler angle axes
        Joint(i).Fj = Vnop_array3(...
            Joint(i).F,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,1,:)); % Xi of segment i
        % Joint moment about the Euler angle axes
        Joint(i).Mj = Vnop_array3(...
            Joint(i).M,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,1,:)); % Xi of segment i
    else % Same joint coordinate system for all joints
        % ZXY sequence of mobile axis
        % Joint force about the Euler angle axes
        Joint(i).Fj = Vnop_array3(...
            Joint(i).F,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,2,:)); % Yi of segment i
        % Joint moment about the Euler angle axes
        Joint(i).Mj = Vnop_array3(...
            Joint(i).M,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,2,:)); % Yi of segment i
    end
end

% =========================================================================
% LEFT SIDE
% =========================================================================

% Extend Segment fields
% -------------------------------------------------------------------------
for i = 101:105 % From i = 101 forceplate to i = 105 pelvis
    % 1rst priority for Q parameter setting
    if isfield(Segment(i),'Q') && ~isempty(Segment(i).Q)
        % Homogenous matrix (T)
        if i == 101 % Forceplate (or wheel)
            % Q2Tuv_array3 not applicable
            Segment(i).T(1:3,1,:) = Segment(i).Q(1:3,1,:); % u1
            Segment(i).T(1:3,2,:) = Mprod_array3(Vskew_array3 ...
                (Segment(i).Q(10:12,1,:)),Segment(i).Q(1:3,1,:)); % w1xu1
            Segment(i).T(1:3,3,:) = Segment(i).Q(10:12,1,:); % w1, ...
            Segment(i).T(1:3,4,:) = Segment(i).Q(4:6,1,:); % rP
            Segment(i).T(4,4,:) = 1;
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
            if isfield(Segment(i),'q') && isfield(Segment(i),'rP')
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
                if isfield(Segment(i),'R') && isfield(Segment(i),'rP')
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

% Homogenous matrix of pseudo-inertia expressed in SCS (Js)
% -------------------------------------------------------------------------
for i = 102:104  % From i = 102 foot to i = 104 thigh
    Segment(i).Js = ...
        [(Segment(i).Is(1,1) + ...
        Segment(i).Is(2,2) + ...
        Segment(i).Is(3,3))/2 * ...
        eye(3) - Segment(i).Is,Segment(i).m * Segment(i).rCs;
        Segment(i).m * (Segment(i).rCs)',Segment(i).m];
end

% Transformation form origin of ICS to COP in ICS
% -------------------------------------------------------------------------
T(1:3,4,:) = Segment(101).T(1:3,4,:);
T(1,1,:) = 1; % in ICS
T(2,2,:) = 1; % in ICS
T(3,3,:) = 1; % in ICS
T(4,4,:) = 1;

% Homogenous matrix of GR force and moment at origin of ICS (phi)
% with transpose = permute( ,[2,1,3])
% -------------------------------------------------------------------------
Joint(101).phi = Mprod_array3(T,Mprod_array3(...
    [Vskew_array3(Joint(101).M),Joint(101).F;...
    - permute(Joint(101).F,[2,1,3]),zeros(1,1,n)],...
    permute(T,[2,1,3])));

% Kinematics
% -------------------------------------------------------------------------
% Time sampling
dt = 1/f;
% Cut frequency for filtering
fc = 5;
for i = 102:105  % From i = 102 foot to i = 105 pelvis    
    % Homogenous matrix of velocity (W)
    Segment(i).W = Mprod_array3(Derive_array3(Segment(i).T,dt), ...
        Tinv_array3(Segment(i).T));
    % Filtering
    Segment(i).W = Mfilt_array3(Segment(i).W,f,fc); % Overwrite    
    % Extraction of angular velocity (Omega)
    Segment(i).Omega(1,1,:) = (-Segment(i).W(2,3,:) + ...
        Segment(i).W(3,2,:))/2;
    Segment(i).Omega(2,1,:) = (Segment(i).W(1,3,:) - ...
        Segment(i).W(3,1,:))/2;
    Segment(i).Omega(3,1,:) = (-Segment(i).W(1,2,:) + ...
        Segment(i).W(2,1,:))/2;    
    % Position of COM in ICS in dimension (3*1*n)
    rC = Mprod_array3(Segment(i).T, ...
        repmat([Segment(i).rCs;1],[1 1 n]));    
    % Extraction of linear velocity of COM (V)
    Segment(i).V = Mprod_array3(Segment(i).W,rC);
    Segment(i).V = Segment(i).V(1:3,1,:); % Discard last line        
    % Homogenous matrix of acceleration (H)
    Segment(i).H = Mprod_array3(Derive_array3(Derive_array3 ...
        (Segment(i).T,dt),dt),Tinv_array3(Segment(i).T));
    % Filtering
    Segment(i).H = Mfilt_array3(Segment(i).H,f,fc); % Overwrite    
    % Extraction of angular acceleration (Alpha)
    Alpha = Segment(i).H(1:3,1:3,:) - Mprod_array3(Vskew_array3( ...
        Segment(i).Omega), Vskew_array3(Segment(i).Omega));
    Segment(i).Alpha = [(-Alpha(2,3,:) + Alpha(3,2,:))/2; ...
        (Alpha(1,3,:) - Alpha(3,1,:))/2; ...
        (-Alpha(1,2,:) + Alpha(2,1,:))/2];    
    % Extraction of linear acceleration of COM (A)
     Segment(i).A =  Mprod_array3(Segment(i).H,rC);
     Segment(i).A = Segment(i).A(1:3,1,:); % Discard last line    
end

% Dynamics
% -------------------------------------------------------------------------
% Acceleration of gravity expressed in ICS in dimension (3*1*n)
g = repmat([0;-9.81;0],[1,1,n]); 
% Homogenous matrix of acceleration of gravity (Hg)
Hg = zeros(4,4,n); % Initialisation
Hg(1:3,4,:) = g;
for i = 102:104 % From i = 2 foot to i = 4 thigh    
    % Transformation from SCS to ICS (J = [T] [Js] [T]t)
    % with transpose = permute( ,[2,1,3])
    J = Mprod_array3(Segment(i).T, ...
        Mprod_array3(repmat(Segment(i).Js,[1 1 n]), ...
        permute(Segment(i).T,[2,1,3])));
    % Homogenous matrix of force and moment at origin of ICS (phi)
    % with transpose = permute ( , [2,1,3])
    Joint(i).phi = Joint(i-1).phi + Mprod_array3((Segment(i).H - Hg),J) ...
        - Mprod_array3(J,permute((Segment(i).H - Hg),[2,1,3]));
    % Transformation form origin of ICS to proximal endpoint P
    T(1:3,4,:) = Segment(i).T(1:3,4,:); 
    T(1,1,:) = 1; % in ICS
    T(2,2,:) = 1; % in ICS
    T(3,3,:) = 1; % in ICS
    T(4,4,:) = 1;
    % Homogenous matrix of joint force and moment at proximal endpoint P
    % with transpose = permute( ,[2,1,3])
    phi = Mprod_array3(Tinv_array3(T),Mprod_array3(...
        Joint(i).phi,permute(Tinv_array3(T),[2,1,3])));
    % Extraction of F and M
    Joint(i).F = (phi(1:3,4,:) - permute(phi(4,1:3,:),[2,1,3]))/2;
    Joint(i).M(1,1,:) = (-phi(2,3,:) + phi(3,2,:))/2;
    Joint(i).M(2,1,:) = (phi(1,3,:) - phi(3,1,:))/2;
    Joint(i).M(3,1,:) = (-phi(1,2,:) + phi(2,1,:))/2;    
end
for i = 102:104 % i = 102 ankle to i = 104 hip
    % Proximal segment axis
    Tw = Q2Tw_array3(Segment(i+1).Q); % Segment axis
    if i == 102 % ZYX sequence of mobile axis
        % Joint coordinate system for ankle (or wrist):
        % Internal/extenal rotation on floating axis
        % Joint force about the Euler angle axes
        Joint(i).Fj = Vnop_array3(...
            Joint(i).F,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,1,:)); % Xi of segment i
        % Joint moment about the Euler angle axes
        Joint(i).Mj = Vnop_array3(...
            Joint(i).M,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,1,:)); % Xi of segment i
    else % Same joint coordinate system for all joints
        % ZXY sequence of mobile axis
        % Joint force about the Euler angle axes
        Joint(i).Fj = Vnop_array3(...
            Joint(i).F,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,2,:)); % Yi of segment i
        % Joint moment about the Euler angle axes
        Joint(i).Mj = Vnop_array3(...
            Joint(i).M,...
            Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
            cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
            Segment(i).R(1:3,2,:)); % Yi of segment i
    end
end