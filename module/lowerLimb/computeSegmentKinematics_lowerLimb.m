% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeSegmentKinematics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,btk2] = computeSegmentKinematics_lowerLimb(Segment,btk2)

% =========================================================================
% PELVIS
% =========================================================================
T = Q2Tuv_array3(Segment(5).Q);
Rotation = R2fixedYXZ_array3(T(1:3,1:3,:)); % (Wren and Mitiguy 2007)
Translation = T(1:3,4,:);
if Segment(5).Q(4,:,end) > Segment(5).Q(4,:,1)
    Segment(5).FE = Rotation(1,3,:)*180/pi;
    Segment(5).AA = Rotation(1,2,:)*180/pi;
elseif Segment(5).Q(4,:,end) < Segment(5).Q(4,:,1)
    Segment(5).FE = -Rotation(1,3,:)*180/pi;
    Segment(5).AA = -Rotation(1,2,:)*180/pi;
end
if max(abs(Rotation(1,1,:)*180/pi)) > 150
    Segment(5).IER = (mod(Rotation(1,1,:),2*pi)-pi)*180/pi;
else
    Segment(5).IER = Rotation(1,1,:)*180/pi;
end
Segment(5).LM = Translation(3,1,:);
Segment(5).AP = Translation(1,1,:);
Segment(5).PD = Translation(2,1,:);
clear T Rotation Translation;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(5).FE,[3,2,1]) ...
    permute(Segment(5).AA,[3,2,1]) ...
    permute(Segment(5).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'Pelvis_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Oup(+)/Odw, Z-Axis: IR(+)/ER');

% =========================================================================
% RIGHT FOOT
% =========================================================================
T = Q2Tw_array3(Segment(2).Q);
Rotation = R2fixedZYX_array3(T(1:3,1:3,:));
Translation = T(1:3,4,:);
if Segment(5).Q(4,:,end) > Segment(5).Q(4,:,1)
    if max(Rotation(1,1,:)*180/pi) > 150
        Segment(2).FE = (mod(Rotation(1,1,:),2*pi)-pi)*180/pi;
    else
        Segment(2).FE = Rotation(1,1,:)*180/pi;
    end
    Segment(2).IER = Rotation(1,2,:)*180/pi;
    if max(Rotation(1,3,:)*180/pi) > 100
        Segment(2).AA = -(mod(Rotation(1,3,:),2*pi)-pi)*180/pi;
    else
        Segment(2).AA = -Rotation(1,3,:)*180/pi;
    end
elseif Segment(5).Q(4,:,end) < Segment(5).Q(4,:,1)
    if max(Rotation(1,1,:)*180/pi) > 150
        Segment(2).FE = (mod(Rotation(1,1,:),2*pi)-pi)*180/pi;
    else
        Segment(2).FE = Rotation(1,1,:)*180/pi;
    end
    Segment(2).IER = -Rotation(1,2,:)*180/pi;
    if max(Rotation(1,3,:)*180/pi) > 150
        Segment(2).AA = (mod(Rotation(1,3,:),2*pi)-pi)*180/pi;
    else
        Segment(2).AA = Rotation(1,3,:)*180/pi;
    end
end
clear T Rotation Translation;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(2).FE,[3,2,1]) ...
    permute(-Segment(2).IER,[3,2,1]) ...
    permute(Segment(2).AA,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Foot_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Val(+)/Var, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT FOOT
% =========================================================================
T = Q2Tw_array3(Segment(102).Q);
Rotation = R2fixedZYX_array3(T(1:3,1:3,:));
Translation = T(1:3,4,:);
if Segment(5).Q(4,:,end) > Segment(5).Q(4,:,1)
    if max(Rotation(1,1,:)*180/pi) > 150
        Segment(102).FE = (mod(Rotation(1,1,:),2*pi)-pi)*180/pi;
    else
        Segment(102).FE = Rotation(1,1,:)*180/pi;
    end
    Segment(102).IER = Rotation(1,2,:)*180/pi;
    if max(Rotation(1,3,:)*180/pi) > 100
        Segment(102).AA = -(mod(Rotation(1,3,:),2*pi)-pi)*180/pi;
    else
        Segment(102).AA = -Rotation(1,3,:)*180/pi;
    end
elseif Segment(5).Q(4,:,end) < Segment(5).Q(4,:,1)
    if max(Rotation(1,1,:)*180/pi) > 150
        Segment(102).FE = (mod(Rotation(1,1,:),2*pi)-pi)*180/pi;
    else
        Segment(102).FE = Rotation(1,1,:)*180/pi;
    end
    Segment(102).IER = -Rotation(1,2,:)*180/pi;  
    if max(Rotation(1,3,:)*180/pi) > 150
        Segment(102).AA = (mod(Rotation(1,3,:),2*pi)-pi)*180/pi;
    else
        Segment(102).AA = Rotation(1,3,:)*180/pi;
    end
end
clear T Rotation Translation;
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Segment(102).FE,[3,2,1]) ...
    permute(Segment(102).IER,[3,2,1]) ...
    permute(-Segment(102).AA,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Foot_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: Tup(+)/Tdw, Y-Axis: Val(+)/Var, Z-Axis: IR(+)/ER');