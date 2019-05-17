% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importSessionInformation
% -------------------------------------------------------------------------
% Subject:      Load session, patient and pathology information
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function [Patient,Pathology,Treatment,Examination,Session,Condition] = ...
    importSessionInformation(Patient,Pathology,Treatment,Examination,Session,Condition,sessionFolder)

% =========================================================================
% Load session information file
% =========================================================================
cd(sessionFolder);
xlsfile = dir('template.xls*');
system('Taskkill /F /IM EXCEL.EXE');
Excel = actxserver('Excel.Application');
fname = fullfile(pwd,xlsfile(1).name);
if ~exist(fname,'file')
    ExcelWorkbook = Excel.Workbooks.Add;
    ExcelWorkbook.Sheets.Add;
    ExcelWorkbook.SaveAs(fname,1);
    ExcelWorkbook.Close(false);
end
% invoke(Excel.Workbooks,'Open',fname);
Excel.Workbooks.Open(fname);
[~,~,temp1] = xlsread1(Excel,xlsfile(1).name,1,'B2:K112');

% =========================================================================
% Get patient information
% =========================================================================
Patient.lastname = temp1{1,2};                                             % Patient last name
Patient.firstname = temp1{2,2};                                            % Patient first name
Patient.gender = temp1{3,2};                                               % Gender: 'Homme' or 'Femme'
Patient.birthdate = temp1{4,2};                                            % Patient date of birth (DD/MM/YYYY)

% =========================================================================
% Get pathology information
% =========================================================================
Pathology.diagnosis = temp1{9,2};                                          % Primary medical diagnosis
Pathology.comments = temp1{10,2};                                          % Comments
Pathology.accidentdate = temp1{11,2};                                      % Date of accident
Pathology.accidenttype = temp1{12,2};                                      % Type of accident
Pathology.affectedside = temp1{13,2};                                      % Affected side

% =========================================================================
% Get treatment information
% =========================================================================
Treatment.treatment1 = temp1{16,2};                                        % Previous treatment 1
Treatment.treatment1date = temp1{16,8};                                    % Previous treatment 1 date (DD/MM/YYYY)
Treatment.treatment2 = temp1{17,2};                                        % Previous treatment 2
Treatment.treatment2date = temp1{17,8};                                    % Previous treatment 2 date (DD/MM/YYYY)
Treatment.treatment3 = temp1{18,2};                                        % Previous treatment 3
Treatment.treatment3date = temp1{18,8};                                    % Previous treatment 3 date (DD/MM/YYYY)
Treatment.treatment4 = temp1{19,2};                                        % Previous treatment 4
Treatment.treatment4date = temp1{19,8};                                    % Previous treatment 4 date (DD/MM/YYYY)
Treatment.treatment5 = temp1{20,2};                                        % Previous treatment 5
Treatment.treatment5date = temp1{20,8};                                    % Previous treatment 5 date (DD/MM/YYYY)
Treatment.treatment6 = temp1{21,2};                                        % Previous treatment 6
Treatment.treatment6date = temp1{21,8};                                    % Previous treatment 6 date (DD/MM/YYYY)

% =========================================================================
% Get session information
% =========================================================================
Session.age = [];                                                          % Patient age, based on session year
Session.weight = temp1{5,2};                                               % Patient weight (kg)
Session.height = temp1{6,2}*1e-2;                                          % Patient height (m)
Session.R_legLength = [];
Session.L_legLength = [];
if ~isnan(temp1{24,2})
    Session.clinician = temp1{24,2};                                       % Medical doctor
else
    Session.clinician = '';
end
if ~isnan(temp1{25,2})
    Session.operator = temp1{25,2};                                        % Technician
else
    Session.operator = '';
end
if ~isnan(temp1{26,2})
    Session.date = temp1{26,2};                                            % Date
    Session.age = str2num(Session.date(7:10)) - ...
                  str2num(Patient.birthdate(7:10));
else
    Session.date = '';
end
Session.date = temp1{26,2};                                                % Date of the session (DD/MM/YYYY)
if ~isnan(temp1{27,2})
    Session.reason = temp1{27,2};                                          % Session reason
else
    Session.reason = '';
end
if ~isempty(temp1{28,2})
    Session.comments = temp1{28,2};                                        % Medical request
else
    Session.comments = '';
end

% =========================================================================
% Get protocol information
% =========================================================================
Session.course = temp1{31,5};                                              % Gait course: 'Piste de marche' or 'Tapis de marche'
if ~strcmp(temp1{32,5},'Aucun modèle')
    Session.markerSet.lowerLimb = temp1{32,5};                             % Markers set used for each kinematic chain
else
    Session.markerSet.lowerLimb = '';
end
if ~strcmp(temp1{33,5},'Aucun modèle')
    Session.markerSet.upperLimb = temp1{33,5};                                
else
    Session.markerSet.upperLimb = '';
end
if ~strcmp(temp1{34,5},'Aucun modèle')
    Session.markerSet.headTrunk = temp1{34,5};                                
else
    Session.markerSet.headTrunk = '';
end
if ~strcmp(temp1{35,5},'Aucun modèle')
    Session.markerSet.foot = temp1{35,5};                                
else
    Session.markerSet.foot = '';
end   
Session.EMG{1} = temp1{36,4};                                              % EMG channels (please use 'side_name1_name2' format)
Session.EMG{2} = temp1{37,4};                                              % if none, put 'none'
Session.EMG{3} = temp1{38,4}; 
Session.EMG{4} = temp1{39,4}; 
Session.EMG{5} = temp1{40,4}; 
Session.EMG{6} = temp1{41,4}; 
Session.EMG{7} = temp1{42,4}; 
Session.EMG{8} = temp1{43,4}; 
Session.EMG{9} = temp1{36,5}; 
Session.EMG{10} = temp1{37,5}; 
Session.EMG{11} = temp1{38,5}; 
Session.EMG{12} = temp1{39,5}; 
Session.EMG{13} = temp1{40,5}; 
Session.EMG{14} = temp1{41,5}; 
Session.EMG{15} = temp1{42,5}; 
Session.EMG{16} = temp1{43,5}; 

