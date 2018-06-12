% FUNCTION
% Multibody_Optimisation_UUS.m
%__________________________________________________________________________
%
% PURPOSE
% Multibody optimisation : minimisation of the sum of the square distances 
% between measured and model-determined marker positions subject to 
% kinematic and rigid body constraints (Gauss-Newton algorithm)
%
% SYNOPSIS
% Segment = Multibody_Optimisation_UUS(Segment)
%
% INPUT
% Segment (cf. data structure in user guide)
% Model (type of kinematic constraints)
%
% OUTPUT
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of Q by minimisation under constraints (the number of DoFs are
% 2 at the wrist, 2 at the elbow and 3 at the shoulder):
% 'U': Universal (2 degrees of freedom) at wrist
% 'U': Universal (2 degrees of freedom) at elbow
% 'S': Spherical (3 degrees of freedom) at shoulder
%
% REFERENCES
% S Duprey, L Cheze, R Dumas. Influence of joint constraints on lower
% limb kinematics estimation from skin markers using global optimization.
% Journal of Biomechanics 2010;43(14):2858-2862.
%
%__________________________________________________________________________
%
% CALLED FUNCTIONS
% (from 3D kinematics and inverse dynamics toolbox) 
% Vnop_array3.m
% Mprod_array3.m
% Minv_array3.m
%
% MATLAB VERSION
% Matlab R2016a
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% August 2013
%
% Modified by Raphaël Dumas
% June 2014
% Version with one choice of joint models: UUS
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function Segment = Multibody_Optimisation_UUS(Segment)

% Number of frames
n = size(Segment(2).rM,3);
% Initialisation
Joint(1).Kk = [];


%% ------------------------------------------------------------------------
% Model parameters
% -------------------------------------------------------------------------

% Initialisation
Segment(1).L = NaN; % No value for segment 1 (Forceplate)
Segment(1).alpha = NaN; % No value for segment 1 (Forceplate)
Segment(1).beta = NaN; % No value for segment 1 (Forceplate)
Segment(1).gamma = NaN; % No value for segment 1 (Forceplate)

% Mean segment geometry and markers coordinates
for i = 2:5 % From i = 2 (Foot) to i = 5 (Pelvis)
    
    % Segment length
    Segment(i).L = mean(sqrt(sum((Segment(i).Q(4:6,1,:) - ...
        Segment(i).Q(7:9,1,:)).^2)),3);
    
    % Alpha angle between (rP - rD) and w
    Segment(i).alpha = mean(acosd(dot(Segment(i).Q(4:6,1,:) - ...
        Segment(i).Q(7:9,1,:), Segment(i).Q(10:12,1,:))./...
        sqrt(sum((Segment(i).Q(4:6,1,:) - ...
        Segment(i).Q(7:9,1,:)).^2))),3);
    
    % Beta angle between u and w
    Segment(i).beta = mean(acosd(dot(Segment(i).Q(10:12,1,:), ...
        Segment(i).Q(1:3,1,:))),3);
    
    % Gamma angle between u and (rP - rD)
    Segment(i).gamma = mean(acosd(dot(Segment(i).Q(1:3,1,:), ...
        Segment(i).Q(4:6,1,:) - Segment(i).Q(7:9,1,:))./...
        sqrt(sum((Segment(i).Q(4:6,1,:) - ...
        Segment(i).Q(7:9,1,:)).^2))),3);
    
    % Matrix B from SCS to NSCS (matrix Buv)
    Segment(i).B = [1, ...
        Segment(i).L*cosd(Segment(i).gamma), ...
        cosd(Segment(i).beta); ...
        0, ...
        Segment(i).L*sind(Segment(i).gamma), ...
        (cosd(Segment(i).alpha) - cosd(Segment(i).beta)*cosd(Segment(i).gamma))/sind(Segment(i).gamma); ...
        0, ...
        0, ...
        sqrt(1 - cosd(Segment(i).beta)^2 - ((cosd(Segment(i).alpha) - cosd(Segment(i).beta)*cosd(Segment(i).gamma))/sind(Segment(i).gamma))^2)];
    
    % Mean coordinates of markers in (u, rP-rD, w)
    for j = 1:size(Segment(i).rM,2)
        % Projection in a non orthonormal coordinate system
        Segment(i).nM(:,j) = mean(Vnop_array3(...
            Segment(i).rM(:,j,:) - Segment(i).Q(4:6,1,:),...
            Segment(i).Q(1:3,1,:),...
            Segment(i).Q(4:6,1,:) - Segment(i).Q(7:9,1,:),...
            Segment(i).Q(10:12,1,:)),3);
    end
    
