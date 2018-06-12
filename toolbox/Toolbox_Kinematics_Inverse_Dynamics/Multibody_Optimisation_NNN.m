% FUNCTION
% Multibody_Optimisation_NNN.m
%__________________________________________________________________________
%
% PURPOSE
% Multibody optimisation : minimisation of the sum of the square distances 
% between measured and model-determined marker positions subject to 
% kinematic and rigid body constraints (Gauss-Newton algorithm)
%
% SYNOPSIS
% Segment = Multibody_Optimisation_NNN(Segment)
%
% INPUT
% Segment (cf. data structure in user guide)
% Model (type of kinematic constraints)
%
% OUTPUT
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of Q by minimisation under constraints (the number of DoFs 
% are 6 at the ankle/wrist, knee/elbow and hip/shoulder):
% 'N': None (6 degrees of freedom) at ankle/wrist
% 'N': None (6 degrees of freedom) at knee/elbow
% 'N': None (6 degrees of freedom) at hip/shoulder
%
% REFERENCES
% S Duprey, L Cheze, R Dumas. Influence of joint constraints on lower
% limb kinematics estimation from skin markers using global optimization.
% Journal of Biomechanics 2010;43(14):2858-2862.
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
% Version with one choice of joint models: NNN
%
% Modified by Raphaël Dumas
% July 2016
% Last updates for Matlab Central
%__________________________________________________________________________
%
% Licence
% Toolbox distributed under BSD license
%__________________________________________________________________________

function Segment = Multibody_Optimisation_NNN(Segment)

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

% Initial guess for Lagrange multipliers
lambdakA = []; % To be concatenated
lambdakK = []; % To be concatenated
lambdakH = []; % To be concatenate


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
    step = step + 1 % Display
    
    % Initialisation
    phik = []; % Vector of kinematic constraints
    Kk = [];  % Jacobian of kinematic constraints
    phir = []; % Vector of rigid body constraints
    Kr = []; % Jacobian of rigid body constraints
    dKlambdardQ = []; % Partial derivative of Jacobian * Lagrange multipliers
    phim = []; % Vector of driving constraints
    Km = []; % Jacobian of driving constraints
    
    % ---------------------------------------------------------------------
    % Ankle
    
    % Vector of kinematic constraints
    phikA = []; % To be concatenated
    % Jacobian of kinematic constraints
    KkA = [];  % To be concatenated
    % Joint structure
    Joint(2).Kk = KkA;
    % Partial derivative of Jacobian * Lagrange multipliers
    dKlambdakAdQ = zeros(4*12,4*12,n);  % To be summed up
    
    % Knee
    % Vector of kinematic constraints
    phikK = []; % To be concatenated
    % Jacobian of kinematic constraints
    KkK = []; % To be concatenated
    % Joint structure
    Joint(3).Kk = KkK;
    % Partial derivative of Jacobian * Lagrange multipliers
    dKlambdakKdQ = zeros(4*12,4*12,n); % To be summed up
    
    % Hip
    % Vector of kinematic constraints
    phikH = []; % To be concatenated
    % Jacobian of kinematic constraints
    KkH = []; % To be concatenated
    % Joint structure
    Joint(4).Kk = KkH;
    % Partial derivative of Jacobian * Lagrange multipliers
    dKlambdakHdQ = zeros(4*12,4*12,n); % To be summed up
    
    % Assembly
    phik = [phikA;phikK;phikH];
    Kk = [KkA;KkK;KkH];
    lambdak= [lambdakA;lambdakK;lambdakH];
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
    
    lambdar = lambdar + dX(end - 4*6 + 1:end,1,:);
    
end
