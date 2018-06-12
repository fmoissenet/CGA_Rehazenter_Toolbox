% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    posture_setCycleSegment
% -------------------------------------------------------------------------
% Subject:      Define segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Static (structure)
%               - Marker (structure)
%               - Vmarker (structure)
%               - n (int)
% Outputs:      - Segment (structure)
%               - Marker (structure)
%               - Vmarker (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 09/12/2014: Introduce right/left_leg_length in Session
% =========================================================================

function [Segment,Marker,Vmarker] = posture_setCycleSegment(Patient,Static,Marker,Vmarker,n)

% =========================================================================
% Kinematic chain:
% -------------------------------------------------------------------------
% Pelvis = 5
% Abdomen/lumbosacral = 4
% Thorax/thoracolumbar = 3
% Head/cervicothoracic = 2
% =========================================================================

% =========================================================================
% Pelvis parameters
% =========================================================================
% Pelvis axes (Dumas and Wojtusch 2018)
Z5 = Vnorm_array3(Marker.R_IAS-Marker.L_IAS);
Y5 = Vnorm_array3(cross(Marker.R_IAS-(Marker.R_IPS+Marker.L_IPS)/2,...
    Marker.L_IAS-(Marker.R_IPS+Marker.L_IPS)/2));
X5 = Vnorm_array3(cross(Y5,Z5));
w_pelvis = mean(sqrt(sum((Marker.R_IAS-Marker.L_IAS).^2))); % pelvis width
% Determination for the lumbar joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    LJC(1) = -34.0/100;
    LJC(2) = 4.9/100;
    LJC(3) = 0.0/100;
elseif strcmp(Patient.gender,'Homme')
    LJC(1) = -33.5/100;
    LJC(2) = -3.2/100;
    LJC(3) = 0.0/100;
end
Vmarker.LJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    LJC(1)*w_pelvis*X5 + LJC(2)*w_pelvis*Y5 + LJC(3)*w_pelvis*Z5;
% Determination for the hip joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    R_HJC(1) = -13.9/100;
    R_HJC(2) = -33.6/100;
    R_HJC(3) = 37.2/100;
    L_HJC(1) = -13.9/100;
    L_HJC(2) = -33.6/100;
    L_HJC(3) = -37.2/100;
elseif strcmp(Patient.gender,'Homme')
    R_HJC(1) = -9.5/100;
    R_HJC(2) = -37.0/100;
    R_HJC(3) = 36.1/100;
    L_HJC(1) = -9.5/100;
    L_HJC(2) = -37.0/100;
    L_HJC(3) = -36.1/100;
end
Vmarker.R_HJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    R_HJC(1)*w_pelvis*X5 + R_HJC(2)*w_pelvis*Y5 + R_HJC(3)*w_pelvis*Z5;
Vmarker.L_HJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    L_HJC(1)*w_pelvis*X5 + L_HJC(2)*w_pelvis*Y5 + L_HJC(3)*w_pelvis*Z5;
% Pelvis parameters (Dumas and Chèze 2007)
rP5 = Vmarker.LJC;
rD5 = (Vmarker.R_HJC+Vmarker.L_HJC)/2;
w5 = Z5;
u5 = X5;
Segment(5).Q = [u5;rP5;rD5;w5];
Segment(5).rM = [Marker.R_IAS,Marker.L_IAS,Marker.R_IPS,Marker.L_IPS];

% =========================================================================
% Abdomen parameters
% =========================================================================
% Determination of the T12 - L1 joint centre by affine approximation
C7 = [-266  489];
SUP = [-139  435];
SUB = [-72  336];
L5_S1 = [-89  39];
T12_L1 = [-177  165];
Xi = [C7;SUP;SUB;L5_S1];
Vmarker.T12L1 = [];
for i = 1:n
    Xj = [Marker.CV7(1,1,i) Marker.CV7(2,1,i) Marker.CV7(3,1,i); 
        Marker.SJN(1,1,i) Marker.SJN(2,1,i) Marker.SJN(3,1,i);
        Marker.SXS(1,1,i) Marker.SXS(2,1,i) Marker.SXS(3,1,i);
        Vmarker.LJC(1,1,i) Vmarker.LJC(2,1,i) Vmarker.LJC(3,1,i)];
    Vmarker.T12L1(:,:,i) = (Affine_3D_Approximation(T12_L1,Xi,Xj))';
end
% Abdomen axes (Dumas and Wojtusch 2018)
Y4 = Vnorm_array3(Vmarker.T12L1-Vmarker.LJC);
Z4 = Z5; % no axial rotation at lumbar joint centre assumed
X4 = Vnorm_array3(cross(Y4,Z4));
% Abdomen parameters
rP4 = Vmarker.T12L1;
rD4 = Vmarker.LJC;
w4 = Z4;
u4 = X4;
Segment(4).Q = [u4;rP4;rD4;w4];
Segment(4).rM = [Vmarker.T12L1,Marker.R_IPS,Marker.L_IPS]; % no axial rotation at lumbar joint centre assumed

% =========================================================================
% Thorax parameters
% =========================================================================
% Thorax width (Dumas and Wojtusch 2018)
W3 = mean(sqrt(sum((Marker.SJN-Marker.CV7).^2)));
% Determination of the cervical joint centre by regression (Dumas and Wojtusch 2018)
tX3 = Vnorm_array3(Marker.SJN-Marker.CV7);
tZ3 = Vnorm_array3(cross(Marker.SXS-Marker.CV7,Marker.SJN-Marker.CV7));
tY3 = Vnorm_array3(cross(tZ3,tX3));
if strcmp(Patient.gender,'Femme')
    angle = -14;
    coeff = 0.53;
elseif strcmp(Patient.gender,'Homme')
    angle = -8;
    coeff = 0.55;
end
R3 = [cosd(angle) sind(angle) 0 0; ...
    -sind(angle) cosd(angle) 0 0;
    0 0 1 0; ...
    0 0 0 1];
Vmarker.CJC = Mprod_array3(Mprod_array3([tX3 tY3 tZ3 Marker.CV7; ...
    repmat([0 0 0 1],[1,1,size(Marker.CV7,3)])], ...
    repmat(R3,[1,1,size(Marker.CV7,3)])), ...
    repmat([coeff*W3; 0; 0; 1],[1,1,size(Marker.CV7,3)]));
Vmarker.CJC = Vmarker.CJC(1:3,:,:);
% Thorax axes (Dumas and Chèze 2007)
Y3 = Vnorm_array3(Vmarker.CJC-Vmarker.T12L1);
Z3 = Vnorm_array3(cross(Marker.SJN-Vmarker.T12L1,Vmarker.CJC-Vmarker.T12L1));
X3 = Vnorm_array3(cross(Y3,Z3));
% Thorax parameters
rP3 = Vmarker.CJC;
rD3 = Vmarker.T12L1;
w3 = Z3;
u3 = X3;
Segment(3).Q = [u3;rP3;rD3;w3];
Segment(3).rM = [Marker.SJN,Marker.CV7,Marker.SXS,Vmarker.T12L1];

% =========================================================================
% Head with neck parameters
% =========================================================================
nmarkers = isfield(Marker,'R_HDF')+isfield(Marker,'R_HDB')+...
    isfield(Marker,'L_HDF')+isfield(Marker,'L_HDB');
if nmarkers == 3    
    % no L_HDB
    if isfield(Marker,'R_HDF') && isfield(Marker,'L_HDF') && isfield(Marker,'R_HDB') 
        Segment(2).rM = [Marker.R_HDF,Marker.L_HDF,Marker.R_HDB];
        n = size(Marker.R_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(2).rM_LHDB',Segment(2).rM(:,:,i)');
        end
        Marker.L_HDB = ...
            Mprod_array3(Rotation , repmat(Vmarker.L_HDB_static,[1 1 n])) ...
            + Translation;
        Marker.L_HDB = Marker.L_HDB(1:3,:,:);
        nmarkers = 4;
    % no R_HDB
    elseif isfield(Marker,'R_HDF') && isfield(Marker,'L_HDF') && isfield(Marker,'L_HDB') 
        Segment(2).rM = [Marker.R_HDF,Marker.L_HDF,Marker.L_HDB];
        n = size(Marker.R_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(2).rM_RHDB',Segment(2).rM(:,:,i)');
        end
        Marker.R_HDB = ...
            Mprod_array3(Rotation , repmat(Vmarker.R_HDB_static,[1 1 n])) ...
            + Translation;
        Marker.R_HDB = Marker.R_HDB(1:3,:,:);
        nmarkers = 4;
    % no L_HDF
    elseif isfield(Marker,'R_HDF') && isfield(Marker,'L_HDB') && isfield(Marker,'R_HDB') 
        Segment(2).rM = [Marker.R_HDF,Marker.L_HDB,Marker.R_HDB];
        n = size(Marker.R_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(2).rM_LHDF',Segment(2).rM(:,:,i)');
        end
        Marker.L_HDF = ...
            Mprod_array3(Rotation , repmat(Vmarker.L_HDF_static,[1 1 n])) ...
            + Translation;
        Marker.L_HDF = Marker.L_HDF(1:3,:,:);
        nmarkers = 4;
    % no R_HDF
    elseif isfield(Marker,'L_HDF') && isfield(Marker,'L_HDB') && isfield(Marker,'R_HDB') 
        Segment(2).rM = [Marker.L_HDF,Marker.L_HDB,Marker.R_HDB];
        n = size(Marker.L_HDF,3);
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(2).rM_RHDF',Segment(2).rM(:,:,i)');
        end
        Marker.R_HDF = ...
            Mprod_array3(Rotation , repmat(Vmarker.R_HDF_static,[1 1 n])) ...
            + Translation;
        Marker.R_HDF = Marker.R_HDF(1:3,:,:);
        nmarkers = 4;
    end
end
if nmarkers == 4
    % Head vertex (Dumas and Wojtusch 2018)
    Vmarker.VER = (Marker.R_HDB+Marker.L_HDB)/2; % assimilated to the head vertex described in Dumas and Wojtusch 2018
    % Head axes
    Y2 = Vnorm_array3(Vmarker.VER-Vmarker.CJC);
    Z2 = Vnorm_array3(cross((Marker.R_HDF+Marker.L_HDF)/2-Vmarker.CJC, ...
        (Marker.R_HDB+Marker.L_HDB)/2-Vmarker.CJC));
    X2 = Vnorm_array3(cross(Y2,Z2));
    % Head parameters
    rP2 = Vmarker.VER;
    rD2 = Vmarker.CJC;
    w2 = Z2;
    u2 = X2;
    Segment(2).Q = [u2;rP2;rD2;w2];
    Segment(2).rM = [Marker.R_HDF,Marker.R_HDB,Marker.L_HDF,Marker.L_HDB];
end