% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    importClinicalExamination
% -------------------------------------------------------------------------
% Subject:      Load clinical examination data
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function Examination = importClinicalExamination(Examination,sessionFolder)

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
invoke(Excel.Workbooks,'Open',fname);

% =========================================================================
% Load clinical examination data
% =========================================================================
[~,~,Examination.L_Hip1] = xlsread1(Excel,xlsfile(1).name,8,'H4:I12');
[~,~,Examination.L_Hip2] = xlsread1(Excel,xlsfile(1).name,8,'H54:I65');
[~,~,Examination.L_Knee1] = xlsread1(Excel,xlsfile(1).name,8,'H14:I22');
[~,~,Examination.L_Knee2] = xlsread1(Excel,xlsfile(1).name,8,'H67:I67');
[~,~,Examination.L_Ankle1] = xlsread1(Excel,xlsfile(1).name,8,'H24:I33');
[~,~,Examination.L_Ankle2] = xlsread1(Excel,xlsfile(1).name,8,'H69:I75');
[~,~,Examination.L_Foot1] = xlsread1(Excel,xlsfile(1).name,8,'H35:I39');
[~,~,Examination.L_Foot2] = xlsread1(Excel,xlsfile(1).name,8,'H77:I86');

[~,~,Examination.R_Hip1] = xlsread1(Excel,xlsfile(1).name,8,'J4:K12');
[~,~,Examination.R_Hip2] = xlsread1(Excel,xlsfile(1).name,8,'J54:K65');
[~,~,Examination.R_Knee1] = xlsread1(Excel,xlsfile(1).name,8,'J14:K22');
[~,~,Examination.R_Knee2] = xlsread1(Excel,xlsfile(1).name,8,'J67:K67');
[~,~,Examination.R_Ankle1] = xlsread1(Excel,xlsfile(1).name,8,'J24:K33');
[~,~,Examination.R_Ankle2] = xlsread1(Excel,xlsfile(1).name,8,'J69:K75');
[~,~,Examination.R_Foot1] = xlsread1(Excel,xlsfile(1).name,8,'J35:K39');
[~,~,Examination.R_Foot2] = xlsread1(Excel,xlsfile(1).name,8,'J77:K86');

[~,~,Examination.Sensitivity] = xlsread1(Excel,xlsfile(1).name,8,'E89:F90');
[~,~,Examination.Others] = xlsread1(Excel,xlsfile(1).name,8,'F93:F96');

[~,~,Examination.Comments] = xlsread1(Excel,xlsfile(1).name,8,'B42:K50');
    
% =========================================================================
% Close ActiveX port
% =========================================================================
Excel.ActiveWorkbook.Save;
Excel.Quit
Excel.delete
clear Excel 
system('Taskkill /F /IM EXCEL.EXE');