% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    startCGA
% -------------------------------------------------------------------------
% Subject:      Import .c3d files (using the Biomechanical Toolkit - BTK) 
%               and compute biomechanical parameters of a clinical gait 
%               analysis session
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Patient,Pathology,Treatment,Examination,Session,Condition] = ...
    startCGA(toolboxFolder,c3dFolder,Module)

% =========================================================================
% Initialisation
% =========================================================================
cd(toolboxFolder);
disp('Loading selected modules ...');
names = fieldnames(Module);
for i = 1:length(names)
    if Module.(names{i}) == 1
        disp(['[MODULE ',names{i},']']);
    end
end
disp(' ');

% =========================================================================
% Initialise structures
% =========================================================================
Patient = [];
Pathology = [];
Examination = [];
Treatment = [];
Session = [];
Condition = [];

% =========================================================================
% Import session information
% =========================================================================
disp('>> Import session information ...');
[Patient,Pathology,Treatment,Examination,Session,Condition] = ...
    importSessionInformation(Patient,Pathology,Treatment,Examination,Session,Condition,c3dFolder);
disp(['  > Patient: ',Patient.lastname,' ',Patient.firstname,' ',Patient.birthdate]);
disp(['  > Session: ',Session.date]);
disp(' ');

% =========================================================================
% Load session files
% -------------------------------------------------------------------------
% The .c3d files names must be formatted to respect the names given by the
% .xlsx file (staticXX, videoXX, trialXX)
% =========================================================================
disp('>> Load session files ...');
cd(c3dFolder);
% Load static file (.c3d) - 1 static per condition
if isfield(Session,'Static')
    for i = 1:length(Session.Static)
        if ~isempty(Session.Static(i).filename)
            Session.Static(i).file = btkReadAcquisition(Session.Static(i).filename);
        end
    end
end
% Load trial files (.c3d) - for all conditions
for i = 1:length(Session.Trial)      
    if ~isempty(Session.Trial(i).filename)
        Session.Trial(i).file = btkReadAcquisition(Session.Trial(i).filename);
    end
end
cd(toolboxFolder);
disp(' ');

