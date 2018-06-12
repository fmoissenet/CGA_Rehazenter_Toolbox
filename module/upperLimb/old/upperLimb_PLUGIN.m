% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    upperLimb_PLUGIN
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

function Condition = upperLimb_PLUGIN(Patient,Session,Condition)

% =========================================================================
% Static
% =========================================================================
% Load static files
disp('    - UpperLimb: Static');
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
    Rmarker = upperLimb_importStaticMarker(static,n,'Right',Session.system,Session.msup);
    Lmarker = upperLimb_importStaticMarker(static,n,'Left',Session.system,Session.msup);
    % Define segments parameters
    [Rstatic,Rmarker,Rvmarker] = upperLimb_setStaticSegment(...
        Patient,Rmarker);
    [Lstatic,Lmarker,Lvmarker] = upperLimb_setStaticSegment(...
        Patient,Lmarker);
%     % Plot static
%     upperLimb_plotStatic(Rmarker,Rvmarker);
%     upperLimb_plotStatic(Lmarker,Lvmarker);
end

% =========================================================================
% Trials
% =========================================================================
k = 1; % Index of the trial of the condition
for j = 1:length(Session.Gait)    
    if strcmp(Session.Gait(j).condition,Condition.name)  
        if strcmp(Session.Gait(j).msup,'yes')
            disp(['    - UpperLimb: Gait',num2str(j),' = ',char(Session.Gait(j).filename)]);
            % Import trial data
            trial = Session.Gait(j).file;
            n0 = btkGetFirstFrame(trial);
            n1 = btkGetLastFrame(trial)-n0+1;
            Rmarker = upperLimb_importCycleMarker(trial,n1,Session.fpoint,'Right',Session.system,Session.msup);
            Lmarker = upperLimb_importCycleMarker(trial,n1,Session.fpoint,'Left',Session.system,Session.msup);
            if ~isfield(Rmarker,'CV7')
                break;
            end
            % Extract the gait cycle from the trial
            [Rmarker,nR] = upperLimb_cutCycleData(Condition,Rmarker,'Right',k);
            [Lmarker,nL] = upperLimb_cutCycleData(Condition,Lmarker,'Left',k);
            % Define segments parameters
            [Rsegment,Rmarker,Rvmarker] = upperLimb_setCycleSegment(...
                Patient,Rmarker,Rvmarker,nR);
            [Lsegment,Lmarker,Lvmarker] = upperLimb_setCycleSegment(...
                Patient,Lmarker,Lvmarker,nL);
            %         % Plot cycle
            %         upperLimb_plotCycle(Rmarker,Rvmarker,nR)
            %         upperLimb_plotCycle(Lmarker,Lvmarker,nL)
            % Inverse kinematics
            [Rkinematics,Rjoint] = upperLimb_computeKinematics(Rsegment,nR);
            [Lkinematics,Ljoint] = upperLimb_computeKinematics(Lsegment,nL);
            % Store process data
            Condition.Gait(k).Treatment.Rmarkerupper = Rmarker;
            Condition.Gait(k).Treatment.Rvmarkerupper = Rvmarker;
            Condition.Gait(k).Treatment.Rstaticupper = Rstatic;
            Condition.Gait(k).Treatment.Rsegmentupper = Rsegment;
            Condition.Gait(k).Treatment.Lmarkerupper = Lmarker;
            Condition.Gait(k).Treatment.Lvmarkerupper = Lvmarker;
            Condition.Gait(k).Treatment.Lstaticupper = Lstatic;
            Condition.Gait(k).Treatment.Lsegmentupper = Lsegment;
            Condition.Gait(k).Rkinematicsupper = Rkinematics;
            Condition.Gait(k).Lkinematicsupper = Lkinematics;
            k = k+1;
%             end
        end
    end    
end