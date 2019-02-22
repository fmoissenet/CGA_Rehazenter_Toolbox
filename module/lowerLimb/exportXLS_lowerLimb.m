% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportXLS_lowerLimb
% -------------------------------------------------------------------------
% Subject:      Complete the XLS file with CGA data
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 21/02/2019
% Version: 1
% =========================================================================

function exportXLS_lowerLimb(Condition,i,sessionFolder,toolboxFolder)

cd(sessionFolder);
xlsfile = [sessionFolder,'\CGAReport.xlsm'];
Excel = actxserver ('Excel.Application');
File = xlsfile;
if ~exist(File,'file')
    ExcelWorkbook = Excel.workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
invoke(Excel.Workbooks,'Open',File);

nline = 107*i-107+1;

% =========================================================================
% Kinematics
% =========================================================================
sheet = 'Examen - data (1)';
xlswrite1(File,cellstr(['Condition ',num2str(i)]),sheet,['A',num2str(nline)]);
xlswrite1(File,cellstr('Temps'),sheet,['A',num2str(nline+4)]);
xlswrite1(File,(0:1:100)',sheet,['A',num2str(nline+5)]);
xlswrite1(File,{'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' 'Bassin' ...
    'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' 'Hanche' ...
    'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' 'Genou' ...
    'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' 'Cheville' ...
    'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied'},sheet,['B',num2str(nline+1)]);
xlswrite1(File,{'Anteversion (+) / Retroversion (-) (°)' 'Anteversion (+) / Retroversion (-) (°)' 'Anteversion (+) / Retroversion (-) (°)' 'Anteversion (+) / Retroversion (-) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Rotation (externe + / interne -) (°)' 'Rotation (externe + / interne -) (°)' 'Rotation (externe + / interne -) (°)' 'Rotation (externe + / interne -) (°)' ...
    'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' ...
    'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Adduction (+) / Abduction (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' ...
    'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Eversion (+) / Inversion (-) (°)' 'Eversion (+) / Inversion (-) (°)' 'Eversion (+) / Inversion (-) (°)' 'Eversion (+) / Inversion (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' 'Rotation interne (+) / externe (-) (°)' ...
    'Anteversion (+) / Retroversion (-) (°)' 'Anteversion (+) / Retroversion (-) (°)' 'Anteversion (+) / Retroversion (-) (°)' 'Anteversion (+) / Retroversion (-) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Inclinaison (élévation + / chute -) (°)' 'Rotation (externe + / interne -) (°)' 'Rotation (externe + / interne -) (°)' 'Rotation (externe + / interne -) (°)' 'Rotation (externe + / interne -) (°)'},sheet,['B',num2str(nline+2)]);
xlswrite1(File,{'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' ...
    'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite'},sheet,['B',num2str(nline+3)]);
xlswrite1(File,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
    'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type'},sheet,['B',num2str(nline+4)]);
%---
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_FE.mean,sheet,['B',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_FE.std,sheet,['C',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_FE.mean,sheet,['D',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_FE.std,sheet,['E',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_AA.mean,sheet,['F',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_AA.std,sheet,['G',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_AA.mean,sheet,['H',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_AA.std,sheet,['I',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_IER.mean,sheet,['J',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Pelvis_Angle_IER.std,sheet,['K',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_IER.mean,sheet,['L',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Pelvis_Angle_IER.std,sheet,['M',num2str(nline+5)]);
%---
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Hip_Angle_FE.mean,sheet,['N',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Hip_Angle_FE.std,sheet,['O',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Hip_Angle_FE.mean,sheet,['P',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Hip_Angle_FE.std,sheet,['Q',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Hip_Angle_AA.mean,sheet,['R',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Hip_Angle_AA.std,sheet,['S',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Hip_Angle_AA.mean,sheet,['T',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Hip_Angle_AA.std,sheet,['U',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Hip_Angle_IER.mean,sheet,['V',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Hip_Angle_IER.std,sheet,['W',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Hip_Angle_IER.mean,sheet,['X',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Hip_Angle_IER.std,sheet,['Y',num2str(nline+5)]);
%---
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Knee_Angle_FE.mean,sheet,['Z',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Knee_Angle_FE.std,sheet,['AA',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Knee_Angle_FE.mean,sheet,['AB',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Knee_Angle_FE.std,sheet,['AC',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Knee_Angle_AA.mean,sheet,['AD',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Knee_Angle_AA.std,sheet,['AE',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Knee_Angle_AA.mean,sheet,['AF',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Knee_Angle_AA.std,sheet,['AG',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Knee_Angle_IER.mean,sheet,['AH',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Knee_Angle_IER.std,sheet,['AI',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Knee_Angle_IER.mean,sheet,['AJ',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Knee_Angle_IER.std,sheet,['AK',num2str(nline+5)]);
%---
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_FE.mean,sheet,['AL',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_FE.std,sheet,['AM',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_FE.mean,sheet,['AN',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_FE.std,sheet,['AO',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_AA.mean,sheet,['AP',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_AA.std,sheet,['AQ',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_AA.mean,sheet,['AR',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_AA.std,sheet,['AS',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_IER.mean,sheet,['AT',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.L_Ankle_Angle_IER.std,sheet,['AU',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_IER.mean,sheet,['AV',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Jointkinematics.R_Ankle_Angle_IER.std,sheet,['AW',num2str(nline+5)]);
%---
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_FE.mean,sheet,['AX',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_FE.std,sheet,['AY',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_FE.mean,sheet,['AZ',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_FE.std,sheet,['BA',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_AA.mean,sheet,['BB',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_AA.std,sheet,['BC',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_AA.mean,sheet,['BD',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_AA.std,sheet,['BE',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_IER.mean,sheet,['BF',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.L_Foot_Angle_IER.std,sheet,['BG',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_IER.mean,sheet,['BH',num2str(nline+5)]);
xlswrite1(File,Condition(i).Average.LowerLimb.Segmentkinematics.R_Foot_Angle_IER.std,sheet,['BI',num2str(nline+5)]);

invoke(Excel.ActiveWorkbook,'Save');
Excel.ActiveWorkbook.Save
Excel.Quit
Excel.delete
clear Excel
cd(toolboxFolder);