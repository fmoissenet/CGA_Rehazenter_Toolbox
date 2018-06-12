% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    upperLimb_computeKinematics
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

function [Kinematics,Joint] = upperLimb_computeKinematics(Segment,n)

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
% Initialisation
% =========================================================================
Kinematics.Tobli = [];
Kinematics.Trota = [];
Kinematics.Ttilt = [];
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
% Segment/joint angles and displacements
% =========================================================================
% Wrist joint
% -------------------------------------------------------------------------
% Transformation from the proximal to the distal SCS
% Proximal SCS: origin at endpoint D and Z=w and Y=(w×u)/||w×u||
% Distal SCS: origin at endpoint P and X=u and Y =(w×u)/||w×u||  
i = 2;
Joint(i).T = Mprod_array3(Tinv_array3(Q2Twu_array3(Segment(i+1).Q)),...
    Q2Tuw_array3(Segment(i).Q));
% Euler angles
% ZYX sequence of mobile axis (JCS system for wrist)
% Wrist interal-external rotation on floating axis
Joint(i).Euler = R2mobileZYX_array3(Joint(i).T(1:3,1:3,:));
% Joint displacement about the Euler angle axes
Joint(i).dj = Vnop_array3(...
    Joint(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
    repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
    Vnorm_array3(cross(repmat([0;0;1],[1 1 n]),Joint(i).T(1:3,1,:))),... Y = ZxX
    Joint(i).T(1:3,1,:)); % Xi in SCS of segment i
        
% Elbow joint
% -------------------------------------------------------------------------
% Transformation from the proximal to the distal SCS
% Proximal SCS: origin at endpoint D and Z=w and Y=(w×u)/||w×u||
% Distal SCS: origin at endpoint P and X=u and Z=(u×v)/||u×v||  
i = 3;
Joint(i).T = Mprod_array3(Tinv_array3(Q2Twu_array3(Segment(i+1).Q)),...
    Q2Tuv_array3(Segment(i).Q));
% Euler angles
% ZXY sequence of mobile axis
Joint(i).Euler = R2mobileZXY_array3(Joint(i).T(1:3,1:3,:));
% Joint displacement about the Euler angle axes
Joint(i).dj = Vnop_array3(...
    Joint(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
    repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
    Vnorm_array3(cross(Joint(i).T(1:3,2,:),repmat([0;0;1],[1 1 n]))),... X = YxZ
    Joint(i).T(1:3,2,:)); % Yi in SCS of segment i
       
% Glenohumeral joint
% -------------------------------------------------------------------------
% Transformation from the proximal segment axes (with origin at endpoint D 
% and with Z=w) to the distal segment axes (with origin at point P and with
% X=u)
i = 4;
Joint(i).T = Mprod_array3(Tinv_array3(Q2Twu_array3(Segment(i+1).Q)),...
    Q2Tuv_array3(Segment(i).Q));
% Euler angles
% XZY sequence of mobile axis in case of abduction movement
Joint(i).Euler = R2mobileXZY_array3(Joint(i).T(1:3,1:3,:));
% Joint displacement about the Euler angle axes
Joint(i).dj = Vnop_array3(...
    Joint(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
    repmat([1;0;0],[1 1 n]),... % Xi+1 in SCS of segment i+1
    Vnorm_array3(cross(repmat([1;0;0],[1 1 n]),Joint(i).T(1:3,2,:))),...
    Joint(i).T(1:3,2,:)); % Yi in SCS of segment i

% Scapulothoracic joint
% -------------------------------------------------------------------------
% Transformation from the proximal segment axes (with origin at endpoint P 
% and with X=u) to the distal segment axes (with origin at point D and with
% Z=w)
i = 5;
Joint(i).T = Mprod_array3(Tinv_array3(Q2Tuv_array3(Segment(i+1).Q)),...
    Q2Twu_array3(Segment(i).Q));
% Euler angles
% YXZ sequence of mobile axis
Joint(i).Euler = R2mobileYXZ_array3(Joint(i).T(1:3,1:3,:));

% Thorax segment
% -------------------------------------------------------------------------
i = 6;
Segment(i).T = Q2Tuv_array3(Segment(i).Q);
% Euler angles
% ZYX sequence of fixed axis
Segment(i).Euler = R2fixedZYX_array3(Segment(i).T(1:3,1:3,:));

% =========================================================================
% Export kinematics parameters
% =========================================================================
k = (1:n)';
ko = (linspace(1,n,101))';
% Thorax orientation
Kinematics.THtilt = interp1(k,permute(Segment(6).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.THrota = interp1(k,permute(Segment(6).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.THobli = interp1(k,permute(Segment(6).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
% Wrist joint angles and displacements
Kinematics.FE2 = interp1(k,permute(Joint(2).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA2 = interp1(k,permute(Joint(2).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER2 = interp1(k,permute(Joint(2).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM2 = interp1(k,permute(Joint(2).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.PD2 = interp1(k,permute(Joint(2).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.AP2 = interp1(k,permute(Joint(2).dj(3,1,:),[3,2,1]),ko,'spline');
% Elbow joint angles and displacements
Kinematics.FE3 = interp1(k,permute(Joint(3).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA3 = interp1(k,permute(Joint(3).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER3 = interp1(k,permute(Joint(3).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM3 = interp1(k,permute(Joint(3).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.AP3 = interp1(k,permute(Joint(3).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.PD3 = interp1(k,permute(Joint(3).dj(3,1,:),[3,2,1]),ko,'spline'); 
% Glenohumeral joint angles and displacements
Kinematics.FE4 = interp1(k,permute(Joint(4).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA4 = interp1(k,permute(Joint(4).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER4 = interp1(k,permute(Joint(4).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM4 = interp1(k,permute(Joint(4).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.AP4 = interp1(k,permute(Joint(4).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.PD4 = interp1(k,permute(Joint(4).dj(3,1,:),[3,2,1]),ko,'spline'); 
% Scapulothoracic joint angles and displacements
Kinematics.FE5 = interp1(k,permute(Joint(5).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA5 = interp1(k,permute(Joint(5).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER5 = interp1(k,permute(Joint(5).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');