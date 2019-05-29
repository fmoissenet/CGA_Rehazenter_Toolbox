% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    startReport
% -------------------------------------------------------------------------
% Subject:      Generate diagnosis and comparison reports of CGA
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 28/05/2018
% Version: 1
% =========================================================================

function startReport_lowerLimb(toolboxFolder,sessionFolder,patientFolder)

% =========================================================================
% Condition #1 (diagnosis condition - in case of multiple dates, the most recent exam)
% =========================================================================
cd(patientFolder);
filename = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Sélectionner le fichier MAT de la condition 1 (diagnostic)', 'MultiSelect','off');
load(filename,'-mat','Condition','Patient','Session');
tempC(1) = Condition;
tempS(1) = Session;

% =========================================================================
% Condition #2 (other condition)
% =========================================================================
temp = input('Est-ce que vous souhaitez charger une condition de comparaison (O/N) ? ','s');
if strcmp(temp,'O')
    clearvars -except tempC tempS Patient patientFolder sessionFolder toolboxFolder
    cd(patientFolder);
    filename = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
        'Sélectionner le fichier MAT de la condition 2 (comparaison)', 'MultiSelect','off');
    load(filename,'-mat','Condition','Patient','Session');
    tempC(2) = Condition;
    tempS(2) = Session;
end

% =========================================================================
% Merge conditions
% =========================================================================
clear Condition Session;
Condition = tempC;
Session = tempS;
clear tempC tempS;
        
% =========================================================================
% Generate diagnostic XLS report
% =========================================================================
for i = 1:length(Condition)
    exportXLS_lowerLimb(Condition,i,sessionFolder);
end
system(['rename template.xlsx ',Patient.lastname,'_',Patient.firstname,'_',regexprep(Patient.birthdate,'/',''),'_AQM_',regexprep(Session(1).date,'/',''),'.xlsx']);
cd(toolboxFolder);
disp('Le rapport a été généré !');