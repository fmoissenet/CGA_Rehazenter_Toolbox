% function writeReport()

clearvars;
clc;

copyfile template.xlsm test.xlsm;

Excel = actxserver ('Excel.Application');
File = 'C:\Users\florent.moissenet\Desktop\Rapport RB\test.xlsm';
if ~exist(File,'file')
ExcelWorkbook = Excel.workbooks.Add;
ExcelWorkbook.SaveAs(File,1);
ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

norm = load('Norm_V1.mat');
data = load('Norm_V4.mat');

% SUBJECT DATA
% Pelvis kinematics
xlswrite1(File,data.Normatives.Kinematics.Ptilt.mean,'Examen - data (1)','B4:B104'); % left
xlswrite1(File,data.Normatives.Kinematics.Ptilt.mean,'Examen - data (1)','C4:C104'); % right
xlswrite1(File,data.Normatives.Kinematics.Pobli.mean,'Examen - data (1)','D4:D104'); % ...
xlswrite1(File,data.Normatives.Kinematics.Pobli.mean,'Examen - data (1)','E4:E104');
xlswrite1(File,data.Normatives.Kinematics.Prota.mean,'Examen - data (1)','F4:F104');
xlswrite1(File,data.Normatives.Kinematics.Prota.mean,'Examen - data (1)','G4:G104');
% Hip kinematics
xlswrite1(File,data.Normatives.Kinematics.FE4.mean,'Examen - data (1)','H4:H104'); % left
xlswrite1(File,data.Normatives.Kinematics.FE4.mean,'Examen - data (1)','I4:I104'); % right
xlswrite1(File,data.Normatives.Kinematics.AA4.mean,'Examen - data (1)','J4:J104'); % ...
xlswrite1(File,data.Normatives.Kinematics.AA4.mean,'Examen - data (1)','K4:K104');
xlswrite1(File,data.Normatives.Kinematics.IER4.mean,'Examen - data (1)','L4:L104');
xlswrite1(File,data.Normatives.Kinematics.IER4.mean,'Examen - data (1)','M4:M104');
% Knee kinematics
xlswrite1(File,data.Normatives.Kinematics.FE3.mean,'Examen - data (1)','N4:N104'); % left
xlswrite1(File,data.Normatives.Kinematics.FE3.mean,'Examen - data (1)','O4:O104'); % right
xlswrite1(File,data.Normatives.Kinematics.AA3.mean,'Examen - data (1)','P4:P104'); % ...
xlswrite1(File,data.Normatives.Kinematics.AA3.mean,'Examen - data (1)','Q4:Q104');
xlswrite1(File,data.Normatives.Kinematics.IER3.mean,'Examen - data (1)','R4:R104');
xlswrite1(File,data.Normatives.Kinematics.IER3.mean,'Examen - data (1)','S4:S104');
% Ankle kinematics
xlswrite1(File,data.Normatives.Kinematics.FE2.mean,'Examen - data (1)','T4:T104'); % left
xlswrite1(File,data.Normatives.Kinematics.FE2.mean,'Examen - data (1)','U4:U104'); % right
xlswrite1(File,data.Normatives.Kinematics.AA2.mean,'Examen - data (1)','V4:V104'); % ...
xlswrite1(File,data.Normatives.Kinematics.AA2.mean,'Examen - data (1)','W4:W104');
% Foot kinematics
xlswrite1(File,data.Normatives.Kinematics.Ftilt.mean,'Examen - data (1)','X4:X104'); % left
xlswrite1(File,data.Normatives.Kinematics.Ftilt.mean,'Examen - data (1)','Y4:Y104'); % right
xlswrite1(File,data.Normatives.Kinematics.Fobli.mean,'Examen - data (1)','Z4:Z104'); % ...
xlswrite1(File,data.Normatives.Kinematics.Fobli.mean,'Examen - data (1)','AA4:AA104');
xlswrite1(File,data.Normatives.Kinematics.Frota.mean,'Examen - data (1)','AB4:AB104');
xlswrite1(File,data.Normatives.Kinematics.Frota.mean,'Examen - data (1)','AC4:AC104');

