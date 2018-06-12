% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    upperLimb_setStaticSegment
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

function [Static,Marker,Vmarker] = upperLimb_setStaticSegment(Patient,Marker,Vmarker)

% =========================================================================
% Kinematic chain:
% -------------------------------------------------------------------------
% Thorax segment = 6
% Scapula segment / scapulothoracic joint = 5
% Humerus segment / glenohumeral joint = 4
% Radius/Ulna segment / elbow joint = 3
% Hand segment / wrist joint = 2
% =========================================================================

% =========================================================================
% Thorax parameters
% =========================================================================
% Thorax width (Dumas and Wojtusch 2018)
W6 = mean(sqrt(sum((Marker.SJN-Marker.CV7).^2)));
% Determination of the cervical joint centre by regression (Dumas and Wojtusch 2018)
tX6 = Vnorm_array3(Marker.SJN-Marker.CV7);
tZ6 = Vnorm_array3(cross(Marker.SXS-Marker.CV7,Marker.SJN-Marker.CV7));
tY6 = Vnorm_array3(cross(tZ6,tX6));
if strcmp(Patient.gender,'Femme')
    angle = -14;
    coeff = 0.53;
elseif strcmp(Patient.gender,'Homme')
    angle = -8;
    coeff = 0.55;
end
R6 = [cosd(angle) sind(angle) 0 0; ...
    -sind(angle) cosd(angle) 0 0;
    0 0 1 0; ...
    0 0 0 1];
Vmarker.CJC_static = Mprod_array3(Mprod_array3([tX6 tY6 tZ6 Marker.CV7; ...
    [0 0 0 1]], R6), [coeff*W6; 0; 0; 1]);
Vmarker.CJC_static = Vmarker.CJC_static(1:3);
% Determination for the lumbar joint centre by regression (Dumas and Wojtusch 2018)
w_pelvis = sqrt(sum((Marker.R_IAS-Marker.L_IAS).^2)); % pelvis width
if strcmp(Patient.gender,'Femme')
    LJC(1) = -34.0/100;
    LJC(2) = 4.9/100;
    LJC(3) = 0.0/100;
elseif strcmp(Patient.gender,'Homme')
    LJC(1) = -33.5/100;
    LJC(2) = -3.2/100;
    LJC(3) = 0.0/100;
end
Z = Vnorm_array3(Marker.R_IAS-Marker.L_IAS);
Y = Vnorm_array3(cross(Marker.R_IAS-(Marker.R_IPS+Marker.L_IPS)/2,...
    Marker.L_IAS-(Marker.R_IPS+Marker.L_IPS)/2));
X = Vnorm_array3(cross(Y,Z));
Vmarker.LJC_static = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    LJC(1)*w_pelvis*X + LJC(2)*w_pelvis*Y + LJC(3)*w_pelvis*Z;
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
% Thorax axes (Dumas and Chèze 2007)
Y6 = Vnorm_array3(Vmarker.CJC_static-Vmarker.T12L1_static);
Z6 = Vnorm_array3(cross(Marker.SJN-Vmarker.T12L1_static,Vmarker.CJC_static-Vmarker.T12L1_static));
X6 = Vnorm_array3(cross(Y6,Z6));
% Thorax parameters
rP6 = Vmarker.CJC_static;
rD6 = Vmarker.T12L1_static;
w6 = Z6;
u6 = X6;
Static(6).Q = [u6;rP6;rD6;w6];
Static(6).rM = [Marker.SJN,Marker.CV7,Marker.SXS,Vmarker.T12L1_static];

% =========================================================================
% Scapula parameters
% =========================================================================
% Technical axes defined for torso are used here
% Determination of the glenohumeral joint centre by regression (Dumas and Wojtusch 2018)
if strcmp(Patient.gender,'Femme')
    angle = 5;
    coeff = 0.36;
elseif strcmp(Patient.gender,'Homme')
    angle = 11;
    coeff = 0.33;
