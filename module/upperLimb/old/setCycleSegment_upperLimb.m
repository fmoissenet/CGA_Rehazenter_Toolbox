% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    upperLimb_setCycleSegment
% -------------------------------------------------------------------------
% Subject:      Define segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
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

function [Segment,Marker,Vmarker] = upperLimb_setCycleSegment(Patient,Marker,Vmarker,n)

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
Vmarker.CJC = Mprod_array3(Mprod_array3([tX6 tY6 tZ6 Marker.CV7; ...
    repmat([0 0 0 1],[1,1,n])], repmat(R6,[1,1,n])), repmat([coeff*W6; 0; 0; 1],[1,1,n]));
Vmarker.CJC = Vmarker.CJC(1:3,:,:);
% Determination for the lumbar joint centre by regression (Dumas and Wojtusch 2018)
w_pelvis = mean(sqrt(sum((Marker.R_IAS-Marker.L_IAS).^2))); % pelvis width
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
Vmarker.LJC = (Marker.R_IAS+Marker.L_IAS)/2 + ...
    LJC(1)*w_pelvis*X + LJC(2)*w_pelvis*Y + LJC(3)*w_pelvis*Z;
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
% Thorax axes (Dumas and Chèze 2007)
Y6 = Vnorm_array3(Vmarker.CJC-Vmarker.T12L1);
Z6 = Vnorm_array3(cross(Marker.SJN-Vmarker.T12L1,Vmarker.CJC-Vmarker.T12L1));
X6 = Vnorm_array3(cross(Y6,Z6));
% Thorax parameters
rP6 = Vmarker.CJC;
rD6 = Vmarker.T12L1;
w6 = Z6;
u6 = X6;
Segment(6).Q = [u6;rP6;rD6;w6];
Segment(6).rM = [Marker.SJN,Marker.CV7,Marker.SXS,Vmarker.T12L1];

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
Vmarker.R_GHJC = Mprod_array3(Mprod_array3([tX6 tY6 tZ6 Marker.R_SAJ; ...
    repmat([0 0 0 1],[1,1,n])], repmat(R5,[1,1,n])), repmat([coeff*W6; 0; 0; 1],[1,1,n]));
Vmarker.R_GHJC = Vmarker.R_GHJC(1:3,:,:);
% Scapula parameters (Habachi et al. 2015)
rP5 = Marker.R_SAJ;
rD5 = Vmarker.R_GHJC;
w5 = Vnorm_array3(Marker.R_SAA-Marker.R_SRS);
u5 = Vnorm_array3(cross(Marker.R_SRS-Marker.R_SIA,Marker.R_SAA-Marker.R_SIA));
Segment(5).Q = [u5;rP5;rD5;w5];
Segment(5).rM = [Marker.R_SAA,Marker.R_SRS,Marker.R_SIA,Marker.R_SAJ];

% =========================================================================
% Humerus parameters
% =========================================================================
% Elbow joint centre (Dumas and Wojtusch 2018)
Vmarker.R_EJC = (Marker.R_HLE+Marker.R_HME)/2;
% Humerus axes (Dumas and Wojtusch 2018)
Y4 = Vnorm_array3(Vmarker.R_GHJC-Vmarker.R_EJC);
X4 = Vnorm_array3(cross(Marker.R_HLE-Vmarker.R_GHJC,Marker.R_HME-Vmarker.R_GHJC));
Z4 = Vnorm_array3(cross(X4,Y4));
% Humerus parameters (Dumas and Chèze 2007)
rP4 = Vmarker.R_GHJC;
rD4 = Vmarker.R_EJC;
w4 = Z4;
u4 = X4;
Segment(4).Q = [u4;rP4;rD4;w4];
Segment(4).rM = [Vmarker.R_GHJC,Marker.R_HME,Marker.R_HLE];

% =========================================================================
% Radius/Ulna parameters
% =========================================================================
% Wrist joint centre (Dumas and Wojtusch 2018)
Vmarker.R_WJC = (Marker.R_UHE+Marker.R_RSP)/2;
% Radius/Ulna axes (Dumas and Wojtusch 2018)
Y3 = Vnorm_array3(Vmarker.R_EJC-Vmarker.R_WJC);
X3 = Vnorm_array3(cross(Marker.R_RSP-Vmarker.R_EJC,Marker.R_UHE-Vmarker.R_EJC));
Z3 = Vnorm_array3(cross(X3,Y3));
% Radius/Ulna parameters (Dumas and Chèze 2007)
rP3 = Vmarker.R_EJC;
rD3 = Vmarker.R_WJC;
w3 = Z3;
u3 = X3;
Segment(3).Q = [u3;rP3;rD3;w3];
Segment(3).rM = [Vmarker.R_EJC,Marker.R_UHE,Marker.R_RSP];

% =========================================================================
% Hand parameters
% =========================================================================
% Metacarpal joint centre (Dumas and Wojtusch 2018)
Vmarker.R_MCJC = (Marker.R_HM2+Marker.R_HM5)/2;
% Hand axes (Dumas and Wojtusch 2018)
Y2 = Vnorm_array3(Vmarker.R_WJC-Vmarker.R_MCJC);
X2 = Vnorm_array3(cross(Marker.R_HM2-Vmarker.R_WJC,Marker.R_HM5-Vmarker.R_WJC));
Z2 = Vnorm_array3(cross(X2,Y2));
% Hand parameters (Dumas and Chèze 2007)
rP2 = Vmarker.R_WJC;
rD2 = Vmarker.R_MCJC;
w2 = Z2;
u2 = X2;
Segment(2).Q = [u2;rP2;rD2;w2];
Segment(2).rM = [Vmarker.R_WJC,Marker.R_HM2,Marker.R_HM5];