% NORMATIVE DATA MEAN
% Pelvis kinematics
xlswrite1(File,norm.Normatives.Kinematics.Ptilt.mean,'Examen - norm (1)','B4:B104'); % left
xlswrite1(File,norm.Normatives.Kinematics.Ptilt.mean,'Examen - norm (1)','C4:C104'); % right
xlswrite1(File,norm.Normatives.Kinematics.Pobli.mean,'Examen - norm (1)','D4:D104'); % ...
xlswrite1(File,norm.Normatives.Kinematics.Pobli.mean,'Examen - norm (1)','E4:E104');
xlswrite1(File,norm.Normatives.Kinematics.Prota.mean,'Examen - norm (1)','F4:F104');
xlswrite1(File,norm.Normatives.Kinematics.Prota.mean,'Examen - norm (1)','G4:G104');
% Hip kinematics
xlswrite1(File,norm.Normatives.Kinematics.FE4.mean,'Examen - norm (1)','H4:H104'); % left
xlswrite1(File,norm.Normatives.Kinematics.FE4.mean,'Examen - norm (1)','I4:I104'); % right
xlswrite1(File,norm.Normatives.Kinematics.AA4.mean,'Examen - norm (1)','J4:J104'); % ...
xlswrite1(File,norm.Normatives.Kinematics.AA4.mean,'Examen - norm (1)','K4:K104');
xlswrite1(File,norm.Normatives.Kinematics.IER4.mean,'Examen - norm (1)','L4:L104');
xlswrite1(File,norm.Normatives.Kinematics.IER4.mean,'Examen - norm (1)','M4:M104');
% Knee kinematics
xlswrite1(File,norm.Normatives.Kinematics.FE3.mean,'Examen - norm (1)','N4:N104'); % left
xlswrite1(File,norm.Normatives.Kinematics.FE3.mean,'Examen - norm (1)','O4:O104'); % right
xlswrite1(File,norm.Normatives.Kinematics.AA3.mean,'Examen - norm (1)','P4:P104'); % ...
xlswrite1(File,norm.Normatives.Kinematics.AA3.mean,'Examen - norm (1)','Q4:Q104');
xlswrite1(File,norm.Normatives.Kinematics.IER3.mean,'Examen - norm (1)','R4:R104');
xlswrite1(File,norm.Normatives.Kinematics.IER3.mean,'Examen - norm (1)','S4:S104');
% Ankle kinematics
xlswrite1(File,norm.Normatives.Kinematics.FE2.mean,'Examen - norm (1)','T4:T104'); % left
xlswrite1(File,norm.Normatives.Kinematics.FE2.mean,'Examen - norm (1)','U4:U104'); % right
xlswrite1(File,norm.Normatives.Kinematics.AA2.mean,'Examen - norm (1)','V4:V104'); % ...
xlswrite1(File,norm.Normatives.Kinematics.AA2.mean,'Examen - norm (1)','W4:W104');
% Foot kinematics
xlswrite1(File,norm.Normatives.Kinematics.Ftilt.mean,'Examen - norm (1)','X4:X104'); % left
xlswrite1(File,norm.Normatives.Kinematics.Ftilt.mean,'Examen - norm (1)','Y4:Y104'); % right
xlswrite1(File,norm.Normatives.Kinematics.Fobli.mean,'Examen - norm (1)','Z4:Z104'); % ...
xlswrite1(File,norm.Normatives.Kinematics.Fobli.mean,'Examen - norm (1)','AA4:AA104');
xlswrite1(File,norm.Normatives.Kinematics.Frota.mean,'Examen - norm (1)','AB4:AB104');
xlswrite1(File,norm.Normatives.Kinematics.Frota.mean,'Examen - norm (1)','AC4:AC104');

% NORMATIVE DATA STD
% Pelvis kinematics
xlswrite1(File,norm.Normatives.Kinematics.Ptilt.std,'Examen - norm (1)','B109:B209'); % left
xlswrite1(File,norm.Normatives.Kinematics.Ptilt.std,'Examen - norm (1)','C109:C209'); % right
xlswrite1(File,norm.Normatives.Kinematics.Pobli.std,'Examen - norm (1)','D109:D209'); % ...
xlswrite1(File,norm.Normatives.Kinematics.Pobli.std,'Examen - norm (1)','E109:E209');
xlswrite1(File,norm.Normatives.Kinematics.Prota.std,'Examen - norm (1)','F109:F209');
xlswrite1(File,norm.Normatives.Kinematics.Prota.std,'Examen - norm (1)','G109:G209');
% Hip kinematics
xlswrite1(File,norm.Normatives.Kinematics.FE4.std,'Examen - norm (1)','H109:H209'); % left
xlswrite1(File,norm.Normatives.Kinematics.FE4.std,'Examen - norm (1)','I109:I209'); % right
xlswrite1(File,norm.Normatives.Kinematics.AA4.std,'Examen - norm (1)','J109:J209'); % ...
xlswrite1(File,norm.Normatives.Kinematics.AA4.std,'Examen - norm (1)','K109:K209');
xlswrite1(File,norm.Normatives.Kinematics.IER4.std,'Examen - norm (1)','L109:L209');
xlswrite1(File,norm.Normatives.Kinematics.IER4.std,'Examen - norm (1)','M109:M209');
% Knee kinematics
xlswrite1(File,norm.Normatives.Kinematics.FE3.std,'Examen - norm (1)','N109:N209'); % left
xlswrite1(File,norm.Normatives.Kinematics.FE3.std,'Examen - norm (1)','O109:O209'); % right
xlswrite1(File,norm.Normatives.Kinematics.AA3.std,'Examen - norm (1)','P109:P209'); % ...
xlswrite1(File,norm.Normatives.Kinematics.AA3.std,'Examen - norm (1)','Q109:Q209');
xlswrite1(File,norm.Normatives.Kinematics.IER3.std,'Examen - norm (1)','R109:R209');
xlswrite1(File,norm.Normatives.Kinematics.IER3.std,'Examen - norm (1)','S109:S209');
% Ankle kinematics
xlswrite1(File,norm.Normatives.Kinematics.FE2.std,'Examen - norm (1)','T109:T209'); % left
xlswrite1(File,norm.Normatives.Kinematics.FE2.std,'Examen - norm (1)','U109:U209'); % right
xlswrite1(File,norm.Normatives.Kinematics.AA2.std,'Examen - norm (1)','V109:V209'); % ...
xlswrite1(File,norm.Normatives.Kinematics.AA2.std,'Examen - norm (1)','W109:W209');
% Foot kinematics
xlswrite1(File,norm.Normatives.Kinematics.Ftilt.std,'Examen - norm (1)','X109:X209'); % left
xlswrite1(File,norm.Normatives.Kinematics.Ftilt.std,'Examen - norm (1)','Y109:Y209'); % right
xlswrite1(File,norm.Normatives.Kinematics.Fobli.std,'Examen - norm (1)','Z109:Z209'); % ...
xlswrite1(File,norm.Normatives.Kinematics.Fobli.std,'Examen - norm (1)','AA109:AA209');
xlswrite1(File,norm.Normatives.Kinematics.Frota.std,'Examen - norm (1)','AB109:AB209');
xlswrite1(File,norm.Normatives.Kinematics.Frota.std,'Examen - norm (1)','AC109:AC209');

invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel