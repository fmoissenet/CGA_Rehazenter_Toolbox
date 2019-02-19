% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportCondition_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Export .mat file for each condition with only intra cycle
%               data of each outcome
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function Output = exportCondition_lowerLimb(Output,Segment,Joint,Marker,Vmarker,EMG,Event,Spatiotemporal,fMarker)

% =========================================================================
% Initialisation
% =========================================================================
% Set outputs
Output.Spatiotemporal = [];
Output.Jointkinematics = [];
Output.Segmentkinematics = [];
Output.Dynamics = [];
Output.EMG = [];
Output.Events = [];
% Express events as % of gait cycle
Event.RHS = fix(Event.RHS*fMarker);
Event.RTO = fix(Event.RTO*fMarker);
Event.LHS = fix(Event.LHS*fMarker);
Event.LTO = fix(Event.LTO*fMarker);
% Interpolation parameters
R_n = Event.RHS(2)-Event.RHS(1)+1;
R_k = (1:R_n)';
R_ko = (linspace(1,R_n,101))';
L_n = Event.LHS(2)-Event.LHS(1)+1;
L_k = (1:L_n)';
L_ko = (linspace(1,L_n,101))';

% =========================================================================
% Spatiotemporal
% =========================================================================
nSpatiotemporal = fieldnames(Spatiotemporal);
for i = 1:size(nSpatiotemporal,1)
    Output.Spatiotemporal.(nSpatiotemporal{i}) = Spatiotemporal.(nSpatiotemporal{i});
end