% =========================================================================
% Get static, video, trial index
% =========================================================================
index_static = [];
index_video = [];
index_trial = [];
for i = 1:65
    if ~isempty(temp1(i+47-1,1))
        if strncmp(temp1{i+47-1,1},'static',6)
            index_static = [index_static i+47-1];
        elseif strncmp(temp1{i+47-1,1},'trial',5)
            index_trial = [index_trial i+47-1];
        end
    end
end

% =========================================================================
% Get static information
% =========================================================================
j = 1;
Session.Static = [];
for i = index_static(1):index_static(end)
    if ~isnan(temp1{i,4})                                                  % If no condition is defined, the file is not used
        Session.Static(j).filename = [temp1{i,1},'.c3d'];
        Session.Static(j).condition = temp1{i,4};
        if ~isnan(temp1{i,5})
            Session.Static(j).details = temp1{i,5};
        else
            Session.Static(j).details = '';
        end    
        if strcmp(temp1{i,6},'X')                                          % The current record has been selected as a minf trial
            Session.Static(j).kinematics.lowerLimb = 1;
        else
            Session.Static(j).kinematics.lowerLimb = 0;
        end
        if strcmp(temp1{i,7},'X')                                          % The current record has been selected as a msup trial
            Session.Static(j).kinematics.upperLimb = 1;
        else
            Session.Static(j).kinematics.upperLimb = 0;
        end
        if strcmp(temp1{i,8},'X')                                          % The current record has been selected as a mpost trial
            Session.Static(j).kinematics.headTrunk = 1;
        else
            Session.Static(j).kinematics.headTrunk = 0;
        end
        if strcmp(temp1{i,9},'X')                                          % The current record has been selected as a mfoot trial
            Session.Static(j).kinematics.foot = 1;
        else
            Session.Static(j).kinematics.foot = 0;
        end
        if strcmp(temp1{i,10},'X')                                         % The current record has been selected as a video trial
            Session.Static(j).video = 1;
        else
            Session.Static(j).video = 0;
        end
        j = j+1;
    end
end

% =========================================================================
% Get records information
% =========================================================================
j = 1;
Session.Trial = [];
for i = index_trial(1):index_trial(end)
    if ~isnan(temp1{i,4})                                                  % If no condition is defined, the file is not used
        Session.Trial(j).filename = [temp1{i,1},'.c3d'];
        Session.Trial(j).s(1,1) = temp1{i,2};                              % Column 1: right foot, column2: left foot
        Session.Trial(j).s(1,2) = temp1{i,3};                              % No GRF: 0, GRF on forceplate1: 1, GRF onf forceplate2: 2
        Session.Trial(j).condition = temp1{i,4};
        if ~isnan(temp1{i,5})
            Session.Trial(j).details = temp1{i,5};
        else
            Session.Trial(j).details = '';
        end
        if strcmp(temp1{i,6},'X')                                          % The current record has been selected as a minf trial
            Session.Trial(j).kinematics.lowerLimb = 1;
        else
            Session.Trial(j).kinematics.lowerLimb = 0;
        end
        if strcmp(temp1{i,7},'X')                                          % The current record has been selected as a msup trial
            Session.Trial(j).kinematics.upperLimb = 1;
        else
            Session.Trial(j).kinematics.upperLimb = 0;
        end
        if strcmp(temp1{i,8},'X')                                          % The current record has been selected as a mpost trial
            Session.Trial(j).kinematics.headTrunk = 1;
        else
            Session.Trial(j).kinematics.headTrunk = 0;
        end
        if strcmp(temp1{i,9},'X')                                          % The current record has been selected as a mfoot trial
            Session.Trial(j).kinematics.foot = 1;
        else
            Session.Trial(j).kinematics.foot = 0;
        end
        if strcmp(temp1{i,10},'X')                                         % The current record has been selected as a video trial
            Session.Trial(j).video = 1;
        else
            Session.Trial(j).video = 0;
        end
        j = j+1;
    end
end 
    
% =========================================================================
% Close ActiveX port
% =========================================================================
Excel.ActiveWorkbook.Save;
Excel.Quit
Excel.delete
clear Excel 
system('Taskkill /F /IM EXCEL.EXE');

% =========================================================================
% Extract conditions and details from Session.Trial
% =========================================================================
temp1 = cell(0);
temp2 = cell(0);
for i = 1:length(Session.Trial)
    count1 = 0;
    if ~isempty(temp1)
        for j = 1:length(temp1)
            if ~strcmp(temp1{j},Session.Trial(i).condition)
                count1 = count1+1;
            end
        end
        if count1 == length(temp1)
            temp1{length(temp1)+1} = Session.Trial(i).condition;
            temp2{length(temp2)+1} = Session.Trial(i).details;
        end
    else
        temp1{length(temp1)+1} = Session.Trial(i).condition;
        temp2{length(temp2)+1} = Session.Trial(i).details;
    end
end
Session.conditions = temp1;
Session.details = temp2;
for i = 1:length(Session.conditions)
    Condition(i).name = Session.conditions{i};
    k = 1;
    for j = 1:length(Session.Trial)
        if strcmp(Session.Trial(j).condition,Condition(i).name)
            Condition(i).details{k} = Session.Trial(j).details;
            k = k+1;
        end
    end
    Condition(i).Trial = [];
end