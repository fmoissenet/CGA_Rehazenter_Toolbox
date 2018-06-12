% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    posture_setStaticSegment
% -------------------------------------------------------------------------
% Subject:      Define segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Marker (structure)
%               - Vmarker (structure)
% Outputs:      - Static (structure)
%               - Marker (structure)
%               - Vmarker (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 3
% =========================================================================

function [Static,Marker,Vmarker] = posture_setStaticSegment(Patient,Marker,Vmarker)

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
w_pelvis = sqrt(sum((Marker.R_IAS-Marker.L_IAS).^2)); % pelvis width
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
Vmarker.LJC_static = (Marker.R_IAS+Marker.L_IAS)/2 + ...
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
Vmarker.R_HJC_static = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    R_HJC(1)*w_pelvis*X5 + R_HJC(2)*w_pelvis*Y5 + R_HJC(3)*w_pelvis*Z5;
Vmarker.L_HJC_static = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    L_HJC(1)*w_pelvis*X5 + L_HJC(2)*w_pelvis*Y5 + L_HJC(3)*w_pelvis*Z5;
% Pelvis parameters (Dumas and Wojtusch 2018)
rP5 = Vmarker.LJC_static;
rD5 = (Vmarker.R_HJC_static+Vmarker.L_HJC_static)/2;
w5 = Z5;
u5 = X5;
Static(5).Q = [u5;rP5;rD5;w5];
Static(5).rM = [Marker.R_IAS,Marker.L_IAS,Marker.R_IPS,Marker.L_IPS];

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
Xj = [Marker.CV7(1) Marker.CV7(2) Marker.CV7(3); 
    Marker.SJN(1) Marker.SJN(2) Marker.SJN(3);
    Marker.SXS(1) Marker.SXS(2) Marker.SXS(3);
    Vmarker.LJC_static(1) Vmarker.LJC_static(2) Vmarker.LJC_static(3)];
Vmarker.T12L1_static = (Affine_3D_Approximation(T12_L1,Xi,Xj))';
% Abdomen axes (Dumas and Wojtusch 2018)
Y4 = Vnorm_array3(Vmarker.T12L1_static-Vmarker.LJC_static);
Z4 = Z5; % no axial rotation at lumbar joint centre assumed
X4 = Vnorm_array3(cross(Y4,Z4));
% Abdomen parameters
rP4 = Vmarker.T12L1_static;
rD4 = Vmarker.LJC_static;
w4 = Z4;
u4 = X4;
Static(4).Q = [u4;rP4;rD4;w4];
Static(4).rM = [Vmarker.T12L1_static,Marker.R_IPS,Marker.L_IPS]; % no axial rotation at lumbar joint centre assumed

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
Vmarker.CJC_static = Mprod_array3(Mprod_array3([tX3 tY3 tZ3 Marker.CV7; ...
    [0 0 0 1]], R3), [coeff*W3; 0; 0; 1]);
Vmarker.CJC_static = Vmarker.CJC_static(1:3);
% Thorax axes (Dumas and Chèze 2007)
Y3 = Vnorm_array3(Vmarker.CJC_static-Vmarker.T12L1_static);
Z3 = Vnorm_array3(cross(Marker.SJN-Vmarker.T12L1_static,Vmarker.CJC_static-Vmarker.T12L1_static));
X3 = Vnorm_array3(cross(Y3,Z3));
% Thorax parameters
rP3 = Vmarker.CJC_static;
rD3 = Vmarker.T12L1_static;
w3 = Z3;
u3 = X3;
Static(3).Q = [u3;rP3;rD3;w3];
Static(3).rM = [Marker.SJN,Marker.CV7,Marker.SXS,Vmarker.T12L1_static];

% =========================================================================
% Head with neck parameters
% =========================================================================
% Head vertex (Dumas and Wojtusch 2018)
Vmarker.VER_static = (Marker.R_HDB+Marker.L_HDB)/2; % assimilated to the head vertex described in Dumas and Wojtusch 2018
% Head axes (Dumas and Wojtusch 2018)
Y2 = Vnorm_array3(Vmarker.VER_static-Vmarker.CJC_static);
Z2 = Vnorm_array3(cross((Marker.R_HDF+Marker.L_HDF)/2-Vmarker.CJC_static, ...
    (Marker.R_HDB+Marker.L_HDB)/2-Vmarker.CJC_static));
X2 = Vnorm_array3(cross(Y2,Z2));
% Head parameters (Dumas and Chèze 2007)
rP2 = Vmarker.VER_static;
rD2 = Vmarker.CJC_static;
w2 = Z2;
u2 = X2;
Static(2).Q = [u2;rP2;rD2;w2];
% Manage the lost of one head marker
Static(2).rM_LHDF = [Marker.R_HDF,Marker.L_HDB,Marker.R_HDB];
Static(2).rM_RHDF = [Marker.L_HDF,Marker.L_HDB,Marker.R_HDB];
Static(2).rM_LHDB = [Marker.R_HDF,Marker.L_HDF,Marker.R_HDB];
Static(2).rM_RHDB = [Marker.R_HDF,Marker.L_HDF,Marker.L_HDB];
Vmarker.R_HDF_static = Marker.R_HDF;
Vmarker.L_HDF_static = Marker.L_HDF;
Vmarker.R_HDB_static = Marker.R_HDB;
Vmarker.L_HDB_static = Marker.L_HDB;