% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeJointKinematics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Joint,btk2] = computeJointKinematics_lowerLimb(Segment,btk2)

Joint = Joint_Kinematics_2legs(Segment);

% =========================================================================
% RIGHT ANKLE
% =========================================================================
Joint(2).FE = Joint(2).Euler(1,1,:)*180/pi;
Joint(2).IER = Joint(2).Euler(1,2,:)*180/pi;
if max(abs(Joint(2).Euler(1,3,:)*180/pi)) > 150
    Joint(2).AA = -mod(Joint(2).Euler(1,3,:),2*pi)*180/pi;
else
    Joint(2).AA = -Joint(2).Euler(1,3,:)*180/pi;
end
Joint(2).LM = Joint(2).dj(1,1,:);
Joint(2).PD = Joint(2).dj(2,1,:);
Joint(2).AP = Joint(2).dj(1,1,:);
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(2).FE,[3,2,1]) ...
    permute(Joint(2).AA,[3,2,1]) ...
    permute(Joint(2).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Ankle_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% RIGHT KNEE
% =========================================================================
Joint(3).FE = Joint(3).Euler(1,1,:)*180/pi;
Joint(3).AA = Joint(3).Euler(1,2,:)*180/pi;
Joint(3).IER = Joint(3).Euler(1,3,:)*180/pi;
Joint(3).LM = Joint(3).dj(1,1,:);
Joint(3).AP = Joint(3).dj(2,1,:);
Joint(3).PD = Joint(3).dj(1,1,:);
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(3).FE,[3,2,1]) ...
    permute(-Joint(3).AA,[3,2,1]) ...
    permute(Joint(3).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Knee_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% RIGHT HIP
% =========================================================================
Joint(4).FE = Joint(4).Euler(1,1,:)*180/pi;
Joint(4).AA = Joint(4).Euler(1,2,:)*180/pi;
Joint(4).IER = Joint(4).Euler(1,3,:)*180/pi;
Joint(4).LM = Joint(4).dj(1,1,:);
Joint(4).AP = Joint(4).dj(2,1,:);
Joint(4).PD = Joint(4).dj(1,1,:);
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(4).FE,[3,2,1]) ...
    permute(Joint(4).AA,[3,2,1]) ...
    permute(Joint(4).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Hip_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT ANKLE
% =========================================================================
Joint(102).FE = Joint(102).Euler(1,1,:)*180/pi;
Joint(102).IER = Joint(102).Euler(1,2,:)*180/pi;
if max(abs(Joint(102).Euler(1,3,:)*180/pi)) > 150
    Joint(102).AA = mod(Joint(102).Euler(1,3,:),2*pi)*180/pi-180;
else
    Joint(102).AA = Joint(102).Euler(1,3,:)*180/pi-180;
end
Joint(102).LM = Joint(102).dj(1,1,:);
Joint(102).PD = Joint(102).dj(2,1,:);
Joint(102).AP = Joint(102).dj(1,1,:);
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(102).FE,[3,2,1]) ...
    permute(Joint(102).AA,[3,2,1]) ...
    permute(Joint(102).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Ankle_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: DF(+)/PF, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT KNEE
% =========================================================================
Joint(103).FE = Joint(103).Euler(1,1,:)*180/pi;
Joint(103).AA = Joint(103).Euler(1,2,:)*180/pi;
Joint(103).IER = Joint(103).Euler(1,3,:)*180/pi;
Joint(103).LM = Joint(103).dj(1,1,:);
Joint(103).AP = Joint(103).dj(2,1,:);
Joint(103).PD = Joint(103).dj(1,1,:);
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(103).FE,[3,2,1]) ...
    permute(-Joint(103).AA,[3,2,1]) ...
    permute(Joint(103).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Knee_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');

% =========================================================================
% LEFT HIP
% =========================================================================
Joint(104).FE = Joint(104).Euler(1,1,:)*180/pi;
Joint(104).AA = Joint(104).Euler(1,2,:)*180/pi;
Joint(104).IER = Joint(104).Euler(1,3,:)*180/pi;
Joint(104).LM = Joint(104).dj(1,1,:);
Joint(104).AP = Joint(104).dj(2,1,:);
Joint(104).PD = Joint(104).dj(1,1,:);
% Export marker in C3D file
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'angle');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(104).FE,[3,2,1]) ...
    permute(Joint(104).AA,[3,2,1]) ...
    permute(Joint(104).IER,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Hip_Angle');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Angle (Deg): X-Axis: F(+)/E, Y-Axis: Ad(+)/Ab, Z-Axis: IR(+)/ER');