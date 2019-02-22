% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportMAT
% -------------------------------------------------------------------------
% Subject:      Export CGA data in a MAT file
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 21/02/2019
% Version: 1
% =========================================================================

function exportMAT(Patient,Pathology,Treatment,Examination,Session,...
                   Condition,i,sessionFolder,toolboxFolder)

cd(sessionFolder);
filename = [Patient.lastname,'_',Patient.firstname,'_',regexprep(Patient.birthdate,'/',''),'_',Condition(i).name,'_',regexprep(Session.date,'/','')];
tCondition = Condition; clear Condition; Condition = tCondition(i);
save([filename,'.mat'],'Patient','Pathology','Treatment','Examination','Session','Condition');
cd(toolboxFolder);