end
R5 = [cosd(angle) sind(angle) 0 0; ...
    -sind(angle) cosd(angle) 0 0;
    0 0 1 0; ...
    0 0 0 1];
Vmarker.R_GHJC_static = Mprod_array3(Mprod_array3([tX6 tY6 tZ6 Marker.R_SAJ; ...
    [0 0 0 1]], R5), [coeff*W6; 0; 0; 1]);
Vmarker.R_GHJC_static = Vmarker.R_GHJC_static(1:3);
% Scapula parameters (Habachi et al. 2015)
rP5 = Marker.R_SAJ;
rD5 = Vmarker.R_GHJC_static;
w5 = Vnorm_array3(Marker.R_SAA-Marker.R_SRS);
u5 = Vnorm_array3(cross(Marker.R_SRS-Marker.R_SIA,Marker.R_SAA-Marker.R_SIA));
Static(5).Q = [u5;rP5;rD5;w5];
Static(5).rM = [Marker.R_SAA,Marker.R_SRS,Marker.R_SIA,Marker.R_SAJ];

% =========================================================================
% Humerus parameters
% =========================================================================
% Elbow joint centre (Dumas and Wojtusch 2018)
Vmarker.R_EJC_static = (Marker.R_HLE+Marker.R_HME)/2;
% Humerus axes (Dumas and Wojtusch 2018)
Y4 = Vnorm_array3(Vmarker.R_GHJC_static-Vmarker.R_EJC_static);
X4 = Vnorm_array3(cross(Marker.R_HLE-Vmarker.R_GHJC_static,Marker.R_HME-Vmarker.R_GHJC_static));
Z4 = Vnorm_array3(cross(X4,Y4));
% Humerus parameters (Dumas and Chèze 2007)
rP4 = Vmarker.R_GHJC_static;
rD4 = Vmarker.R_EJC_static;
w4 = Z4;
u4 = X4;
Static(4).Q = [u4;rP4;rD4;w4];
Static(4).rM = [Vmarker.R_GHJC_static,Marker.R_HME,Marker.R_HLE];

% =========================================================================
% Radius/Ulna parameters
% =========================================================================
% Wrist joint centre (Dumas and Wojtusch 2018)
Vmarker.R_WJC_static = (Marker.R_UHE+Marker.R_RSP)/2;
% Radius/Ulna axes (Dumas and Wojtusch 2018)
Y3 = Vnorm_array3(Vmarker.R_EJC_static-Vmarker.R_WJC_static);
X3 = Vnorm_array3(cross(Marker.R_RSP-Vmarker.R_EJC_static,Marker.R_UHE-Vmarker.R_EJC_static));
Z3 = Vnorm_array3(cross(X3,Y3));
% Radius/Ulna parameters (Dumas and Chèze 2007)
rP3 = Vmarker.R_EJC_static;
rD3 = Vmarker.R_WJC_static;
w3 = Z3;
u3 = X3;
Static(3).Q = [u3;rP3;rD3;w3];
Static(3).rM = [Vmarker.R_EJC_static,Marker.R_UHE,Marker.R_RSP];

% =========================================================================
% Hand parameters
% =========================================================================
% Metacarpal joint centre (Dumas and Wojtusch 2018)
Vmarker.R_MCJC_static = (Marker.R_HM2+Marker.R_HM5)/2;
% Hand axes (Dumas and Wojtusch 2018)
Y2 = Vnorm_array3(Vmarker.R_WJC_static-Vmarker.R_MCJC_static);
X2 = Vnorm_array3(cross(Marker.R_HM2-Vmarker.R_WJC_static,Marker.R_HM5-Vmarker.R_WJC_static));
Z2 = Vnorm_array3(cross(X2,Y2));
% Hand parameters (Dumas and Chèze 2007)
rP2 = Vmarker.R_WJC_static;
rD2 = Vmarker.R_MCJC_static;
w2 = Z2;
u2 = X2;
Static(2).Q = [u2;rP2;rD2;w2];
Static(2).rM = [Vmarker.R_WJC_static,Marker.R_HM2,Marker.R_HM5];