% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    setLegLength
% -------------------------------------------------------------------------
% Subject:      Compute leg length
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function Session = setLegLength_lowerLimb(Session,Marker)

% =========================================================================
% Right
% =========================================================================
x1 = Marker.R_FTC(1,1);
y1 = Marker.R_FTC(2,1);
z1 = Marker.R_FTC(3,1);
x2 = Marker.R_FLE(1,1);
y2 = Marker.R_FLE(2,1);
z2 = Marker.R_FLE(3,1);
x3 = Marker.R_FAL(1,1);
y3 = Marker.R_FAL(2,1);
z3 = Marker.R_FAL(3,1);
Session.R_legLength = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2) + ...
    sqrt((x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2);

% =========================================================================
% Left
% =========================================================================
clear x1 x2 x3 y1 y2 y2 z1 z2 z3
x1 = Marker.L_FTC(1,1);
y1 = Marker.L_FTC(2,1);
z1 = Marker.L_FTC(3,1);
x2 = Marker.L_FLE(1,1);
y2 = Marker.L_FLE(2,1);
z2 = Marker.L_FLE(3,1);
x3 = Marker.L_FAL(1,1);
y3 = Marker.L_FAL(2,1);
z3 = Marker.L_FAL(3,1);
Session.L_legLength = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2) + ...
    sqrt((x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2);