end


%% ------------------------------------------------------------------------
% Joint parameters and initial guess
% -------------------------------------------------------------------------

% Ankle universal joint angle from neutral position
thetaA = Segment(3).beta; % u2 = u3 at neutral position
% Initial guess for Lagrange multipliers
lambdakA = zeros(4,1,n);

% Knee universal joint angles from neutral position
thetaK1 = Segment(4).alpha; % v3 (rP3 - rD3) = v4 (rP4 - rD4) at neutral position
% Initial guess for Lagrange multipliers
lambdakK = zeros(4,1,n);

% Hip virtual marker mean coordinates (rV1 = rP4)
% Expressed in  in (u5, rP5-rD5, w5)
Segment(5).nV(:,1) = mean(Vnop_array3(...
    Segment(4).Q(4:6,1,:) - Segment(5).Q(4:6,1,:),...
    Segment(5).Q(1:3,1,:),...
    Segment(5).Q(4:6,1,:) - Segment(5).Q(7:9,1,:),...
    Segment(5).Q(10:12,1,:)),3);
% Interpolation matrices
NV15 = [Segment(5).nV(1,1)*eye(3),...
    (1 + Segment(5).nV(2,1))*eye(3), ...
    - Segment(5).nV(2,1)*eye(3), ...
    Segment(5).nV(3,1)*eye(3)];
% Initial guess for Lagrange multipliers
lambdakH = zeros(3,1,n);


%% ------------------------------------------------------------------------
% Run optimisation
% -------------------------------------------------------------------------

% Initial guess for Lagrange multipliers
lambdar = zeros(24,1,n); % 4 segments x 6 constraints per segment

% Initial value of the objective function
F = 1;
% Iteration number
step = 0;

