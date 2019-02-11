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
    startCGA(toolboxFolder,c3dFolder)

% =========================================================================
% Initialise structures
% =========================================================================
cd(toolboxFolder);
Patient = [];
Pathology = [];
Treatment = [];
Examination = [];
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
% Import clinical examination
% =========================================================================
disp('>> Import clinical examination ...');
Examination = importClinicalExamination(Examination,c3dFolder);
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
            btk2 = btkNewAcquisition(btkGetPointNumber(static)-4); % The 4 head markers are removed
            btkSetFrameNumber(btk2,1);
            btkSetFrequency(btk2,fMarker);          
            % Import mean markers 3D position
            [Marker,btk2] = importStaticMarker(Marker,btk2);            
            % Compute leg length
            Session = setLegLength_lowerLimb(Session,Marker);
            % Export raw and processed files
            if j == 1
                cd(c3dFolder);
                btkWriteAcquisition(btk2,[Patient.lastname(3:end),'_','ST','.c3d']);
                cd(toolboxFolder);
            end
        end
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
            [Marker,btk2] = importTrialMarker(Marker,Event,n0,fMarker,fAnalog);
            % Import reaction forces
            [Grf,tGrf] = importTrialReaction(Event,Forceplate,tGrf,Grf,btk2,n0,n,fMarker,fAnalog);
            % Import EMG signals
            MaxEMG = [];
            [EMG,btk2] = importTrialEMG(Session,Analog,Event,MaxEMG,btk2,n0,n,fMarker,fAnalog);
            % Update and export events
            [Event,btk2] = exportEvents(Event,trial,btk2,fMarker);
            % Export normalisation values
            btk2 = exportNormalisationValues(Session,Patient,btk2);
            % Set forceplates
            btkAppendForcePlatformType2(btk2,tGrf(1).F,...
                tGrf(1).M,Forceplate(1).corners',[0,0,0],[0,0,0]);
            btkAppendForcePlatformType2(btk2,tGrf(2).F,...
                tGrf(2).M,Forceplate(2).corners',[0,0,0],[0,0,0]);
                        
            % Export processed files
            % -------------------------------------------------------------
            cd(c3dFolder);
            btkWriteAcquisition(btk2,[Patient.lastname(3:end),'_',Condition(i).name,'_','0',num2str(k),'.c3d']);
            cd(toolboxFolder);
            k = k+1;
        end
    end 
end