% =========================================================================
% Joint kinematics
% =========================================================================
% Right gait cycle
Output.Jointkinematics.R_Ankle_Angle_FE = interp1(R_k,...
    permute(Joint(2).FE(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Ankle_Angle_AA = interp1(R_k,...
    permute(Joint(2).AA(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Ankle_Angle_IER = interp1(R_k,...
    permute(Joint(2).IER(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Knee_Angle_FE = interp1(R_k,...
    permute(Joint(3).FE(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Knee_Angle_AA = interp1(R_k,...
    permute(Joint(3).AA(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Knee_Angle_IER = interp1(R_k,...
    permute(Joint(3).IER(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Hip_Angle_FE = interp1(R_k,...
    permute(Joint(4).FE(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Hip_Angle_AA = interp1(R_k,...
    permute(Joint(4).AA(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Jointkinematics.R_Hip_Angle_IER = interp1(R_k,...
    permute(Joint(4).IER(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
% Left gait cycle
Output.Jointkinematics.L_Ankle_Angle_FE = interp1(L_k,...
    permute(Joint(102).FE(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Ankle_Angle_AA = interp1(L_k,...
    permute(Joint(102).AA(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Ankle_Angle_IER = interp1(L_k,...
    permute(Joint(102).IER(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Knee_Angle_FE = interp1(L_k,...
    permute(Joint(103).FE(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Knee_Angle_AA = interp1(L_k,...
    permute(Joint(103).AA(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Knee_Angle_IER = interp1(L_k,...
    permute(Joint(103).IER(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Hip_Angle_FE = interp1(L_k,...
    permute(Joint(104).FE(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Hip_Angle_AA = interp1(L_k,...
    permute(Joint(104).AA(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Jointkinematics.L_Hip_Angle_IER = interp1(L_k,...
    permute(Joint(104).IER(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');

% =========================================================================
% Segment kinematics
% =========================================================================
% Right gait cycle
Output.Segmentkinematics.R_Foot_Angle_FE = interp1(R_k,...
    permute(Segment(2).FE(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Foot_Angle_AA = interp1(R_k,...
    permute(Segment(2).AA(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Foot_Angle_IER = interp1(R_k,...
    permute(Segment(2).IER(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Pelvis_Angle_FE = interp1(R_k,...
    permute(Segment(5).FE(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Pelvis_Angle_AA = interp1(R_k,...
    permute(Segment(5).AA(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Segmentkinematics.R_Pelvis_Angle_IER = interp1(R_k,...
    permute(Segment(5).IER(1,1,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
% Left gait cycle
Output.Segmentkinematics.L_Foot_Angle_FE = interp1(L_k,...
    permute(Segment(102).FE(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Foot_Angle_AA = interp1(L_k,...
    permute(Segment(102).AA(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Foot_Angle_IER = interp1(L_k,...
    permute(Segment(102).IER(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Pelvis_Angle_FE = interp1(L_k,...
    permute(Segment(5).FE(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Pelvis_Angle_AA = interp1(L_k,...
    permute(Segment(5).AA(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Segmentkinematics.L_Pelvis_Angle_IER = interp1(L_k,...
    permute(Segment(5).IER(1,1,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');

% =========================================================================
% Dynamics
% =========================================================================
% Right gait cycle
Output.Dynamics.R_Ankle_Moment_FE = interp1(R_k,...
    permute(Joint(2).Mj(1,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Ankle_Moment_AA = interp1(R_k,...
    permute(Joint(2).Mj(3,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Ankle_Moment_IER = interp1(R_k,...
    permute(Joint(2).Mj(2,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Knee_Moment_FE = interp1(R_k,...
    permute(Joint(3).Mj(1,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Knee_Moment_AA = interp1(R_k,...
    permute(Joint(3).Mj(2,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Knee_Moment_IER = interp1(R_k,...
    permute(Joint(3).Mj(3,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Hip_Moment_FE = interp1(R_k,...
    permute(Joint(4).Mj(1,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Hip_Moment_AA = interp1(R_k,...
    permute(Joint(4).Mj(2,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
Output.Dynamics.R_Hip_Moment_IER = interp1(R_k,...
    permute(Joint(4).Mj(3,:,Event.RHS(1):Event.RHS(2)),[3,1,2]),R_ko,'spline');
% Left gait cycle
Output.Dynamics.L_Ankle_Moment_FE = interp1(L_k,...
    permute(Joint(102).Mj(1,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Ankle_Moment_AA = interp1(L_k,...
    permute(Joint(102).Mj(3,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Ankle_Moment_IER = interp1(L_k,...
    permute(Joint(102).Mj(2,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Knee_Moment_FE = interp1(L_k,...
    permute(Joint(103).Mj(1,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Knee_Moment_AA = interp1(L_k,...
    permute(Joint(103).Mj(2,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Knee_Moment_IER = interp1(L_k,...
    permute(Joint(103).Mj(3,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Hip_Moment_FE = interp1(L_k,...
    permute(Joint(104).Mj(1,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Hip_Moment_AA = interp1(L_k,...
    permute(Joint(104).Mj(2,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');
Output.Dynamics.L_Hip_Moment_IER = interp1(L_k,...
    permute(Joint(104).Mj(3,:,Event.LHS(1):Event.LHS(2)),[3,1,2]),L_ko,'spline');

% -------------------------------------------------------------------------
% EMG
% -------------------------------------------------------------------------
nEMG = fieldnames(EMG);
for i = 1:size(nEMG,1)
    temp = EMG.(nEMG{i}).signal(:,:,Event.RHS(1):Event.RHS(2));
    if sum(isnan(temp)) ~= size(isnan(temp),1)
        Output.EMG.([nEMG{i},'_signal']) = permute(temp,[2,3,1]);
    else
        Output.EMG.([nEMG{i},'_signal']) = NaN(1,1,101);
    end    
    temp = EMG.(nEMG{i}).envelop(:,:,Event.RHS(1):Event.RHS(2));
    if sum(isnan(temp)) ~= size(isnan(temp),1)
        Output.EMG.([nEMG{i},'_envelop']) = interp1(R_k,permute(temp,[2,3,1]),R_ko,'spline');
    else
        Output.EMG.([nEMG{i},'_envelop']) = NaN(1,1,101);
    end
end

% -------------------------------------------------------------------------
% Event
% -------------------------------------------------------------------------
Output.Event.RHS = (Event.RHS-Event.RHS(1)+1)*100/(Event.RHS(2)-Event.RHS(1)+1);
Output.Event.RTO = (Event.RTO-Event.RHS(1)+1)*100/(Event.RHS(2)-Event.RHS(1)+1);
Output.Event.LHS = (Event.LHS-Event.RHS(1)+1)*100/(Event.RHS(2)-Event.RHS(1)+1);
Output.Event.LTO = (Event.LTO-Event.RHS(1)+1)*100/(Event.RHS(2)-Event.RHS(1)+1);

% -------------------------------------------------------------------------
% Event
% -------------------------------------------------------------------------
Output.Lstride.Event.RHS = (Event.RHS-Event.LHS(1)+1)*100/(Event.LHS(2)-Event.LHS(1)+1);
Output.Lstride.Event.RTO = (Event.RTO-Event.LHS(1)+1)*100/(Event.LHS(2)-Event.LHS(1)+1);
Output.Lstride.Event.LHS = (Event.LHS-Event.LHS(1)+1)*100/(Event.LHS(2)-Event.LHS(1)+1);
Output.Lstride.Event.LTO = (Event.LTO-Event.LHS(1)+1)*100/(Event.LHS(2)-Event.LHS(1)+1);