% -------------------------------------------------------------------------
% Newton-Raphson
while max(permute(sqrt(sum(F.^2)),[3,2,1])) > 10e-12 && step < 20
    
    % Iteration number
    step = step + 1   % Display
    
    % Initialisation
    phik = []; % Vector of kinematic constraints
    Kk = [];  % Jacobian of kinematic constraints
    phir = []; % Vector of rigid body constraints
    Kr = []; % Jacobian of rigid body constraints
    dKlambdardQ = []; % Partial derivative of Jacobian * Lagrange multipliers
    phim = []; % Vector of driving constraints
    Km = []; % Jacobian of driving constraints
    
    % Ankle
    % Vector of kinematic constraints
    % rD3 - rP2 = 0
    % w3.u2 - cos(thetaA) = 0
    phikA = [Segment(3).Q(7:9,1,:) - Segment(2).Q(4:6,1,:);...
        dot(Segment(3).Q(10:12,1,:),Segment(2).Q(1:3,1,:)) - ...
        repmat(cosd(thetaA),[1,1,n])];
    % Jacobian of kinematic constraints
    KkA = zeros(4,4*12,n); % Initialisation
    KkA(1:3,4:6,:) = repmat(-eye(3),[1,1,n]);
    KkA(1:3,19:21,:) = repmat(eye(3),[1,1,n]);
    KkA(4,1:3,:) = permute(Segment(3).Q(10:12,1,:),[2,1,3]); % w3'
    KkA(4,22:24,:) = permute(Segment(2).Q(1:3,1,:),[2,1,3]); % u2'
    % with transpose = permute( ,[2,1,3])
    % Joint structure
    Joint(2).Kk = KkA;
    % Partial derivative of Jacobian * Lagrange multipliers
    dKlambdakAdQ = zeros(4*12,4*12,n); % Initialisation
    dKlambdakAdQ(1,22,:) = lambdakA(4,1,:);
    dKlambdakAdQ(2,23,:) = lambdakA(4,1,:);
    dKlambdakAdQ(3,24,:) = lambdakA(4,1,:);
    dKlambdakAdQ(22,1,:) = lambdakA(4,1,:);
    dKlambdakAdQ(23,2,:) = lambdakA(4,1,:);
    dKlambdakAdQ(24,3,:) = lambdakA(4,1,:);
            
    % Vector of kinematic constraints
    % rD4 - rP3 = 0
    % w4.(rP3 - rD3) - L3*cos(thetaK1) = 0
    phikK = [Segment(4).Q(7:9,1,:) - Segment(3).Q(4:6,1,:);...
        dot(Segment(4).Q(10:12,1,:),...
        Segment(3).Q(4:6,1,:) - Segment(3).Q(7:9,1,:)) - ...
        repmat(Segment(3).L*cosd(thetaK1),[1,1,n])];
    % Jacobian of kinematic constraints
    KkK = zeros(4,4*12,n); % Initialisation
    KkK(1:3,16:18,:) = repmat(-eye(3),[1,1,n]);
    KkK(1:3,31:33,:) = repmat(eye(3),[1,1,n]);
    KkK(4,16:18,:) = permute(Segment(4).Q(10:12,1,:),[2,1,3]); % w4'
    KkK(4,19:21,:) = permute(-Segment(4).Q(10:12,1,:),[2,1,3]); % -w4'
    KkK(4,34:36,:) = permute(Segment(3).Q(4:6,1,:) - ...
        Segment(3).Q(7:9,1,:),[2,1,3]); % (rP3 - rD3)'
    % with transpose = permute( ,[2,1,3])
    % Joint structure
    Joint(3).Kk = KkK;
    % Partial derivative of Jacobian * Lagrange multipliers
    dKlambdakKdQ = zeros(4*12,4*12,n); % Initialisation
    dKlambdakKdQ(16,34,:) = lambdakK(4,1,:);
    dKlambdakKdQ(17,35,:) = lambdakK(4,1,:);
    dKlambdakKdQ(18,36,:) = lambdakK(4,1,:);
    dKlambdakKdQ(19,34,:) = - lambdakK(4,1,:);
    dKlambdakKdQ(20,35,:) = - lambdakK(4,1,:);
    dKlambdakKdQ(21,36,:) = - lambdakK(4,1,:);
    dKlambdakKdQ(34,16,:) = lambdakK(4,1,:);
    dKlambdakKdQ(35,17,:) = lambdakK(4,1,:);
    dKlambdakKdQ(36,18,:) = lambdakK(4,1,:);
    dKlambdakKdQ(34,19,:) = - lambdakK(4,1,:);
    dKlambdakKdQ(35,20,:) = - lambdakK(4,1,:);
    dKlambdakKdQ(36,21,:) = - lambdakK(4,1,:);
    
    % Hip
    % Vector of kinematic constraints
    % rV15 - rP4 = 0
    phikH = Mprod_array3(repmat(NV15,[1,1,n]),Segment(5).Q) - ...
        Segment(4).Q(4:6,1,:);
    % Jacobian of kinematic constraints
    KkH = zeros(3,4*12,n); % Initialisation
    KkH(1:3,28:30,:) = repmat(-eye(3),[1,1,n]);
    KkH(1:3,37:48,:) = repmat(NV15,[1,1,n]);
    % Joint structure
    Joint(4).Kk = KkH;
    % Partial derivative of Jacobian * Lagrange multipliers
    dKlambdakHdQ = zeros(4*12,4*12,n); % Initialisation
    
   % Assembly
    phik = [phikA;phikK;phikH];
    Kk = [KkA;KkK;KkH];
    lambdak = [lambdakA;lambdakK;lambdakH];
    dKlambdakdQ = dKlambdakAdQ + dKlambdakKdQ + dKlambdakHdQ;
    
    
    % ---------------------------------------------------------------------
    % Rigid body constraints and driving constraints
    for i = 2:5 % From i = 2 (Foot) to i = 5 (Pelvis)
        
        % Vector of rigid body constraints
        ui = Segment(i).Q(1:3,1,:);
        vi = Segment(i).Q(4:6,1,:) - Segment(i).Q(7:9,1,:);
        wi = Segment(i).Q(10:12,1,:);
        phiri = [dot(ui,ui) - ones(1,1,n);...
            dot(ui,vi) - repmat(Segment(i).L*cosd(Segment(i).gamma),[1,1,n]); ...
            dot(ui,wi) - repmat(cosd(Segment(i).beta),[1,1,n]); ...
            dot(vi,vi) - repmat(Segment(i).L^2,[1,1,n]);
            dot(vi,wi) - repmat(Segment(i).L*cosd(Segment(i).alpha),[1,1,n]);
            dot(wi,wi) - ones(1,1,n)];
        
        % Jacobian of rigid body constraints
        Kri = zeros(6,4*12,n); % Initialisation
        Kri(1:6,(i-2)*12+1:(i-2)*12+12,:) = permute(...
            [    2*ui,       vi,           wi,     zeros(3,1,n),zeros(3,1,n),zeros(3,1,n); ...
            zeros(3,1,n),    ui,      zeros(3,1,n),    2*vi,         wi,     zeros(3,1,n); ...
            zeros(3,1,n),   -ui,      zeros(3,1,n),   -2*vi,        -wi,     zeros(3,1,n); ...
            zeros(3,1,n),zeros(3,1,n),     ui,     zeros(3,1,n),     vi,         2*wi],[2,1,3]);
        % with transpose = permute( ,[2,1,3])
        % Segment structure
        Segment(i).Kr = Kri;
        
        % Partial derivative of Jacobian * Lagrange multipliers
        dKlambdaridQ = zeros(12,4*12,n); % Initialisation
        lambdari = lambdar((i-2)*6+1:(i-2)*6+6,1,:); % Extraction
        dKlambdaridQ(1:12,(i-2)*12+1:(i-2)*12+12,:) = ...
            [Mprod_array3(lambdari(1,1,:),repmat(2*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(2,1,:),repmat(eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(2,1,:),repmat(-1*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(3,1,:),repmat(eye(3),[1,1,n])); ...
            Mprod_array3(lambdari(2,1,:),repmat(eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(4,1,:),repmat(2*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(4,1,:),repmat(-2*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(5,1,:),repmat(eye(3),[1,1,n])); ...
            Mprod_array3(lambdari(2,1,:),repmat(-1*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(4,1,:),repmat(-2*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(4,1,:),repmat(2*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(5,1,:),repmat(-1*eye(3),[1,1,n])); ...
            Mprod_array3(lambdari(3,1,:),repmat(eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(5,1,:),repmat(eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(5,1,:),repmat(-1*eye(3),[1,1,n])), ...
            Mprod_array3(lambdari(6,1,:),repmat(2*eye(3),[1,1,n]))];
        
        % Vector and Jacobian of driving constraints
        Kmi = zeros(size(Segment(i).rM,2)*3,4*12,n); % Initialisation
        phimi = []; % Initialisation
        for j = 1:size(Segment(i).rM,2)
            % Interpolation matrix
            NMij = [Segment(i).nM(1,j)*eye(3),...
                (1 + Segment(i).nM(2,j))*eye(3), ...
                - Segment(i).nM(2,j)*eye(3), ...
                Segment(i).nM(3,j)*eye(3)];
            % Vector of driving constraints
            phimi((j-1)*3+1:(j-1)*3+3,1,:) = Segment(i).rM(:,j,:) ...
                - Mprod_array3(repmat(NMij,[1,1,n]),Segment(i).Q);
            % Jacobian of driving contraints
            Kmi((j-1)*3+1:(j-1)*3+3,(i-2)*12+1:(i-2)*12+12,:) = ...
                repmat(-NMij,[1,1,n]);
        end
        
        % Assembly
        phir = [phir;phiri];
        Kr = [Kr;Kri];
        dKlambdardQ = [dKlambdardQ;dKlambdaridQ];
        phim = [phim;phimi];
        Km = [Km;Kmi];
        
    end
    
    % Display errors
    Mean_phik = mean(Mprod_array3(permute(phik,[2,1,3]),phik),3)
    Mean_phir = mean(Mprod_array3(permute(phir,[2,1,3]),phir),3)
    Mean_phim = mean(Mprod_array3(permute(phim,[2,1,3]),phim),3)
    
    
    % ---------------------------------------------------------------------
    % Solution
    
    % Compute dX
    % dX = inv(-dF/dx)*F(X)
    % F(X) = [Km'*phim + [Kk;Kr]'*[lambdak;lambdar];[phik;phir]]
    % X = [Q;[lambdak;lambdar]]
    F = [Mprod_array3(permute(Km,[2,1,3]),phim) + ...
        Mprod_array3(permute([Kk;Kr],[2,1,3]), [lambdak;lambdar]); ...
        [phik;phir]]; % with transpose = permute( ,[2,1,3])
    dKlambdadQ = dKlambdakdQ + dKlambdardQ;
    dFdX = [Mprod_array3(permute(Km,[2,1,3]),Km) + ...
        dKlambdadQ, permute([Kk;Kr],[2,1,3]); ...
        [Kk;Kr],zeros(size([Kk;Kr],1),size([Kk;Kr],1),n)];
    dX = Mprod_array3(Minv_array3(-dFdX),F);
    
    
    % ---------------------------------------------------------------------
    % Extraction from X
    Segment(2).Q = Segment(2).Q + dX(1:12,1,:);
    Segment(3).Q = Segment(3).Q + dX(13:24,1,:);
    Segment(4).Q = Segment(4).Q + dX(25:36,1,:);
    Segment(5).Q = Segment(5).Q + dX(37:48,1,:);
    
    lambdakA = lambdakA + dX(49:52,1,:);
    lambdakK = lambdakK + dX(53:56,1,:);
    lambdakH = lambdakH + dX(57:59,1,:);
    lambdar = lambdar + dX(60:83,1,:);
    
end