% =========================================================================
% Data treatment of each trial of each condition
% =========================================================================
disp(['>> ',num2str(length(Session.conditions)),' condition(s) detected ...']);  
for i = 1:length(Session.conditions)
    disp(['  > Condition ',Session.conditions{i}]);
    cd(toolboxFolder);
    
    % ---------------------------------------------------------------------
    % Static
    % ---------------------------------------------------------------------
    for j = 1:length(Session.Static)
        if strcmp(Session.Static(j).condition,Condition(i).name) || ...
                strcmp(Session.Static(j).condition,'toutes conditions')            
            disp(['    - Static',num2str(j),' = ',char(Session.Static(j).filename)]);            
            % Get information from initial C3D file
            static = Session.Static(j).file;
            Marker = btkGetMarkers(static);
            fMarker = btkGetPointFrequency(static);
            % Set BTK parameters to export a new C3D file
            btk2 = btkNewAcquisition(btkGetPointNumber(static));
            btkSetFrameNumber(btk2,1);
            btkSetFrequency(btk2,fMarker);          
            % Import mean markers 3D position
            [Marker,btk2] = importStaticMarker(Marker,btk2);            
            % Lower limb kinematic chain
            Condition(i).Static.LowerLimb = [];
            if Session.Static(j).kinematics.lowerLimb == 1
                disp('      Lower limb');
                % Set body segments
                [Condition(i),Segment,Vmarker,btk2] = setStaticSegment_lowerLimb(Session,Patient,Condition(i),Marker,btk2);
            end
            % Upper limb kinematic chain
            % Head/Trunk limb kinematic chain
            % Foot limb kinematic chain
            % Compute leg length
            Session = setLegLength_lowerLimb(Session,Marker);
            % Export processed files
            cd(c3dFolder);
            btkWriteAcquisition(btk2,[strrep(Session.Static(j).filename,'.c3d',''),'_out.c3d']);
            cd(toolboxFolder);
        end
    end
    
    % ---------------------------------------------------------------------
    % Video
    % ---------------------------------------------------------------------
    
    % ---------------------------------------------------------------------
    % Trial
    % ---------------------------------------------------------------------    
    % Set the maximum values through the trial of a condition for EMGs
    % ---------------------------------------------------------------------
    MaxEMG = [];
    for j = 1:length(Session.Trial)
        if strcmp(Session.Trial(j).condition,Condition(i).name)
            trial = Session.Trial(j).file;
            Analog = btkGetAnalogs(trial);
            fAnalog = btkGetAnalogFrequency(trial);
            n = btkGetLastFrame(trial)-btkGetFirstFrame(trial)+1;
            MaxEMG = setMaxEMG(Session,Analog,MaxEMG,n,fAnalog);
        end
    end
    nMaxEMG = fieldnames(MaxEMG);
    for j = 1:length(nMaxEMG)
        MaxEMG.(nMaxEMG{j}).data = sort(MaxEMG.(nMaxEMG{j}).data,1,'descend');
        MaxEMG.(nMaxEMG{j}).max = mean(MaxEMG.(nMaxEMG{j}).data(1:10));
    end
    
    % Compute biomechanical parameters
    % ---------------------------------------------------------------------
    k = 1; % Index of the trial of the condition
    for j = 1:length(Session.Trial)
        if strcmp(Session.Trial(j).condition,Condition(i).name)
            
            % General treatment
            % -------------------------------------------------------------
            disp(['    - Trial',num2str(j),' = ',char(Session.Trial(j).filename)]);
            % Get information from initial C3D file
            trial = Session.Trial(j).file;
            Marker = btkGetMarkers(trial);
            Analog = btkGetAnalogs(trial);
            Event = btkGetEvents(trial);
            Forceplate = btkGetForcePlatforms(trial);
            tGrf = btkGetForcePlatformWrenches(trial); % used for c3d export
            Grf = btkGetGroundReactionWrenches(trial); % used for matlab process
            fMarker = btkGetPointFrequency(trial);
            fAnalog = btkGetAnalogFrequency(trial);
            n0 = btkGetFirstFrame(trial);
            n = btkGetLastFrame(trial)-btkGetFirstFrame(trial)+1;
            % Import markers 3D trajectories
            [Marker,btk2] = importTrialMarker(Marker,Event,n0,fMarker);
            % Import reaction forces
            [Grf,tGrf] = importTrialReaction(Event,Forceplate,tGrf,Grf,n0,n,fMarker,fAnalog);
            % Import EMG signals
            [EMG,btk2] = importTrialEMG(Session,Analog,Event,MaxEMG,btk2,n0,n,fMarker,fAnalog);
            % Update and export events
            [Event,btk2] = exportEvents(Event,trial,btk2,fMarker);
            % Export normalisation values
            btk2 = exportNormalisationValues(Session,Patient,MaxEMG,btk2);
            
            % Lower limb kinematic chain
            % -------------------------------------------------------------
            Condition(i).Trial(k).LowerLimb = [];
            if Session.Trial(j).kinematics.lowerLimb == 1
                disp('      Lower limb');
                % Set body segments for kinematics
                [Segment,Vmarker,btk2] = ...
                    setTrialSegment_kinematics_lowerLimb(Session,Patient,Condition(i),Marker,Event,Forceplate,tGrf,Grf,trial,btk2,fMarker);
                % Compute spatiotemporal parameters
                [Spatiotemporal,btk2] = computeSpatiotemporal_lowerLimb(Session,Vmarker,Event,fMarker,btk2);
                % Compute joint kinematics
                [Joint,btk2] = computeJointKinematics_lowerLimb(Segment,btk2);
                % Compute segment kinematics
                [Segment,btk2] = computeSegmentKinematics_lowerLimb(Segment,btk2);
                % Set body segments and joints for kinetics
                [Segment,Joint,Vmarker] = ...
                    setTrialSegment_kinetics_lowerLimb(Session,Patient,Condition(i),Segment,Joint,Marker,Event,Forceplate,tGrf,Grf,trial,btk2,fMarker);
                % Compute kinetics
                [Segment,Joint,btk2] = computeJointKinetics_lowerLimb(Session,Segment,Joint,fMarker,btk2);
                % Store data in Condition (keep only intra cycle data)
                Condition(i).Trial(k).LowerLimb = ...
                    exportCondition_lowerLimb(Condition(i).Trial(k).LowerLimb,Segment,Joint,Marker,Vmarker,EMG,Event,Spatiotemporal,fMarker);
            end
            
            % Upper limb kinematic chain
            % -------------------------------------------------------------
            
            % Head/Trunk limb kinematic chain
            % -------------------------------------------------------------
            
            % Foot limb kinematic chain
            % -------------------------------------------------------------
                        
            % Export processed files
            % -------------------------------------------------------------
            cd(c3dFolder);
            btkWriteAcquisition(btk2,[strrep(Session.Trial(j).filename,'.c3d',''),'_out.c3d']);   
%             system(['C:\ProgramData\Mokka\Mokka.exe -c ',toolboxFolder,'\LWBM_model.mvc -p ',strrep(Session.Trial(j).filename,'.c3d',''),'_out.c3d']);
            cd(toolboxFolder);
            
            % Merge files of a same condition
            % -------------------------------------------------------------
            cd(c3dFolder);
            writeConditionC3d(Session,Condition(i),btk2,Session.Trial(j).filename,k);
            cd(toolboxFolder);
            k = k+1;
        end
    end 
    cd(c3dFolder);
    filename = [Patient.lastname,'_',Patient.firstname,'_',regexprep(Patient.birthdate,'/',''),'_',Condition.name,'_',regexprep(Session.date,'/',''),'.c3d'];
    system(['ren temp.c3d ',filename]);
    save([filename,'.mat']);
    system(['C:\ProgramData\Mokka\Mokka.exe -c ',toolboxFolder,'\LWBM_model.mvc -p ',filename]);
    cd(toolboxFolder);
end