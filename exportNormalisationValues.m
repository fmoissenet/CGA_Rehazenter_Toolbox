% =========================================================================
% REHAZENTER CLINICAL GAIT ANALYSIS TOOLBOX
% =========================================================================
% File name:    exportNormalisationValues
% -------------------------------------------------------------------------
% Subject:      Export to C3D metadata all information required to remove
%               data normalisation
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber
% Date of creation: 16/05/2018
% Version: 1
% =========================================================================

function btk2 = exportNormalisationValues(Session,Patient,MaxEMG,btk2)

nMaxEMG = fieldnames(MaxEMG);
info.format = 'Integer';
info.values = length(nMaxEMG)+6;
btkAppendMetaData(btk2,'NORMALISATION','USED',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',length(nMaxEMG)+6];
info.values(1:6) = {'gravityConstant' 'gender' 'weight' 'height' ...
    'R_legLength' 'L_legLength'};
for i = 1:length(nMaxEMG)
    info.values(i+6) = {nMaxEMG{i}};
end
btkAppendMetaData(btk2,'NORMALISATION','LABELS',info);
clear info;
info.format = 'Char';
info.dimensions = ['1x',length(nMaxEMG)+6];
info.values(1:6) = {'m/s²' 'adimensioned (0: woman, 1: man)' 'kg' 'm' 'm' 'm'};
for i = 1:length(nMaxEMG)
    info.values(i+6) = {'mV'};
end
btkAppendMetaData(btk2,'NORMALISATION','UNITS',info);
clear info;
info.format = 'Real';
info.dimensions = ['1x',length(nMaxEMG)+6];
info.values(1) = 9.81;
if strcmp(Patient.gender,'Homme')
    info.values(2) = 1;
elseif strcmp(Patient.gender,'Femme')
    info.values(2) = 0;
end
info.values(3) = Session.weight;
info.values(4) = Session.height;
info.values(5) = Session.R_legLength;
info.values(6) = Session.L_legLength;
for i = 1:length(nMaxEMG)
    info.values(i+6) = MaxEMG.(nMaxEMG{i}).max;
end
btkAppendMetaData(btk2,'NORMALISATION','VALUES',info);