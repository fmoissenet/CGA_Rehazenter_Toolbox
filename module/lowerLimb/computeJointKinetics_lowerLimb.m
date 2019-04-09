% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    computeJointKinetics_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Compute kinematics
% Plugin:       Lower limb
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Segment,Joint,btk2] = computeJointKinetics_lowerLimb(Session,Segment,Joint,f,btk2)

% =========================================================================
% Inverse dynamics
% =========================================================================
[Segment,Joint] = Joint_Kinetics_2legs(Segment,Joint,f);

% =========================================================================
% Export moment (normalised by weight) in C3D file
% =========================================================================
% Right ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(2).Mj(1,:,:)/Session.weight,[3,2,1]) ...
    permute(Joint(2).Mj(2,:,:)/Session.weight,[3,2,1]) ...
    permute(Joint(2).Mj(3,:,:)/Session.weight,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Ankle_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: PF(+)/DF, Y-Axis: IR(+)/ER, Z-Axis: Ad(+)/Ab');
% Right knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(3).Mj(1,:,:)/Session.weight,[3,2,1]) ...
    permute(-Joint(3).Mj(2,:,:)/Session.weight,[3,2,1]) ...
    permute(Joint(3).Mj(3,:,:)/Session.weight,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Knee_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Right hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(4).Mj(1,:,:)/Session.weight,[3,2,1]) ...
    permute(-Joint(4).Mj(2,:,:)/Session.weight,[3,2,1]) ...
    permute(Joint(4).Mj(3,:,:)/Session.weight,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Hip_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Left ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(102).Mj(1,:,:)/Session.weight,[3,2,1]) ...
    permute(-Joint(102).Mj(2,:,:)/Session.weight,[3,2,1]) ...
    permute(-Joint(102).Mj(3,:,:)/Session.weight,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Ankle_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: PF(+)/DF, Y-Axis: IR(+)/ER, Z-Axis: Ad(+)/Ab');
% Left knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(103).Mj(1,:,:)/Session.weight,[3,2,1]) ...
    permute(Joint(103).Mj(2,:,:)/Session.weight,[3,2,1]) ...
    permute(-Joint(103).Mj(3,:,:)/Session.weight,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Knee_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: Ext(+)/Flex, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');
% Left hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'moment');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(104).Mj(1,:,:)/Session.weight,[3,2,1]) ...
    permute(Joint(104).Mj(2,:,:)/Session.weight,[3,2,1]) ...
    permute(-Joint(104).Mj(3,:,:)/Session.weight,[3,2,1])]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Hip_Moment');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Moment (Nm/kg): X-Axis: E(+)/F, Y-Axis: Ab(+)/Ad, Z-Axis: IR(+)/ER');

% =========================================================================
% Joint power and alpha angle
% =========================================================================
n = size(Joint(1).F,3);
for j = 1:n
    % Right ankle
    M = permute(Joint(2).Mj(:,:,j),[3,1,2]);
    Omega = permute(Segment(3).Omega(:,:,j) - Segment(2).Omega(:,:,j),[3,1,2]); % in ICS
    Joint(2).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(2).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Right knee
    M = permute(Joint(3).Mj(:,:,j),[3,1,2]);
    Omega = permute(Segment(4).Omega(:,:,j) - Segment(3).Omega(:,:,j),[3,1,2]); % in ICS
    Joint(3).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(3).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Right hip
    M = permute(Joint(4).Mj(:,:,j),[3,1,2]);
    Omega = permute(Segment(5).Omega(:,:,j) - Segment(4).Omega(:,:,j),[3,1,2]); % in ICS
    Joint(4).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(4).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Left ankle
    M = permute(Joint(102).Mj(:,:,j),[3,1,2]);
    Omega = permute(Segment(103).Omega(:,:,j) - Segment(102).Omega(:,:,j),[3,1,2]); % in ICS
    Joint(102).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(102).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Left knee
    M = permute(Joint(103).Mj(:,:,j),[3,1,2]);
    Omega = permute(Segment(104).Omega(:,:,j) - Segment(103).Omega(:,:,j),[3,1,2]); % in ICS
    Joint(103).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(103).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
    % Left hip
    M = permute(Joint(104).Mj(:,:,j),[3,1,2]);
    Omega = permute(Segment(105).Omega(:,:,j) - Segment(104).Omega(:,:,j),[3,1,2]); % in ICS
    Joint(104).power(:,:,j) = dot(M,Omega); % 3D joint power
    Joint(104).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
end

% =========================================================================
% Export power (normalised by weight) in C3D file
% =========================================================================
% Right ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(2).power(:,:,:)/Session.weight,[3,2,1]) ...
    zeros(size(permute(Joint(2).power(:,:,:)/Session.weight,[3,2,1]))) ...
    zeros(size(permute(Joint(2).power(:,:,:)/Session.weight,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Ankle_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Right knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(3).power(:,:,:)/Session.weight,[3,2,1]) ...
    zeros(size(permute(Joint(3).power(:,:,:)/Session.weight,[3,2,1]))) ...
    zeros(size(permute(Joint(3).power(:,:,:)/Session.weight,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Knee_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Right hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(4).power(:,:,:)/Session.weight,[3,2,1]) ...
    zeros(size(permute(Joint(4).power(:,:,:)/Session.weight,[3,2,1]))) ...
    zeros(size(permute(Joint(4).power(:,:,:)/Session.weight,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'R_Hip_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Left ankle
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(102).power(:,:,:)/Session.weight,[3,2,1]) ...
    zeros(size(permute(Joint(102).power(:,:,:)/Session.weight,[3,2,1]))) ...
    zeros(size(permute(Joint(102).power(:,:,:)/Session.weight,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Ankle_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Left knee
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(Joint(103).power(:,:,:)/Session.weight,[3,2,1]) ...
    zeros(size(permute(Joint(103).power(:,:,:)/Session.weight,[3,2,1]))) ...
    zeros(size(permute(Joint(103).power(:,:,:)/Session.weight,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Knee_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');
% Left hip
btkSetPointNumber(btk2,btkGetPointNumber(btk2)+1);
btkSetPointType(btk2,btkGetPointNumber(btk2),'power');
btkSetPoint(btk2,btkGetPointNumber(btk2),[permute(-Joint(104).power(:,:,:)/Session.weight,[3,2,1]) ...
    zeros(size(permute(Joint(104).power(:,:,:)/Session.weight,[3,2,1]))) ...
    zeros(size(permute(Joint(104).power(:,:,:)/Session.weight,[3,2,1])))]);
btkSetPointLabel(btk2,btkGetPointNumber(btk2),'L_Hip_Power');
btkSetPointDescription(btk2,btkGetPointNumber(btk2),'Power (W/kg): Gen(+)/Abs');