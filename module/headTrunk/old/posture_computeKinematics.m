% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    posture_computeKinematics
% -------------------------------------------------------------------------
% Subject:      Perform inverse kinematics
% -------------------------------------------------------------------------
% Inputs:       - Segment (structure)
%               - n (int)
% Outputs:      - Kinematics (structure)
%               - Joint (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 04/01/2016
% Version: 3
% =========================================================================

function [Kinematics,Joint] = posture_computeKinematics(Segment,n)

% =========================================================================
% Kinematic chain:
% -------------------------------------------------------------------------
% Pelvis = 5
% Abdomen/lumbosacral = 4
% Thorax/thoracolumbar = 3
% Head/cervicothoracic = 2
% =========================================================================

% =========================================================================
% Initialisation
% =========================================================================
Kinematics.Aobli = [];
Kinematics.Arota = [];
Kinematics.Atilt = [];
Kinematics.Tobli = [];
Kinematics.Trota = [];
Kinematics.Ttilt = [];
Kinematics.Hobli = [];
Kinematics.Hrota = [];
Kinematics.Htilt = [];
Kinematics.FE2 = [];
Kinematics.AA2 = [];
Kinematics.IER2 = [];
Kinematics.LM2 = [];
Kinematics.AP2 = [];
Kinematics.PD2 = [];
Kinematics.FE3 = [];
Kinematics.AA3 = [];
Kinematics.IER3 = [];
Kinematics.LM3 = [];
Kinematics.AP3 = [];
Kinematics.PD3 = [];
Kinematics.FE4 = [];
Kinematics.AA4 = [];
Kinematics.IER4 = [];
Kinematics.LM4 = [];
Kinematics.AP4 = [];
Kinematics.PD4 = [];

% =========================================================================
% Segment angles and displacements
% =========================================================================
for i = 2:4
    % ZXY sequence of mobile axis
    % Transformation from the proximal to the distal SCS
    % Proximal SCS: origin at endpoint D and Z=w and  Y=(w×u)/||w×u||
    % Distal SCS: origin at endpoint P and X=u and Z=(u×v)/||u×v||  
    Joint(i).T = Mprod_array3(Tinv_array3(Q2Twu_array3(Segment(i+1).Q)),...
        Q2Tuv_array3(Segment(i).Q));

    % Euler angles
    Joint(i).Euler = R2mobileZXY_array3(Joint(i).T(1:3,1:3,:));
    % Joint displacement about the Euler angle axes
    Joint(i).dj = Vnop_array3(...
        Joint(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
        repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
        Vnorm_array3(cross(Joint(i).T(1:3,2,:),repmat([0;0;1],[1 1 n]))),... X = YxZ
        Joint(i).T(1:3,2,:)); % Yi in SCS of segment i
end
% Head orientation
Head.T = Q2Tuv_array3(Segment(2).Q);
Head.Euler = R2fixedZYX_array3(Head.T(1:3,1:3,:));
% Thorax orientation
Thorax.T = Q2Tuv_array3(Segment(3).Q);
Thorax.Euler = R2fixedZYX_array3(Thorax.T(1:3,1:3,:));
% Abdomen orientation
Abdomen.T = Q2Tuv_array3(Segment(4).Q);
Abdomen.Euler = R2fixedZYX_array3(Abdomen.T(1:3,1:3,:));

% =========================================================================
% Export kinematics parameters
% =========================================================================
k = (1:n)';
ko = (linspace(1,n,101))';
% Abdomen orientation
Kinematics.Atilt = interp1(k,permute(Abdomen.Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Arota = interp1(k,permute(Abdomen.Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Aobli = interp1(k,permute(Abdomen.Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
% Thorax orientation
Kinematics.Ttilt = interp1(k,permute(Thorax.Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Trota = interp1(k,permute(Thorax.Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Tobli = interp1(k,permute(Thorax.Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
% Head orientation
Kinematics.Htilt = interp1(k,permute(Head.Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Hrota = interp1(k,permute(Head.Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Hobli = interp1(k,permute(Head.Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
% Cervico-thoracic joint angles and displacements
Kinematics.FE2 = interp1(k,permute(Joint(2).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER2 = interp1(k,permute(Joint(2).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA2 = interp1(k,permute(Joint(2).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM2 = interp1(k,permute(Joint(2).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.PD2 = interp1(k,permute(Joint(2).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.AP2 = interp1(k,permute(Joint(2).dj(3,1,:),[3,2,1]),ko,'spline');
% Thoraco-lumbar joint angles and displacements
Kinematics.FE3 = interp1(k,permute(Joint(3).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER3 = interp1(k,permute(Joint(3).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA3 = interp1(k,permute(Joint(3).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM3 = interp1(k,permute(Joint(3).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.PD3 = interp1(k,permute(Joint(3).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.AP3 = interp1(k,permute(Joint(3).dj(3,1,:),[3,2,1]),ko,'spline');
% Lumbo-sacral joint angles and displacements
Kinematics.FE4 = interp1(k,permute(Joint(4).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER4 = interp1(k,permute(Joint(4).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA4 = interp1(k,permute(Joint(4).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM4 = interp1(k,permute(Joint(4).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.PD4 = interp1(k,permute(Joint(4).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.AP4 = interp1(k,permute(Joint(4).dj(3,1,:),[3,2,1]),ko,'spline');