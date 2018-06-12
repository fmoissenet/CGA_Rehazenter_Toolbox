% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:     posture_PLUGIN
% -------------------------------------------------------------------------
% Subject:      Compute upper limb kinematics
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - Condition (structure)
% Outputs:      - Condition (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 30/11/2016
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Condition = posture_PLUGIN(Patient,Session,Condition)

% =========================================================================
% Static
% =========================================================================
% Load static files
disp('    - Posture: Static');
for j = 1:length(Session.Static)
    if strcmp(Session.Static(j).condition,Condition.name) || ...
            strcmp(Session.Static(j).condition,'toutes conditions')
        static = Session.Static(j).file;
    end
end
if ~isempty(static)
    % Number of frames
    n = btkGetLastFrame(static)-btkGetFirstFrame(static)+1;
    % Import marker in a generic format
    Rmarker = posture_importStaticMarker(static,n,'Right',Session.system,Session.mpost);
    Lmarker = posture_importStaticMarker(static,n,'Left',Session.system,Session.mpost);
    % Define segments parameters
    [Rstatic,Rmarker,Rvmarker] = posture_setStaticSegment(...
        Patient,Rmarker);
    [Lstatic,Lmarker,Lvmarker] = posture_setStaticSegment(...
        Patient,Lmarker);
%     % Plot static
%     posture_plotStatic(Rmarker,Rvmarker);
%     posture_plotStatic(Lmarker,Lvmarker);
end

% =========================================================================
% Trials
% =========================================================================
k = 1; % Index of the trial of the condition
for j = 1:length(Session.Gait)    
    if strcmp(Session.Gait(j).condition,Condition.name)  
        if strcmp(Session.Gait(j).mpost,'yes')
%             if ~strcmp(Session.Gait(j).filename,'gait28.c3d') && ~strcmp(Session.Gait(j).filename,'gait29.c3d') && ~strcmp(Session.Gait(j).filename,'gait30.c3d')
            disp(['    - Posture: Gait',num2str(j),' = ',char(Session.Gait(j).filename)]);
            % Import trial data
            trial = Session.Gait(j).file;
            n0 = btkGetFirstFrame(trial);
            n1 = btkGetLastFrame(trial)-n0+1;
            Rmarker = posture_importCycleMarker(trial,n1,Session.fpoint,'Right',Session.system,Session.mpost);
            Lmarker = posture_importCycleMarker(trial,n1,Session.fpoint,'Left',Session.system,Session.mpost);
            if ~isfield(Rmarker,'CV7')
                break;
            end
            % Extract the gait cycle from the trial
            [Rmarker,nR] = posture_cutCycleData(Condition,Rmarker,'Right',k);
            [Lmarker,nL] = posture_cutCycleData(Condition,Lmarker,'Left',k);
            % Define segments parameters
            [Rsegment,Rmarker,Rvmarker] = posture_setCycleSegment(...
                Patient,Rstatic,Rmarker,Rvmarker,nR);
            [Lsegment,Lmarker,Lvmarker] = posture_setCycleSegment(...
                Patient,Lstatic,Lmarker,Lvmarker,nL);
            %         % Plot cycle
            %         posture_plotCycle(Rmarker,Rvmarker,nR)
            %         posture_plotCycle(Lmarker,Lvmarker,nL)
            % Inverse kinematics
            [Rkinematics,Rjoint] = posture_computeKinematics(Rsegment,nR);
            [Lkinematics,Ljoint] = posture_computeKinematics(Lsegment,nL);
            % Store process data
            Condition.Gait(k).Treatment.Rmarkerposture = Rmarker;
            Condition.Gait(k).Treatment.Rvmarkerposture = Rvmarker;
            Condition.Gait(k).Treatment.Rstaticposture = Rstatic;
            Condition.Gait(k).Treatment.Rsegmentposture = Rsegment;
            Condition.Gait(k).Treatment.Lmarkerposture = Lmarker;
            Condition.Gait(k).Treatment.Lvmarkerposture = Lvmarker;
            Condition.Gait(k).Treatment.Lstaticposture = Lstatic;
            Condition.Gait(k).Treatment.Lsegmentposture = Lsegment;
            Condition.Gait(k).Rkinematicsposture = Rkinematics;
            Condition.Gait(k).Lkinematicsposture = Lkinematics;
            k = k+1;
%             end
        end
    end    
end